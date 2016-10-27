local scene = gamestate.new()

function scene:init()

end 

function scene:enter(from,to,time,how,...)
    self.screen = love.graphics.newImage( love.graphics.newScreenshot())
    self.state_to=to
    self.alpha=255
    self.time=time or 1
    self.how=how or "tween"
    self.arg=...
    self.state_from=from
end


function scene:draw()
	love.graphics.setColor(255, 255, 255, self.alpha)
    love.graphics.draw(self.screen)
end

function scene:update(dt)
    self.alpha=self.alpha-255*self.time/60
    if self.how=="tween" then       
        if self.alpha<0 then gamestate.switch(self.state_to,self.state_from,self.arg) end
    elseif self.how=="bg" then
        if self.alpha<50 then gamestate.switch(self.state_to,self,self.screen) end
    end
end 

function scene:leave()


end
return scene