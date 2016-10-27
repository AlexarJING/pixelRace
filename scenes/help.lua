local scene = gamestate.new()
local font = love.graphics.newFont("lcd.ttf", 32)
local title={x=-500}
title.tween=tween.new(1, title, {x=600}, 'outCubic')
local text=[[
	go forward
	go backward/brake
	return left 
	return right     
	drift                
	nitro injection      
	lanch disk         
	use item 1   
	use item 2  
	auto pilot/manual drive  
	auto/manual transmission

]]
local text2=[[
  w
  s
  a
  d
 space
  p
  o
  1
  2
  r
  f
]]

function scene:init()
	
end 

function scene:enter(from)
	print(from,state.start)
	self.from=from
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
	love.graphics.print("game help", title.x, 10)
	love.graphics.print(text, 100, 100)
	love.graphics.print(text2, 500, 100)
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
