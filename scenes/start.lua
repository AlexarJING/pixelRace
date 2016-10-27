local scene = gamestate.new()
local font = love.graphics.newFont("lcd.ttf", 90)
local title={x=-500}
title.tween=tween.new(1, title, {x=150}, 'outCubic')
title.tween:set(-1)
local scenes={"career","data","garage","rapid","config","help","credits","quit"}
local ui={}
local function uiSetVisible(toggle)
	for k,v in pairs(ui) do
		v:SetVisible(toggle)
	end
end

local function getPos()
	local last=ui[#ui]
	local lx,ly
	if #ui==1 then
		return -150,100
	else
		lx,ly=last:GetPos()
		return lx,ly+70
	end
end


local function newButton(name,gstate)
	local o=loveframes.Create("button")
	local x=-150
    local y=20+(460/#scenes)*(#ui)
	o:SetWidth(150)
	o:SetPos(x, y)
	o:SetText(name)
	o.tween=tween.new(1, o, {x=630,y=y}, 'outCubic')
	o.OnClick = function()
		gamestate.switch(state.inter,gstate)
	end
	o.tween:set(-0.2*(#ui-1))
	table.insert(ui, o)
end


function scene:init()
	--ui.bg = love.graphics.newImage("bg.jpg")
end 

function scene:enter()
	local o
	o=loveframes.Create("panel")
	o:SetSize(50, 500)
	o:SetPos(700, -500)
	o.tween=tween.new(1, o, {x=700,y=50}, 'outBounce')
	table.insert(ui, o)		
	for i,v in ipairs(scenes) do
		newButton(v,state[v])
	end
end

function scene:leave()
	self.bg=love.graphics.newImage(love.graphics.newScreenshot())
	for k,v in pairs(ui) do
		v:Remove()
	end
	ui={}
end


function scene:draw()
	love.graphics.setFont(font)
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print("neon racer", title.x, 220)
end

function scene:update(dt)
	for k,v in pairs(ui) do
		v.tween:update(dt)
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
