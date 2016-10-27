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
	love.graphics.print("credits", title.x, 10)
	love.graphics.printf("Design & program", 0, 50, 800, "center")
	love.graphics.printf("Alexar", 0, 100, 800, "center")
	love.graphics.printf("Thanks to", 0, 200, 800, "center")
	love.graphics.printf("Love2d Rude", 0, 250, 800, "center")
	love.graphics.printf("Lib loveframes Kenny Shields", 0, 300, 800, "center")
	love.graphics.printf("Lib bintable Eike Decker", 0, 350, 800, "center")
	love.graphics.printf("Lib gamera/middleClass/tween Enrique García Cota", 0, 400, 800, "center")
	love.graphics.printf("Lib gamestate/vector Matthias Richter", 0, 450, 800, "center")
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
