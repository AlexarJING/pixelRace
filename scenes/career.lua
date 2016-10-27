local scene = gamestate.new()
local font = love.graphics.newFont("lcd.ttf", 32)
local title={x=-500}
title.tween=tween.new(1, title, {x=600}, 'outCubic')
local ui={}
local gameButton={}

local function getPos()
    local last=ui[#ui]
    local lx,ly
    if #ui==1 then
        return -150,100
    else
        lx,ly=last:GetPos()
        return lx,ly+40
    end
end

local function reRange()
    for k,v in pairs(gameButton) do
        v:Remove()
    end
    gameButton={}
    for i=2,11 do
        local obj=ui[i]
        if obj.y~=20+40*i or x~=30 then   
            obj.tween=tween.new(0.5, obj, {y=20+40*i}, 'outCubic')
            obj.tween:setCallback(function(obj) obj.tween=tween.new(0.5, obj, {x=30}, 'outCubic') end)
        end
    end
end

local gameName={"std item","std speed","rnd item","rnd speed","pursue","drift","accelerate","disk dual","flag capture"}
local ruleName={"std_item","std_speed","rnd_item","rnd_speed","pursue","drift","accelerate","dual","flag"}

local function newGameButton()
    for i=1,9 do
        local o=loveframes.Create("button")
        table.insert(gameButton, o)
        local index=#gameButton
        o:SetWidth(150)
        o:SetHeight(80)
        o:SetPos(400, 300)
        if table.getIndex(player.career.pass,i) then
            o:SetText("||| "..gameName[index].." |||")
        else
            o:SetText(gameName[index])
        end
        local y=math.floor((index-1)/3)+2
        local x=(index-1)%3+1
        o.tween=tween.new(0.5, o, {x=x*200,y=y*100}, 'outCubic')
        --o.tween:setCallback(function(obj)  end)
        o.tween:set(-1)
        o.OnClick = function(obj)
            --scene:enter(from,to,time,how,...)
            gamestate.switch(state.inter,state.game,1,"tween",ruleName[i])
        end
    end   
end




local function newButton(name,ring)
    local o=loveframes.Create("button")
    local x,y=getPos()
    o:SetWidth(150)
    o:SetPos(x, y)
    o:SetText(name)
    o.tween=tween.new(1, o, {x=30}, 'outCubic')
    if ring<player.career.ring then o:SetClickable(false) end
    o.OnClick = function(obj)
        reRange()
        obj.tween=tween.new(0.5, obj, {x=200}, 'outCubic')
        obj.tween:setCallback(
            function(obj) 
                obj.tween=tween.new(0.5, obj, {y=100}, 'outCubic');
            end
        )  
        newGameButton()
    end
    o.tween:set(-0.1*(#ui-1))
    table.insert(ui, o)
end





function scene:init()

end 

function scene:enter()
    local o
    o=loveframes.Create("panel")
    o:SetSize(50, 500)
    o:SetPos(50, -500)
    o.tween=tween.new(1, o, {x=50,y=50}, 'outBounce')
    table.insert(ui,o) 
    --编号从2到10
    newButton("ring 9",9)
    newButton("ring 8",8)
    newButton("ring 7",7)
    newButton("ring 6",6)
    newButton("ring 5",5)
    newButton("ring 4",4)
    newButton("ring 3",3)
    newButton("ring 2",2)
    newButton("ring 1",1)
    newButton("ring 0",0)

end

function scene:leave()
    for k,v in pairs(ui) do
        v:Remove()
    end
    ui={}
    for k,v in pairs(gameButton) do
        v:Remove()
    end
    gameButton={}
end

function scene:keypressed(key)

    if key=="escape" then
        gamestate.switch(state.inter,state.start)
    end
end


function scene:draw()
    love.graphics.setFont(font)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print("career mode", title.x, 10)
    player:draw()
end

function scene:update(dt)
    for k,v in pairs(ui) do
        v.tween:update(dt)
    end
    for k,v in pairs(gameButton) do
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
