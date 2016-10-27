local car=class("car")
local parts={"chassis","body","engine","transmission","tire","nitro","disk","painting"}
local function carInit(self,isPlayer)
	local lvl=10-player.career.ring
	local rnd= love.math.random(-100,100)
	if isPlayer and not game.isRapid then
		self.maxFSpeed=700+player.part.chassis*100
		self.maxBSpeed=-200
		self.maxDriveForce=100
		self.maxLImp=70+player.part.tire*5
		self.killSpeed=3.5-player.part.body/10
		self.turnPower=1000
		self.power=2000+400*player.part.engine
		self.powerRate=1+player.part.chassis/10
		self.powerUpPower=700+player.part.nitro*150
		self.color=player.color
	else
		self.maxFSpeed=700+lvl*50+rnd
		self.maxBSpeed=-200
		self.maxDriveForce=100
		self.maxLImp=80+rnd/10
		self.killSpeed=3.5+rnd/100
		self.turnPower=1000
		self.power=2000+200*lvl+rnd*3
		self.powerRate=1
		self.powerUpPower=700+lvl*50+rnd
		self.color={love.math.random(0,255),love.math.random(0,255),love.math.random(0,255)}
	end

end


function car:initialize(isPlayer)

	carInit(self,isPlayer)

	self.isAutoTrans=true
	game.carIndex=game.carIndex+1
	self.index=game.carIndex
	self.type="car"
	self.body = love.physics.newBody(game.world, 0, 0, "dynamic")
	self.body:setAngularDamping(3)

	self.visible=true	
	self.posInRoad=1
	self.oPos=1
	self.lap=1
	self.isAICtrl=true
	self.stop=0
	self.shift=1
	self.isPowerUp=false
	self.n2o=100
	self.cmd={}
	self.maxWall=100
	self.disk=require("objs/disk"):new(self)
	self.res=1
	self.enable=true
	self.diskRecharge_max=5
	self.diskRecharge=1
	self.score=0
--------------item--------------------
	self.item={}
	self.item[1]={}
	self.item[2]={}
	self.itemFunc={}
	self.target={}
	self.antiCount={}
	self.temp={}
	self.shieldActive=false
	self.hurt=0
	self.flag=0
	self.time=0
	self.finished=false
	self.name=string.generateName(love.math.random(3,5))
-------------------physic----------------
	local tab={1.5,0,
			3,2.5,
			2.8,5.5,
			1,10,
			-1,10,
			-2.8,5.5,
			-3,2.5,
			-1.5,0}
	for k,v in pairs(tab) do
		tab[k]=v*4
	end
	self.shape = love.physics.newPolygonShape(tab)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setUserData(self)
	self.fixture:setGroupIndex( -1-self.index )

	self.shell={}
	for i=1,5 do
		self.shell[i]={}
	end
	self.shell[1].shape = love.physics.newPolygonShape(-16,-3,16,-3,16,40,-16,40)
	self.shell[1].fixture = love.physics.newFixture(self.body, self.shell[1].shape,1)
	self.shell[1].fixture:setUserData(self)
	self.shell[1].fixture:setGroupIndex( -1-self.index )
	self.shell[1].fixture:setRestitution(self.res)
	self.shell[2].shape = love.physics.newCircleShape(-15,-2,2)
	self.shell[2].fixture = love.physics.newFixture(self.body, self.shell[2].shape,0.01)
	self.shell[2].fixture:setUserData(self)
	self.shell[2].fixture:setGroupIndex( -1-self.index )	
	self.shell[2].fixture:setRestitution(self.res)
	self.shell[3].shape = love.physics.newCircleShape(15,2,2)
	self.shell[3].fixture = love.physics.newFixture(self.body, self.shell[3].shape,0.01)
	self.shell[3].fixture:setUserData(self)
	self.shell[3].fixture:setGroupIndex( -1-self.index )	
	self.shell[3].fixture:setRestitution(self.res)
	self.shell[4].shape = love.physics.newCircleShape(15,39,2)
	self.shell[4].fixture = love.physics.newFixture(self.body, self.shell[4].shape,0.01)
	self.shell[4].fixture:setUserData(self)
	self.shell[4].fixture:setGroupIndex( -1-self.index )	
	self.shell[4].fixture:setRestitution(self.res)
	self.shell[5].shape = love.physics.newCircleShape(-15,39,2)
	self.shell[5].fixture = love.physics.newFixture(self.body, self.shell[5].shape,0.01)
	self.shell[5].fixture:setUserData(self)
	self.shell[5].fixture:setGroupIndex( -1-self.index )	
	self.shell[5].fixture:setRestitution(self.res)
