local road=class("road")
function road:getLastInfo()
	local l=self.last
	if not l then return 99999,99999,0,self.size,0  end
	local ox,oy=l.body:getPosition()
	local r=l.body:getAngle()
	local rx,ry,dx,dy,dr
	if l.model=="straight" then
		dx,dy= math.axisRot(0,50,r)
		dr=0
	elseif l.model=="corner_l" then
		rx,ry=math.axisRot(50+150*l.size,0,math.rad(15))
		dx,dy= math.axisRot(rx-50-150*l.size,ry,r)
		
		dr=math.rad(15)
	elseif  l.model=="corner_r" then
		rx,ry=math.axisRot(-50-150*l.size,0,-math.rad(15))
		dx,dy= math.axisRot(rx+50+150*l.size,ry,r)
		dr=math.rad(-15)
	end
	return dx+ox,dy+oy,r+dr,l.size,l.angle
end

function road:design(func)
	func()
	self:mini()
	self.count=#self.blocks
end


function road:generateRndMap(len,percentage)
	self:addTrack("s",love.math.random(10,20))
	for i=1,len do
		if love.math.random()>percentage/100 then
			self:addTrack("s",love.math.random(10,20))
		else
			self:addTrack("c",15*love.math.random(1,12)*math.sign(love.math.random()-0.5))
		end
	end
	self:loop()
end


function road:initialize()
	self.blocks={}
	self.posInRoad=0
	self.highLight=0
	self.type="road"
	self.size=1
end

function road:mini()
	local tab={}
	for i=1,#self.blocks,1 do
		local x,y=self.blocks[i].body:getPosition()
		table.insert(tab,{(x-99999)/50,(y-99999)/50})
	end
	road.miniMap=tab
end


