local item=class("item")
local modes={"wall","shld","disk","slip","slow","rush","flag"}
local function getTarget(obj)
	if game.rule.name=="pursue" or game.rule.name=="dual" or game.rule.name=="flag" then
		if obj==game.car then
			return game.npc[1]
		else
			return game.car
		end
	else
		return math.getFirstCar()
	end
end

function item:getCanvas()
	self.canvas = love.graphics.newCanvas(78,78)
	self.canvas:renderTo(function()
		love.graphics.setLineWidth(3)
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("line", 0, 0, 72, 72)
		love.graphics.setColor(255, 0, 0)
		love.graphics.setFont(game.fontBig)
		love.graphics.print(self.item, 3, 20)
		love.graphics.setFont(game.font)
		love.graphics.setLineWidth(1)
	end)

	self.canvas2 = love.graphics.newCanvas(32,32)
	self.canvas2:renderTo(function()
		love.graphics.setLineWidth(3)
		love.graphics.setColor(0, 255, 0)
		love.graphics.rectangle("line", 1, 1, 30, 30)
		love.graphics.setColor(255, 0, 0)
		love.graphics.setFont(game.font)
		if self.item=="flag" then
			love.graphics.setColor(255, 255, 0)
			love.graphics.print(self.flag, 8, 5)
		else
			love.graphics.print("???", 5, 5)
		end
		love.graphics.setFont(game.font)
		love.graphics.setLineWidth(1)
	end)

end



function item:initialize(pos,loc,mode)
	table.insert(game.item,self)
	self.posInRoad=pos
	self.pos=pos --取posinroad
	self.loc=loc --[0,1]
	self:prepare()
	self.type="item"
	if not mode then
		self.item=modes[love.math.random(1,6)]
	else
		self.item=mode
	end
	if mode=="flag" then 
		game.flag=game.flag+1
		self.flag=game.flag
	end

	--30*30 的方块
	self.enable=true
	

	self:getCanvas()

	self:func()
end
function item:func()
	if self.item=="wall" then
		self.beginFunc=function(obj,slot)
			obj.isWall=true
    		obj.lightWall=obj.maxWall
    		obj.itemFunc[slot]=self.activeFunc
		end
		self.activeFunc=function(obj,slot)
			obj.itemFunc[slot]=self.endFunc
		end
		self.endFunc=function(obj,slot)
			table.remove(obj.itemFunc, slot)
		end
	end

	if self.item=="disk" then
		self.beginFunc=function(obj,slot)
			obj.diskRecharge=obj.diskRecharge_max
    		obj.itemFunc[slot]=self.activeFunc
		end
		self.activeFunc=function(obj,slot)
			obj.itemFunc[slot]=self.endFunc
		end
		self.endFunc=function(obj,slot)
			table.remove(obj.itemFunc, slot)
		end
	end

	if self.item=="slip" then
		self.beginFunc=function(obj,slot)	
			obj.target[slot]=getTarget(obj)
    		obj.target[slot].slipped=true
    		obj.antiCount[slot]=4
    		obj.temp[slot]=obj.target[slot].maxLImp
    		obj.target[slot].maxLImp=obj.target[slot].maxLImp/4
    		obj.itemFunc[slot]=self.activeFunc
		end
		self.activeFunc=function(obj,slot)
			obj.antiCount[slot]=obj.antiCount[slot]-1/60
			if obj.antiCount[slot]<0 then    
				obj.itemFunc[slot]=self.endFunc
			end
		end
		self.endFunc=function(obj,slot)
			obj.target[slot].slipped=false
			obj.target[slot].maxLImp=obj.temp[slot]
			table.remove(obj.itemFunc, slot)
		end
	end

	if self.item=="slow" then
		self.beginFunc=function(obj,slot)
			obj.killSpeed=obj.killSpeed*3
			obj.target[slot]=getTarget(obj)
			obj.target[slot].slowed=true
    		obj.antiCount[slot]=4
    		obj.temp[slot]=obj.target[slot].power
    		obj.target[slot].power=obj.target[slot].power/4
    		obj.itemFunc[slot]=self.activeFunc
		end
		self.activeFunc=function(obj,slot)
			obj.antiCount[slot]=obj.antiCount[slot]-1/60
			if obj.antiCount[slot]<0 then    
				obj.itemFunc[slot]=self.endFunc
			end
		end
		self.endFunc=function(obj,slot)
			obj.killSpeed=obj.killSpeed/3
			obj.target[slot].slowed=false
			obj.target[slot].power=obj.temp[slot]
			table.remove(obj.itemFunc, slot)
		end
	end	

	if self.item=="rush" then
		self.beginFunc=function(obj,slot)
    		obj.antiCount[slot]=2
    		obj.itemFunc[slot]=self.activeFunc
		end
		self.activeFunc=function(obj,slot)
			obj.antiCount[slot]=obj.antiCount[slot]-1/60
			obj.n2o=obj.n2o+1
			if obj.n2o>100 then obj.n2o=100 end
			if obj.antiCount[slot]<0 then    
				obj.itemFunc[slot]=self.endFunc
			end
		end
		self.endFunc=function(obj,slot)
			table.remove(obj.itemFunc, slot)
		end
	end	

	if self.item=="shld" then
		self.beginFunc=function(obj,slot)
    		obj.antiCount[slot]=2
    		obj.itemFunc[slot]=self.activeFunc
		end
		self.activeFunc=function(obj,slot)
			obj.antiCount[slot]=obj.antiCount[slot]-1/60
			obj.shieldActive=true
			if obj.antiCount[slot]<0 then    
				obj.itemFunc[slot]=self.endFunc
			end
		end
		self.endFunc=function(obj,slot)
			obj.shieldActive=false
			table.remove(obj.itemFunc, slot)
		end
	end




end

function item:setActive()


end

function item:reset()


end

function item:prepare()
	local size=game.road.blocks[self.pos].size
	local rot=game.road.blocks[self.pos].body:getAngle()
	local x,y=game.road.blocks[self.pos].body:getWorldPoints( -size*150+2*size*150*self.loc,0)
	self.body = love.physics.newBody(game.world, x, y, "dynamic")
	self.body:setAngle(rot)
	self.shape = love.physics.newRectangleShape(30*size, 30*size)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setSensor(true)
	self.body:applyAngularImpulse( 5000 )
	self.fixture:setUserData(self)
end


function item:update()

end

function item:get(car)
	car.score=car.score+1
	table.removeItem(game.item,self)
	if self.item=="flag" then self.item = modes[love.math.random(1,6)] end
	self:getCanvas()
	if not car.item[1].type then 
		car.item[1]={type=self.item,
					canvas=self.canvas,
					beginFunc=self.beginFunc,
					activeFunc=self.activeFunc,
					endFunc=self.endFunc}
		return 
	end
	if not car.item[2].type then 
		car.item[2]={type=self.item,
					canvas=self.canvas,
					beginFunc=self.beginFunc,
					activeFunc=self.activeFunc,
					endFunc=self.endFunc}
		return 
	end
end


function item:draw()
	if not self.enable then return end
	self.alpha=math.getAlpha(math.getLoopDist(game.car.posInRoad,self.pos,game.road.count))
	if self.flag then 
		if self.flag~=game.flagLast then
			love.graphics.setColor(100, 100, 100,self.alpha)
		else
			love.graphics.setColor(255, 255, 255,self.alpha)
		end
	else
		love.graphics.setColor(255, 255, 255,self.alpha)
	end
	local x,y=self.body:getPosition()
	local r = self.body:getAngle()

	love.graphics.draw(self.canvas2, x, y, r, 1 ,1, 16, 16)

end

return item