local scene = gamestate.new()
local font = love.graphics.newFont("lcd.ttf", 32)
local title={x=-500}
title.tween=tween.new(1, title, {x=600}, 'outCubic')

function scene:init()
	
end 

function scene:enter()
	
end

function scene:leave()
	
end

function scene:keypressed(key)
    if key=="escape" then
        gamestate.switch(state.inter,state.start)
    end
end

function scene:draw()
	love.graphics.setFont(font)
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print("Quit", title.x, 10)
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