-- tiresPos -12,3;12,3,-12,34,12,34

	self.tires={}
	local jointDef={}
	jointDef.bodyA=self.body
	jointDef.enableLimit=true
    local makeTire=require("objs/tires")
    local tire=makeTire:new(-3*4,0.75*4,self)
    jointDef.bodyB=tire.body
    local joint = love.physics.newWeldJoint(jointDef.bodyA, jointDef.bodyB, 0, 0, false)
    self.tires[1]=tire



    local makeTire=require("objs/tires")
    local tire=makeTire:new(3*4,0.75*4,self)
    jointDef.bodyB=tire.body
    local joint = love.physics.newWeldJoint(jointDef.bodyA, jointDef.bodyB, 0, 0, false) 
    self.tires[2]=tire



    local makeTire=require("objs/tires")
    local tire=makeTire:new(-3*4,8.5*4,self)
    jointDef.bodyB=tire.body
    local joint=love.physics.newRevoluteJoint(jointDef.bodyA, jointDef.bodyB, -3*4,8.5*4, false) 
    self.tires[3]=tire
    self.flJoint=joint
    tire.parent=self
    tire.isFront=true


    local makeTire=require("objs/tires")
    local tire=makeTire:new(3*4,8.5*4,self)
    jointDef.bodyB=tire.body
    local joint=love.physics.newRevoluteJoint(jointDef.bodyA, jointDef.bodyB, 3*4,8.5*4, false) 
    self.tires[4]=tire
    self.frJoint=joint
    tire.parent=self
    tire.isFront=true


end


function car:setPosition(px,py)
	self.body:setPosition(px,py)
    for k,v in pairs(self.tires) do
        v.body:setPosition(px,py) 
    end
end

function car:setActive(toggle)
	self.visible=toggle
	self.body:setActive(toggle)
	for k,v in pairs(self.tires) do
		v.body:setActive(toggle)
	end
end

function car:getForwardSpeed()
	local axis=vec()
	axis.x , axis.y=self.tires[3].body:getWorldVector(0, 1)
	local v=vec()
	v.x,v.y=self.tires[3].body:getLinearVelocity()
	return v*axis
end


local function clamp(a,low,high)
	if a>math.pi then a=a-2*math.pi end
	return math.max(low,math.min(a,high))
end


function car:addPuff()
	if self.visible==false then return end
	local x,y=self.body:getWorldPoints(0,-1)
	local num
	local time
	if self.isPowerUp then
		num=10
		time=1.5
	else
		num=1
		time=0.5
	end

	for i=1,num do
		if love.math.random()>0.7 then
			local puff=require("objs/puff"):new(x,y,time,self.alpha,self.isPowerUp)
		end
	end
end


function car:addWall()
	if self.lightWall==self.maxWall then --如果没在建则
		self.wall_ox,self.wall_oy=self.body:getWorldPoints(0,-5)
		self.lightWall=self.lightWall-1
	else
		self.wall_tx,self.wall_ty=self.body:getWorldPoints(0,-5)
		local len=math.getDistance(self.wall_ox,self.wall_oy ,self.wall_tx,self.wall_ty)
		self.lightWall=self.lightWall-1
		if  len>=3 then 
			require("objs/lightWall"):new(self,self.wall_ox,self.wall_oy,self.wall_tx,self.wall_ty)
			self.wall_ox,self.wall_oy=self.body:getWorldPoints(0,-5)
		end
	end
	if self.lightWall<0 then
		self.isWall=false
	end
end


function car:lapCheck()
    if self.posInRoad==game.road.count-1 then self.lapToggle=true end
    if self.oPos==game.road.count and self.posInRoad==1 and self.lapToggle==true then
        self.lap=self.lap+1
        self.lapToggle=false
        self.time=game.time
    end
end

function car:updateShift()
	
	if self.isAutoTrans then
		local rpm=math.floor(6000*math.getDistance(0,0,game.car.body:getLinearVelocity())/self.maxFSpeed)
		if rpm>4500 then
			self.shift=self.shift+1
			if self.shift>6 then self.shift=6 end
		elseif rpm<3000 then
			self.shift=self.shift-1
			if self.shift<1 then self.shift=1 end		
		end
	else
		if love.keyboard.isDown("up")  and self.keyToggle==false then
			self.shift=self.shift+1
			self.keyToggle=true
			if self.shift>6 then self.shift=6 end
		end

		if love.keyboard.isDown("down") and self.keyToggle==false then
			self.shift=self.shift-1
			self.keyToggle=true
			if self.shift<1 then self.shift=1 end
		end

		if (not love.keyboard.isDown("up")) and (not love.keyboard.isDown("down")) then
			self.keyToggle=false
		end

		if self.isAICtrl then
			for k,v in pairs(self.cmd) do
				if v=="reset" then
					self:reset()
					return
				end

				if v=="shiftUp" then
				 	self.shift=self.shift+1
					if self.shift>6 then self.shift=6 end
				end
				if v=="shiftDown" then 
					self.shift=self.shift-1
					if self.shift<1 then self.shift=1 end
				end

				if v=="powerUp" and self.n2o>0 then
					self.isPowerUp=true
					self.n2o=self.n2o-1
					if self.n2o<0 then self.n2o=0 end
				else
					self.isPowerUp=false
				end
			end
		end

	end
	self.maxFSpeed=200*self.shift*self.powerRate
	self.maxDriveForce=self.power/self.shift/self.powerRate