function road:loop()
	local lastX,lastY,lastR=self:getLastInfo(self.blocks[#self.blocks])
	local firstX,firstY=99999,99999
	local n=math.round(math.deg(math.pi/2-lastR)*100/15,2)*15/100
	self:addTrack("c",n)
	local lastX,lastY,lastR=self:getLastInfo(self.blocks[#self.blocks])
	local lastX,lastY,lastR=self:getLastInfo(self.blocks[#self.blocks])
	self:addTrack("s",math.abs(lastX-firstX)/50+10)
	self:addTrack("c",90)
	local lastX,lastY,lastR=self:getLastInfo(self.blocks[#self.blocks])
	if lastY-firstY>0 then
		self:addTrack("s",(lastY-firstY)/50)
	end
	self:addTrack("s",math.abs(lastY-firstY)/50)
	self:addTrack("c",90)
	local lastX,lastY,lastR=self:getLastInfo(self.blocks[#self.blocks])
	self:addTrack("s",math.abs(lastX-firstX)/50-5)
	self:addTrack("c",90)
	if lastY-firstY<0 then
		self:addTrack("s",math.floor(math.abs(lastY-firstY)/50)-7)
	end
	self:newComplet()
end





function road:addTrack(type,deg)
	local deg=deg or 0
	local size=size or 1.5
	if type=="c" then
		if deg%15~=0 then error("must be a x15") end
		for i=1,math.abs(deg/15) do
			local t=deg>0
			self.last=self:newCorner(t)
		end
	end
	if type=="s" then
		for i=1,deg do
			self.last=self:newBlock()
		end
	end
end


function road:newBlock()

	local block={}
	block.model="straight"
	self.posInRoad=self.posInRoad+1
	block.posInRoad=self.posInRoad
	local x,y,r,s,a=self:getLastInfo()
	block.size=s
	block.angle=a
	
	block.body = love.physics.newBody(game.world, x, y, "static")
	block.shape = love.physics.newPolygonShape(-150*block.size,0,-150*block.size,50,150*block.size,50,150*block.size,0)
	block.fixture = love.physics.newFixture(block.body, block.shape)	
	block.body:setAngle(r)
	block.fixture:setSensor( true )
	block.fixture:setGroupIndex( -3000 )
	block.type="sensor"
	block.fixture:setUserData(block)

	block.left={}
	block.left.index=self.posInRoad
	block.left.body = love.physics.newBody(game.world, x, y, "static")
	block.left.shape = love.physics.newPolygonShape(-50-150*block.size,0,-50-150*block.size,50,-150*block.size,50,-150*block.size,0)
	block.left.fixture = love.physics.newFixture(block.left.body, block.left.shape)
	block.left.body:setAngle(r)
	block.left.fixture:setRestitution(0.4)
	--block.left.fixture:setFriction(1)
	block.left.fixture:setGroupIndex( -3000 )
	block.left.type="wall"
	block.left.posInRoad=block.posInRoad
	block.left.fixture:setUserData(block.left)

	block.right={}
	block.right.index=self.posInRoad
	block.right.body = love.physics.newBody(game.world, x, y, "static")
	block.right.shape = love.physics.newPolygonShape(50+150*block.size,0,50+150*block.size,50,150*block.size,50,150*block.size,0)
	block.right.fixture = love.physics.newFixture(block.right.body, block.right.shape)
	block.right.body:setAngle(r)
	block.right.fixture:setRestitution(0.4)
	--block.right.fixture:setFriction(1)
	block.right.fixture:setGroupIndex( -3000 )
	block.right.type="wall"
	block.right.posInRoad=block.posInRoad
	block.right.fixture:setUserData(block.right)
	
	table.insert(self.blocks,block)
	return block
end




function road:newCorner(isleft)
	local block={}
	local x,y,r,s,a

	x,y,r,s,a=self:getLastInfo()
	block.size=s
	block.angle=a


	self.posInRoad=self.posInRoad+1
	block.posInRoad=self.posInRoad

	

	local mx,my,lx,ly,lx2,ly2,rx,ry,rx2,ry2

--下面代码是生产旋转后的块上部坐标，mx,my为中心，l l2为左边墙，r r2为右边墙

	if isleft then 
		block.model="corner_l"	
		kx,ky = math.axisRot(50+150*block.size,0,math.rad(15))
		mx,my=kx-50-150*block.size,ky

		kx,ky = math.axisRot(50,0,math.rad(15))
		lx,ly=kx-50-150*block.size,ky

		lx2,ly2=-50-150*block.size,0
		
		kx,ky = math.axisRot(300*block.size+50,0,math.rad(15))
		rx,ry=kx-50-150*block.size,ky

		kx,ky = math.axisRot(300*block.size+100,0,math.rad(15))
		rx2,ry2=kx-50-150*block.size,ky
		block.angle=a
	else
		block.model="corner_r"
		kx,ky = math.axisRot(-50-150*block.size,0,math.rad(-15))
		mx,my=kx+50+150*block.size,ky

		kx,ky = math.axisRot(-50,0,math.rad(-15))
		rx,ry=kx+50+150*block.size,ky

		rx2,ry2=50+150*block.size,0
		
		kx,ky = math.axisRot(-300*block.size-50,0,math.rad(-15))
		lx,ly=kx+50+150*block.size,ky

		kx,ky = math.axisRot(-300*block.size-100,0,math.rad(-15))
		lx2,ly2=kx+50+150*block.size,ky
		block.angle=a
	end

	block.body = love.physics.newBody(game.world, x, y, "static")
	block.shape = love.physics.newPolygonShape(-150*block.size,0,lx,ly,rx,ry,150*block.size,0)
	block.fixture = love.physics.newFixture(block.body, block.shape)
	block.body:setAngle(r)
	block.fixture:setSensor( true )
	block.type="sensor"
	block.fixture:setUserData(block)

	block.left={}
	block.left.index=self.posInRoad
	block.left.body = love.physics.newBody(game.world, x, y, "static")
	block.left.shape = love.physics.newPolygonShape(-50-150*block.size,0,lx2,ly2,lx,ly,-150*block.size,0)
	block.left.fixture = love.physics.newFixture(block.left.body, block.left.shape)
	block.left.body:setAngle(r)
	block.left.fixture:setRestitution(0.4)
	--block.left.fixture:setFriction(1)
	block.left.fixture:setGroupIndex( -3000 )
	block.left.type="wall"
	block.left.posInRoad=block.posInRoad
	block.left.fixture:setUserData(block.left)

	block.right={}
	block.right.index=self.posInRoad
	block.right.body = love.physics.newBody(game.world, x, y, "static")
	block.right.shape = love.physics.newPolygonShape(50+150*block.size,0,rx2,ry2,rx,ry,150*block.size,0)
	block.right.fixture = love.physics.newFixture(block.right.body, block.right.shape)
	block.right.body:setAngle(r)
	block.right.fixture:setRestitution(0.4)
	--block.right.fixture:setFriction(1)
	block.right.fixture:setGroupIndex( -3000 )
	block.right.fixture:setUserData(block.right)
	block.right.type="wall"
	block.right.posInRoad=block.posInRoad
	table.insert(self.blocks,block)
	return block



end

function road:newTrans(size)
	local block={}

	block.model="straight"
	
	self.posInRoad=self.posInRoad+1
	block.posInRoad=self.posInRoad


	local x,y,r,s,a=self:getLastInfo()
	block.angle=a
	block.size=size

	block.body = love.physics.newBody(game.world, x, y, "static")
	block.shape = love.physics.newPolygonShape(-150*self.last.size,0,-150*block.size,50,150*block.size,50,150*self.last.size,0)
	block.fixture = love.physics.newFixture(block.body, block.shape)
	block.body:setAngle(r)
	block.fixture:setSensor( true )
	block.type="sensor"
	block.fixture:setUserData(block)

	block.left={}
	block.left.index=self.posInRoad
	block.left.body = love.physics.newBody(game.world, x, y, "static")
	block.left.shape = love.physics.newPolygonShape(-50-150*self.last.size,0,-50-150*block.size,50,-150*block.size,50,-150*self.last.size,0)
	block.left.fixture = love.physics.newFixture(block.left.body, block.left.shape)
	block.left.body:setAngle(r)
	block.left.fixture:setRestitution(0.4)
	--block.left.fixture:setFriction(1)
	block.left.fixture:setGroupIndex(-3000)
	block.left.type="wall"
	block.left.posInRoad=block.posInRoad
	block.left.fixture:setUserData(block.left)

	block.right={}
	block.right.index=self.posInRoad
	block.right.body = love.physics.newBody(game.world, x, y, "static")
	block.right.shape = love.physics.newPolygonShape(50+150*self.last.size,0,50+150*block.size,50,150*block.size,50,150*self.last.size,0)
	block.right.fixture = love.physics.newFixture(block.right.body, block.right.shape)
	block.right.body:setAngle(r)
	block.right.fixture:setRestitution(0.4)
	--block.right.fixture:setFriction(1)
	block.right.fixture:setGroupIndex(-3000 )
	block.right.type="wall"
	block.right.posInRoad=block.posInRoad
	block.right.fixture:setUserData(block.right)
	table.insert(self.blocks,block)
	return block
end


function road:newComplet()
	---新直线块 left right分别为左右两边护栏
	local block={}

	block.model="complet"
	self.posInRoad=self.posInRoad+1
	block.posInRoad=self.posInRoad
	local x,y,r,s,a

	x,y,r,s,a=self:getLastInfo()
	block.size=s
	block.angle=a


	local f=self.blocks[1]
	local tab={f.left.body:getWorldPoints(f.left.shape:getPoints())}
	local lx2,ly2,lx,ly=tab[1],tab[2],tab[7],tab[8]

	local tab={f.right.body:getWorldPoints(f.right.shape:getPoints())}
	local rx2,ry2,rx,ry=tab[1],tab[2],tab[7],tab[8]	

	block.body = love.physics.newBody(game.world, x, y, "static")
	lx2,ly2=block.body:getLocalPoint(lx2,ly2)
	lx,ly=block.body:getLocalPoint(lx,ly)
	rx2,ry2=block.body:getLocalPoint(rx2,ry2)
	rx,ry=block.body:getLocalPoint(rx,ry)

	block.shape = love.physics.newPolygonShape(-150*block.size,0,lx2,ly2,rx,ry,150*block.size,0)
	block.fixture = love.physics.newFixture(block.body, block.shape)	
	block.body:setAngle(r)
	block.fixture:setSensor( true )
	block.fixture:setGroupIndex( -3000 )
	block.type="sensor"
	block.fixture:setUserData(block)

	block.left={}
	block.left.index=self.posInRoad
	block.left.body = love.physics.newBody(game.world, x, y, "static")
	block.left.shape = love.physics.newPolygonShape(-50-150*block.size,0,lx2,ly2,lx,ly,-150*block.size,0)
	block.left.fixture = love.physics.newFixture(block.left.body, block.left.shape)
	block.left.body:setAngle(r)
	block.left.fixture:setRestitution(0.4)
	--block.left.fixture:setFriction(1)
	block.left.fixture:setGroupIndex( -3000 )
	block.left.type="wall"
	block.left.posInRoad=block.posInRoad
	block.left.fixture:setUserData(block.left)

	block.right={}
	block.right.index=self.posInRoad
	block.right.body = love.physics.newBody(game.world, x, y, "static")
	block.right.shape = love.physics.newPolygonShape(50+150*block.size,0,rx2,ry2,rx,ry,150*block.size,0)
	block.right.fixture = love.physics.newFixture(block.right.body, block.right.shape)
	block.right.body:setAngle(r)
	block.right.fixture:setRestitution(0.4)
	--block.right.fixture:setFriction(1)
	block.right.fixture:setGroupIndex( -3000 )
	block.right.type="wall"
	block.right.posInRoad=block.posInRoad
	block.right.fixture:setUserData(block.right)
	
	table.insert(self.blocks,block)
	return block
end

function road:draw()
	for i=1,100 do
		local p=game.car.posInRoad-50+i
		if p<=0 then p=p+self.count end
		if p>self.count then p=p-self.count end
		local alpha=math.getAlpha(math.getLoopDist(game.car.posInRoad,p,self.count))
		local block=self.blocks[p]
		if block then  
			love.graphics.setColor(255, 0, 0, alpha)
			love.graphics.polygon("line", block.left.body:getWorldPoints(block.left.shape:getPoints()))
			love.graphics.polygon("line", block.right.body:getWorldPoints(block.right.shape:getPoints()))
			love.graphics.setColor(50, 50, 50, alpha)
			love.graphics.polygon("fill", block.body:getWorldPoints(block.shape:getPoints()))
		end
	end
end

return road