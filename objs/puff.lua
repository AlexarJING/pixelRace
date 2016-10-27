local puff=class("puff")

function puff:initialize(x,y,lifetime,alpha,isPowerUp)
	table.insert(game.puff, self)
	lifetime=lifetime or 1
	self.x = love.math.random(x-5,x+5)
	self.y = love.math.random(y-5,y+5)
	self.speedX= love.math.random(-0.2,0.2)
	self.speedY= love.math.random(-0.2,0.2)
	self.lifetime  = love.math.random()*0.1*lifetime
	self.r = love.math.random(1,5)
	self.isPowerUp=isPowerUp
	self.alpha=alpha
end


function puff:update()
	self.lifetime=self.lifetime-1/60
	if self.lifetime<=0 then self.destroy=true end
	self.x=self.x+self.speedX
	self.y=self.y+self.speedY
	--self.r=self.r/1.1
end

function puff:draw()
	if self.isPowerUp then
		love.graphics.setColor(200, 200, 0, self.alpha)
	else
		love.graphics.setColor(100, 100, 100, self.alpha)
	end
	love.graphics.circle("line", self.x, self.y, self.r)
end

return puff