local wall=class("lightWall")

function wall:initialize(obj,ox,oy,tx,ty)
	table.insert(game.lightWall,self)
	self.parent=obj
	self.type="lightWall"
	self.rot=math.getRot(ox,oy,tx,ty,true)
	local len=math.getDistance(ox,oy,tx,ty)
	self.body = love.physics.newBody(game.world, ox, oy, "static")
	local shape={-2,0,-2,len,2,len,2,0}
	self.shape = love.physics.newPolygonShape(unpack(shape))
	self.fixture = love.physics.newFixture(self.body, self.shape)
	--self.fixture:setGroupIndex( -1-obj.index )
	self.fixture:setUserData(self)
	self.body:setAngle(self.rot)
	self.color={50,255,255}
	self.posInRoad=obj.posInRoad
	self.visible=true
end

function wall:destroy()
	print("body",self.body)
	table.remove(game.lightWall, self:getIndex())
	self.body:destroy()
	--table.remove(game.lightWall, self:getIndex())
end

function wall:setActive(toggle)
	self.body:setActive(toggle)
end

function wall:reset()
end

function wall:getIndex()
	for k,v in pairs(game.lightWall) do
		if v==self then
			return k
		end
	end
end


function wall:draw()
	if self.visible==false then return end
	if self.disable then return end
	self.alpha=math.getAlpha(math.getLoopDist(game.car.posInRoad,self.posInRoad,game.road.count))
	love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.alpha)
	love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
	love.graphics.circle("fill", self.body:getX(),self.body:getY(),2)
end


return wall