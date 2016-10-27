local ex=class("explosion")

function ex:initialize(obj,size,power,life,back)
	table.insert(game.ex,self)
	self.x,self.y=obj.body:getPosition()
	self.angle=obj.body:getAngle()
	self.obj=obj
	self.size=size
	self.power=power
	self.life=life
	self.type="explosion"
	self.tPos={}
	self.posInRoad=obj.posInRoad
	self.isBack=back

	self:prepare()
	self:lanch()
end

function ex:prepare()

	self.obj:setActive(false)

	local points={}
	local tab={self.obj.shape:getPoints()}
	for i,v in ipairs(tab) do
		if i%2==0 then
			table.insert(points, vec(tab[i-1],tab[i]))
		end
	end

	local maxX,minX=-10000,10000
	local maxY,minY=-10000,10000

	for k,v in pairs(points) do
		if v.x>maxX then maxX=v.x end
		if v.y>maxY then maxY=v.y end
		if v.x<minX then minX=v.x end
		if v.y<minY then minY=v.y end
	end
	self.offX=minX
	self.offY=minY
	self.width=maxX-minX
	self.height=maxY-minY
	self.shape={}
	for i,v in ipairs(tab) do
		if i%2==0 then
			self.shape[i-1]=tab[i-1]-self.offX
			self.shape[i]=tab[i]-self.offY
		end
	end
	if self.obj.canvas then
		self.canvas=self.obj.canvas
	else
		self.canvas = love.graphics.newCanvas(self.width, self.height)
		self.width,self.height=self.canvas:getDimensions()
		self.canvas:renderTo(function()
			love.graphics.setColor(self.obj.color)
			love.graphics.polygon("outline",self.shape)
		end)
	end

	self.blocks={}
	for x=0,self.width-1,self.size do
		for y=0,self.height-1,self.size do
			local w=self.size
			local h=self.size
			if x+self.size>self.width and x~=self.width then w=self.width-x end
			if y+self.size>self.height and y~=self.height then h=self.height-y end

			local block={}	
			local px,py=self.obj.body:getWorldPoints(self.offX+x, self.offY+y)
			local r=self.obj.body:getAngle()
			block.body = love.physics.newBody(game.world, px, py, "dynamic")
			block.body:setAngle(r)
			block.shape = love.physics.newPolygonShape(0,0,0,h,w,h,w,0)
			block.fixture = love.physics.newFixture(block.body, block.shape,0.1)
			block.quad = love.graphics.newQuad(x, y, w, h, self.width, self.height)
			block.fixture:setUserData(self)
			--block.fixture:setGroupIndex( -1-self.obj.index )
			table.insert(self.blocks, block)
		end
	end

	
	self.obj:reset() 
	--self.obj:setActive(false)	
	

	for x=0,self.width-1,self.size do
		for y=0,self.height-1,self.size do
			local px,py=self.obj.body:getWorldPoints(self.offX+x, self.offY+y)
			local r=self.obj.body:getAngle()
			table.insert(self.tPos,{px,py,r})
		end
	end

	if not self.isBack then
		self.obj.body:destroy()
	end
end

function ex:lanch()
	for k,v in pairs(self.blocks) do
		v.body:setLinearVelocity(love.math.random(-self.power,self.power),love.math.random(-self.power,self.power))
	end
end

function ex:getIndex()
	for k,v in pairs(game.ex) do
		if v==self then 
			return k
		end
	end
end


function ex:update(dt)
	self.life=self.life-1/60
	if self.life<0 then
		if self.isBack==true then
			self:formBack(dt)
		else				
			for k,v in pairs(self.blocks) do
				v.body:destroy()
			end
			table.remove(game.ex, self:getIndex())
		end		
	end
end

function ex:formBack(dt)
	if not self.oPos then
		self.oPos={}
		for k,v in pairs(self.blocks) do
			self.oPos[k]={
				v.body:getX(),
				v.body:getY(),
				v.body:getAngle()
			}
			v.body:setLinearVelocity(0,0)
			v.body:setAngularVelocity(0)
			v.body:setActive(false)
			v.tween=tween.new(1, self.oPos[k], self.tPos[k], 'outQuad')
			v.tween:setCallback(function()  
				self.destroy=true
			end)
		end
	else
		for k,v in pairs(self.blocks) do
			v.tween:update(dt)
			v.body:setPosition(self.oPos[k][1],self.oPos[k][2])
			v.body:setAngle(self.oPos[k][3])
		end
		if self.destroy==true then
			for k,v in pairs(self.blocks) do
				v.body:destroy()
			end

			for k,v in pairs(game.ex) do
				if v==self then 
					table.remove(game.ex, k)
				end
			end
			self.obj.visible=true
			
			self.obj:setActive(true)
			self.obj:reset()
		end
	end
end

function ex:draw()
	love.graphics.setColor(255, 255, 255,self.obj.alpha)
		for k,v in pairs(self.blocks) do
			love.graphics.draw(self.canvas,v.quad, v.body:getX(), v.body:getY(), v.body:getAngle())
			--love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
			--love.graphics.polygon("line", v.body:getWorldPoints(v.shape:getPoints()))
		end
end

return ex