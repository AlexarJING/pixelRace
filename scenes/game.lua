local scene = gamestate.new()
local ui={}
local function uiSetVisible(toggle)
	ui.panel:SetVisible(toggle)
	for k,v in pairs(ui.buttons) do
		v:SetVisible(toggle)
	end
end
function scene:init()
    
end 

function scene:enter(from,realfrom,gameType,isContinue,isRapid)
	if not isContinue then
	    reset()
	    game.isRapid=isRapid
	    game.rule=rule[gameType]
	    game.rule.load()
	end
end


function scene:draw()
    game.rule.draw()
end

function scene:update(dt)
    game.rule.update(dt)
end 

function scene:keypressed(key)
	game.car:key(key)
    if key=="escape" then
        gamestate.switch(state.inter,state.menu,1,"bg")
    end
end

function scene:leave()
	self.bg = love.graphics.newImage(love.graphics.newScreenshot())
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
