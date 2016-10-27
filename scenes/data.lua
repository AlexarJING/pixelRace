local scene = gamestate.new()
local font = love.graphics.newFont("lcd.ttf", 32)
local title={x=-500}
title.tween=tween.new(1, title, {x=600}, 'outCubic')
local ui={}
--[[
内容：玩家共玩多少局，赢、输，共行驶里程，
]]
local log={}
local logPosY=50
local logPosX=50
function scene:init()
	
end 

local function newLog(text)
	table.insert(log, {y=logPosY,txt=text})
	logPosY=logPosY+50
end

function scene:enter()
	local o=loveframes.Create("button")
	local x=500
    local y=500
	o:SetWidth(200)
	o:SetPos(x, y)
	o:SetText("reset player data")
	o.OnClick = function()
		player:reset()
	end
	table.insert(ui, o)
	newLog("player name: "..player.name)
	newLog("money :"..tostring(player.money).."$")
	newLog("tatal played: "..tostring(player.totalPlayed).." games")
	newLog("total winned: "..tostring(player.totalWin).." games")
	newLog("global win rate: "..tostring(player.winRate).."%")
	newLog("global rolled distance: "..tostring(player.totalDistance).." meters")
	newLog("global money spent: "..tostring(player.moneySpent).."$")
	newLog("best race ring: "..tostring(player.career.ring))
	newLog("games passed in this ring: "..tostring(#player.career.pass))

end

function scene:leave()
	for k,v in pairs(ui) do
		v:Remove()
	end
	ui=nil
end

function scene:keypressed(key)
    if key=="escape" then
        gamestate.switch(state.inter,state.start)
    end
end

function scene:draw()
	love.graphics.setFont(font)
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print("Player Data", title.x, 10)
	for i,v in ipairs(log) do
		love.graphics.print(v.txt, logPosX, v.y)
	end
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
