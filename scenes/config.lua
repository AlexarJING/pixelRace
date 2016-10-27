local scene = gamestate.new()
local font = love.graphics.newFont("lcd.ttf", 32)
local title={x=-500}
title.tween=tween.new(1, title, {x=600}, 'outCubic')

function scene:init()
	
end 

function scene:enter(from,realfrom)
	self.from=realfrom
end

function scene:leave()
	
end

function scene:keypressed(key)
    if key=="escape" then
        gamestate.switch(state.inter,self.from)
    end
end

function scene:draw()
	love.graphics.setFont(font)
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print("config", title.x, 10)
	love.graphics.print("programming in progress", 100,100)
end

function scene:update(dt)
	title.tween:update(dt)
end 

return scene




--[[
		init             = __NULL__,
		enter            = __NULL__,
		leave            = __NULL__,
		update           = __NULL__,
		draw             = __NULL__,
		focus            = __NULL__,
		keyreleased      = __NULL__,
		keypressed       = __NULL__,
		mousepressed     = __NULL__,
		mousereleased    = __NULL__,
		joystickpressed  = __NULL__,
		joystickreleased = __NULL__,
		quit             = __NULL__,]]
