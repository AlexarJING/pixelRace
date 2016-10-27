tire=class("tire")


function tire:initialize(x,y,parent)
	self.localPos={x,y}
	self.parent=parent
	self.type="tire"
	self.body = love.physics.newBody(game.world, x,y, "dynamic")
	self.shape = love.physics.newRectangleShape(0.5*8, 1.25*8)
	self.fixture = love.physics.newFixture(self.body, self.shape,3)
	self.fixture:setGroupIndex( -1-self.parent.index )
	self.fixture:setUserData(self.parent)
	self.isFront=false
	self.color={255,0,0}
	self.posInRoad=self.parent.posInRoad
end

function tire:reset()
	self.body:setPosition(self.parent.body:getWorldPoints(unpack(self.localPos)))
	self.body:setAngle(self.parent.body:getAngle())
end

function tire:setActive(toggle)
	self.body:setActive(toggle)
end

function tire:getLateralVelocity()
	local axis=vec()
	axis.x , axis.y=self.body:getWorldVector(1, 0)
	local v=vec()
	v.x,v.y=self.body:getLinearVelocity()
	return (axis*v)*axis
end

function tire:getForwardVelocity()
	local axis=vec()
	axis.x , axis.y=self.body:getWorldVector(0, 1)
	local v=vec()
	v.x,v.y=self.body:getLinearVelocity()
	return (axis*v)*axis
end



function tire:updateFriction(dt)

	local maxLateralImp=self.parent.maxLImp

	if self.brake and (not self.isFront) then
		maxLateralImp=maxLateralImp/1.2
	elseif self.brake then
		maxLateralImp=maxLateralImp*1.2
	end

	local imp=self.body:getMass() * -self:getLateralVelocity()
	if imp:len()>maxLateralImp then
		if imp:len()>maxLateralImp then
			if game.rule.name=="drift" then self.parent.score=self.parent.score+1 end
			require("objs/trace"):new(self)
			self.parent.n2o=self.parent.n2o+0.1
			if self.parent.n2o>100 then self.parent.n2o=100 end
		end

		imp=imp*(maxLateralImp / imp:len())	
	end
	self.body:applyLinearImpulse(imp.x,imp.y)

	self.body:applyAngularImpulse(  0.6* self.body:getInertia()* -self.body:getAngularVelocity())

	if self.brake then

	else
		local v=self:getForwardVelocity()
		local currentSpeed=v:len()
		local currentNormal=v:normalized()
		local drag=-(self.parent.killSpeed*currentSpeed)/self.parent.shift/self.parent.powerRate
		local f=drag*currentNormal
		self.body:applyForce(f.x,f.y)
	end
end


function tire:updateDrive(dt,ai)

	local ds=0
	self.brake=false
	if ai then
		for k,v in pairs(self.parent.cmd) do
			if v=="forward" then ds=self.parent.maxFSpeed end
			if v=="back" then ds=self.parent.maxBSpeed end
			if v=="brake" then self.brake=true end
		end
	else
		if love.keyboard.isDown("w") then
			ds=self.parent.maxFSpeed
		end
		if love.keyboard.isDown("s") then
			ds=self.parent.maxBSpeed
		end
		if love.keyboard.isDown(" ") then
			self.brake=true
		end
	end

	if ds==0 then 
		self.parent.hitting=false
		return 
	else 
		self.parent.hitting=true
	end
	---获取当前速度
	local axis=vec()
	axis.x , axis.y=self.body:getWorldVector(0, 1)
	local v=vec()
	v.x,v.y=self.body:getLinearVelocity()
	local cs=v*axis

	---施加力
	local f=0
	local p=0
	if self.parent.isPowerUp then
		p=self.parent.powerUpPower
	end
	if ds>cs then
		f=self.parent.maxDriveForce+p
	elseif ds<cs then
		f=-self.parent.maxDriveForce
	else
		return
	end
	self.body:applyForce(f*axis.x,f*axis.y)

end

function tire:updateTurn(dt,ai)
	if not self.isFront then return end
	local torque=self.parent.turnPower
	local dtorque=0 
	if ai then
		for k,v in pairs(self.parent.cmd) do
			if v=="left" then dtorque=-torque end
			if v=="right" then dtorque=torque end
		end
	else
		if love.keyboard.isDown("a") then
			dtorque=-torque
		end
		if love.keyboard.isDown("d") then
			dtorque=torque
		end
	end

	local cAngle=self.parent.body:getAngle()
	local tAngle=self.body:getAngle()
	local dAngle=cAngle-tAngle
	
	local rate=1-self:getForwardVelocity():len()/500
	if rate<0 then rate=0 end
	local maxAngle
	if self.brake then 
		maxAngle=math.rad(20)
	else
		maxAngle=math.rad(5+25*rate)
	end

	if dAngle>maxAngle then
		self.body:setAngle(cAngle-maxAngle)
	elseif dAngle<-maxAngle then
		self.body:setAngle(cAngle+maxAngle)

	else
		self.body:applyTorque(dtorque)
	end
	if dAngle>0.1 and dtorque==0 then
		self.body:applyTorque(torque)
	elseif dAngle<-0.1 and dtorque==0 then
		self.body:applyTorque(-torque)
	end
end




function tire:draw(alpha)
	self.alpha=alpha
	love.graphics.setColor(255, 0, 0, alpha)
	love.graphics.polygon("outline",self.body:getWorldPoints(self.shape:getPoints()))
end

function tire:update(dt,toggle)
	self:updateFriction(dt)
	self:updateDrive(dt,toggle)
	self:updateTurn(dt,toggle)
end

return tire
