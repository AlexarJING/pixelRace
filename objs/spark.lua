local spark=class("spark")

function spark:initialize(car,coll,normal,tangent)
	table.insert(game.spark, self)
	self.alpha=car.alpha
	self.x,self.y=coll:getPositions( )
	self.speedX=-5+love.math.random()*10
	self.speedY=-5+love.math.random()*10
	self.life=0.1
end



function spark:draw()
	self.life=self.life-1/60
	if self.life<0 then self.destroy=true end	
	local ox,oy=self.x,self.y
	self.x=self.x+self.speedX
	self.y=self.y+self.speedY
	love.graphics.setColor(255, 255, 0, self.alpha)
	love.graphics.line(self.x,self.y, ox,oy )
end

return spark