end

function car:reset()
	self:setPosition(game.road.blocks[self.posInRoad].body:getPosition())
	self.body:setAngle(game.road.blocks[self.posInRoad].body:getAngle())
	self.body:setLinearVelocity(0,0)
	self.body:setAngularVelocity(0)
	for k,v in pairs(self.tires) do
		v:reset()
	end
end

function car:key(key)
	if self~=game.car then return end
	if key=="t" then
        if self.isAICtrl then
            self.isAICtrl=false
        else
            self.isAICtrl=true
        end
    end

	if self.isAICtrl==true or self.visible==false then return end

	if key=="f" then
		if self.isAutoTrans==true then
			self.isAutoTrans=false
		else
			self.isAutoTrans=true
		end
	end


	if key=="r" then
        self:explode()
    end

    if key=="o" and self.diskRecharge>0 then ---以后加入物品判断
		self.disk:lanch()
		self.diskRecharge=self.diskRecharge-1
    end

    if key=="1" then
    	if not self.item[1].type then return end
    	self.itemFunc[1]=self.item[1].beginFunc
    	self.item[1]={}
    end
    if key=="2" then
    	if not self.item[2].type then return end
    	self.itemFunc[2]=self.item[2].beginFunc
    	self.item[2]={}
    end
end

function car:itemUpdate()
	for k,v in pairs(self.itemFunc) do
		v(self,k)
	end
end


function car:explode()
	explosion:new(self,5,500,1,true)
    for i=1,4 do
        explosion:new(self.tires[i],5,500,1,true)
    end
    game.cam:shake()
    self.enable=true
end



function car:update(dt)
	if game.ready~=0 or game.finish<0 or self.finished then return end
	self:ai()
	self:lapCheck()
	self:updateShift()
	self:itemUpdate()
	for i,v in ipairs(self.tires) do
		v:update(dt,self.isAICtrl)
	end
	
	self:addPuff(dt)
	if self.isWall==true then self:addWall() end

	local cRot=self.body:getAngle()
	local rRot=game.road.blocks[self.posInRoad].body:getAngle()
	local dist=math.abs(cRot-rRot)
	local dist2=math.pi*2-dist
	if dist>dist2 then dist=dist2 end

	if self.oPos>self.posInRoad and self.oPos~=game.road.count and dist>math.pi/2 then
		self.wrongWay=true
	elseif self.oPos<self.posInRoad then
		self.wrongWay=false
	end
	self.oPos=self.posInRoad
	if love.keyboard.isDown("p") and self.n2o>0 and not self.isAICtrl then
		self.isPowerUp=true
		self.n2o=self.n2o-1
		if self.n2o<0 then self.n2o=0 end
	else
		self.isPowerUp=false
	end 


end


local function getDist(p1,p2)
	local dist=math.abs(p1-p2)
	local dist2=#road.blocks-math.abs(p1-p2)
	if dist>dist2 then dist=dist2 end
	return dist
end


function car:draw()	
	if not self.visible then return end
	self.alpha=math.getAlpha(math.getLoopDist(game.car.posInRoad,self.posInRoad,game.road.count))
	for i,v in ipairs(self.tires) do
		v:draw(self.alpha)
	end
	
	if self.slowed then
		love.graphics.setColor(self.color[1], self.color[2], 255, self.alpha)
	elseif self.slipped then
		love.graphics.setColor(self.color[1], 255, self.color[3], self.alpha)
	else
		love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
	end
	
	love.graphics.polygon("outline",self.body:getWorldPoints(self.shape:getPoints()))
	self.disk:draw()
	


	if self.shieldActive then
		local x,y=self.body:getWorldPoints(0,20)
		love.graphics.setColor(0, 0, 255, self.alpha)
		love.graphics.circle("line", x, y, 30)
	end
end


function car:ai()
	if not self.isAICtrl then return end
	self.cmd={}
	local carSpeed=	self.tires[3]:getForwardVelocity():len()
	local testPos=self.posInRoad+math.ceil(carSpeed/200)+2
	self.testPos=testPos
	if testPos>game.road.count then testPos=testPos-game.road.count end
	if testPos<=0 then testPos=testPos+#road.blocks end
	local testX,testY=game.road.blocks[testPos].body:getPosition()
	local localX,localY=self.body:getLocalPoint(testX,testY)
	local localAngle=math.getRot(localX,localY,0,0)
	if localAngle>math.pi then localAngle=localAngle-2*math.pi end
	if localAngle<-math.pi/8 then table.insert(self.cmd,"left") end
	if localAngle>math.pi/8 then table.insert(self.cmd,"right") end
	if math.abs(localAngle)<math.pi/6 then table.insert(self.cmd,"forward")  end
	if math.abs(localAngle)>math.pi/3 then table.insert(self.cmd,"brake") end
	if self.oPos==self.posInRoad then self.stop=self.stop+1 else self.stop=1 end
	if self.stop>=100 then table.insert(self.cmd,"reset") end
	if carSpeed<=100 then table.insert(self.cmd,"forward") end
end
return car