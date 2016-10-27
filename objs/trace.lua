local trace=class("trace")
local maxCount=500

function trace:initialize(tire)
	self.x,self.y=tire.body:getPosition()
	self.posInRoad=tire.parent.posInRoad
	table.insert(game.trace, 1, self)
	if #game.trace>maxCount then 
		table.remove(game.trace, maxCount+1)
	end
end



function trace:draw()
	self.alpha=math.getAlpha(math.getLoopDist(game.car.posInRoad,self.posInRoad,game.road.count))
	love.graphics.setColor(0, 0, 0, self.alpha)
	love.graphics.circle("fill", self.x, self.y, 2, 4)
end

return trace