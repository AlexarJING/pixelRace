local scene = gamestate.new()

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
	local x,y=getPos()
	o:SetWidth(150)
	o:SetPos(x, y)
	o:SetText(name)
	o.tween=tween.new(1, o, {x=630,y=y}, 'outCubic')
	o.OnClick = function()
		gamestate.switch(gstate,nil,true)
	end
	o.tween:set(-0.2*(#ui-1))
	table.insert(ui, o)
end


function scene:init()

end 

function scene:enter(from,to,screen)
    self.screen=screen
    local o
	o=loveframes.Create("panel")
	o:SetSize(50, 500)
	o:SetPos(700, -500)
	o.tween=tween.new(1, o, {x=700,y=50}, 'outBounce')
	table.insert(ui, o)	
	
	newButton("return",state.game)
	newButton("retire",state.career)
	newButton("config",state.config)
	newButton("help",state.help)
	newButton("quit",state.quit)
end


function scene:draw()
	love.graphics.setColor(255, 255, 255, 50)
	love.graphics.draw(self.screen)
end

function scene:update(dt)
   	for k,v in pairs(ui) do
		v.tween:update(dt)
	end
end 

function scene:leave()
	for k,v in pairs(ui) do
		v:Remove()
	end
	ui={}
end
return scene