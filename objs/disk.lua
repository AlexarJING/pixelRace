local disk=class("disk")

function disk:initialize(car)
	self.type="disk"
	self.car=car
	self.x,self.y=car.body:getPosition()
	self.angle=car.body:getAngle()
	self.body = love.physics.newBody(game.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newCircleShape(0,0,10)
	self.fixture = love.physics.newFixture(self.body, self.shape, 0.1)
	self.fixture:setUserData(self)
	self.fixture:setGroupIndex(-1-car.index)
	self.visible=false
	self.posInRoad=car.posInRoad
	self.fly=false
	self.life=3
	self.enable=false
	self.time=2
end

function disk:lanch()
	if self.fly==true then return end
	self.body:setActive(true)
	self.body:setPosition(self.car.body:getPosition())
	self.body:setLinearVelocity(self.car.body:getLinearVelocity())
	self.body:applyTorque(50000)
	self.visible=true
	self.force=10000
	self.fly=true
	self.body:applyForce(math.axisRot(0,self.force,self.car.body:getAngle()))
	self.enable=true
end

function disk:goBack()
	local ox,oy=self.body:getPosition()
	local tx,ty=self.car.body:getPosition()	
	local dx=tx-ox
	local dy=ty-oy
	local fx,fy=500*dx,500*dy
	self.body:applyForce(fx,fy)


end

function disk:checkDist()
	local ox,oy=self.body:getPosition()
	local tx,ty=self.car.body:getPosition()	
	local dist=math.getDistance(ox,oy,tx,ty)
	if dist<10 and self.life<=0 then
		self.body:setLinearVelocity(0,0)
		self.fly=false
		self.life=3
		self.visible=false
		self.enable=false
		self.body:setPosition(self.car.body:getPosition())
		self.posInRoad=self.car.posInRoad
		self.time=2
	end
	if dist>500 then 
		self.life=0
	end
end


function disk:update()
	if not self.fly then
		self.body:setPosition(self.car.body:getPosition())
		self.posInRoad=self.car.posInRoad
		self.body:setActive(false)
	end

	if self.life<=0 then
		self:goBack()
	end
	self:checkDist()
	if self.fly and self.life>0 then
		self.time=self.time-1/60
		if self.time<0 then self.life=0 end
	end
end



function disk:draw()
	self:update()
	if not self.visible then return end
	self.alpha=math.getAlpha(math.getLoopDist(game.car.posInRoad,self.posInRoad,game.road.count))
	love.graphics.setColor(255, 50, 255, 255)
	local x,y=self.body:getPosition()
	love.graphics.circle("outline", x, y, 10)
	local x2,y2=self.body:getWorldPoints(0,10)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.line(x, y, x2, y2)
end




return disk