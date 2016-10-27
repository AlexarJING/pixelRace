local scene = gamestate.new()
local font = love.graphics.newFont("lcd.ttf", 32)
local title={x=-500}
title.tween=tween.new(1, title, {x=600}, 'outCubic')
local gameName={"std item","std speed","rnd item","rnd speed","pursue","drift","accelerate","disk dual","flag capture"}
local ruleName={"std_item","std_speed","rnd_item","rnd_speed","pursue","drift","accelerate","dual","flag"}
local log={}
local logPosY=50
local logPosX=50
local time=0
local index=0
local gameType="std_item"
local gameRing=9
local rnd
function scene:init()
	
end 

local function newLog(text)
	table.insert(log, {y=logPosY,txt=text})
	logPosY=logPosY+50
end

function scene:enter()
	time=0
	index=1
	newLog("initialing rapid game...")
	rnd=love.math.random(0,9)
	gameRing = love.math.random(0,9)
	gameType = ruleName[rnd]
	newLog("your game ring is "..tostring(gameRing))
	newLog("your game type is "..gameName[rnd])
	newLog("set ready to lanch")

end

function scene:leave()
	
end

function scene:keypressed(key)
    if key=="escape" then
        gamestate.switch(state.inter,state.start)
    end
    if key==" " then 
    	index=index+1
    end
end

function scene:draw()
	love.graphics.setFont(font)
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print("Rapid game", title.x, 10)
	for i=1,index do
		love.graphics.print(log[i].txt, logPosX, log[i].y)
	end
end

function scene:update(dt)
	time=time+dt
	if time>3 then
		time=0
		index=index+1
		if index>=5 then
			gamestate.switch(state.inter,state.game,1,"tween",gameType)
		end
	end
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
