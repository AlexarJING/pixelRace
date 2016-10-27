local scene = gamestate.new()
local font = love.graphics.newFont("lcd.ttf", 32)
local title={x=-500}
title.tween=tween.new(1, title, {x=600}, 'outCubic')
local left={}
local right={}
local down={}
local partsList={"chassis","body","engine","transmission","tires","nitro","disk","painting"}
-- tiresPos -12,3;12,3,-12,34,12,34
--75,18.75  212.5
local cp=require "libs/colorPicker"
------------for parts-----------------
local ox,oy=500,-400
local px,py=500,400
local tx,ty=300,400
-------------for pannel--------------
local leftTopX=50
local leftTopY=50
local rightTopX=700
local rightTopY=50
local leftButtonX=30
local rightButtonX=630
local leftSelectPosX=200
local leftSelectPosY=100
local rightSelectPosX=450
local rightSelectPosY=100

local right={}
local parts={
    {
        name="body",
        shape={-37.5,0,-75,-62.5,-70,-137.5,-25,-250,25,-250,70,-137.5,75,-62.5,37.5,0},
        color={},
        pos={x=ox,y=oy}
    },
    {
        name="tire1",
        shape={62.5, 12.5, 87.5, 12.5, 87.5, -50, 62.5, -50},
        color={},
       pos={x=ox,y=oy}
    },
    {
        name="tire2",
        shape={-87.5, 12.5, -62.5, 12.5, -62.5, -50, -87.5, -50},
        color={},
        pos={x=ox,y=oy}
    },
    {
        name="tire3",
        shape={-87.5, -181.25, -62.5, -181.25, -62.5, -243.75, -87.5, -243.75},
        color={},
        pos={x=ox,y=oy}
    },
    {
        name="tire4",
        shape={62.5, -181.25, 87.5, -181.25, 87.5, -243.75, 62.5, -243.75},
        color={},
       pos={x=ox,y=oy}
    },
    {
        name="chassis",
        shape={
        -70,-13.75,
        -70,-23.75,
        -20,-23.75,
        -20,-207.5,
        -70,-207.5,
        -70,-217.5,
        70,-217.5,
        70,-207.5,
        20,-207.5,
        20,-23.75,
        70,-23.75,
        70,-13.75},
        color={},
        pos={x=ox,y=oy}
    },
    {
        name="engine",
        shape={-30,-30,30,-30,30,-150,-30,-150},
        color={},
        pos={x=ox,y=oy}
    },
    {
        name="transmission",
        shape={-30,-160,30,-160,30,-200,-30,-200},
        color={},
        pos={x=ox,y=oy}
    },
    {
        name="nitro1",
        shape={-40,-40,-55,-40,-55,-150,-40,-150},
        color={},
        pos={x=ox,y=oy}
    },
    {
        name="nitro2",
        shape={40,-40,55,-40,55,-150,40,-150},
        color={},
        pos={x=ox,y=oy}
    },
    {
        name="disk",
        shape={0,-40,30},
        color={},
        pos={x=ox,y=oy}
    },    
    {
        name="painting",
        shape={-37.5,0,-75,-62.5,-70,-137.5,-25,-250,25,-250,70,-137.5,75,-62.5,37.5,0},
        color={},
        pos={x=ox,y=oy}
    },
}


local shopData={
    chassis={
        {
            name="basic",
            level=1,
            price=100,
            description="12312313"
        },
        {
            name="normal",
            level=2,
            price=800
        }
    },
    tire={
        {
            name="basic",
            level=1,
            price=100
        },
        {
            name="normal",
            level=2,
            price=800
        }
    },
    body={
        {
            name="basic",
            level=1,
            price=100
        },
        {
            name="normal",
            level=2,
            price=800
        }
    },
    engine={
        {
            name="basic",
            level=1,
            price=100
        },
        {
            name="normal",
            level=2,
            price=800
        }
    },
    transmission={
        {
            name="basic",
            level=1,
            price=100
        },
        {
            name="normal",
            level=2,
            price=800
        }
    },
    nitro={
        {
            name="basic",
            level=1,
            price=100
        },
        {
            name="normal",
            level=2,
            price=800
        }
    },
    disk={
        {
            name="basic",
            level=1,
            price=100
        },
        {
            name="normal",
            level=2,
            price=800
        }
    },
    painting={
        {
            name="basic",
            level=1,
            price=100
        },
        {
            name="normal",
            level=2,
            price=800
        }
    },
}



local t=0
for k,v in pairs(parts) do
    t=t+1
    v.tween=tween.new(0.5, v.pos, {x=px,y=py}, 'outCubic')
    v.tween:setCallback(function() v.tween=tween.new(0.5, v.pos, {x=tx,y=ty}, 'outCubic') end)
    v.tween:set(t*-0.1)
end


local function leftRerange()
    for k,v in pairs(down) do
        v:Remove()
    end
    down={}
    for k,v in pairs(parts) do
        v.tween=tween.new(0.5, v.pos, {x=tx,y=ty}, 'outCubic');
    end

    for i=2,#left do
        local obj=left[i]
        local dy=20+(460/#partsList)*(i-1)
        if obj.y~=dy or x~=30 then   
            obj.tween=tween.new(0.5, obj, {y=dy}, 'outCubic')
            obj.tween:setCallback(function(obj) obj.tween=tween.new(0.5, obj, {x=30}, 'outCubic') end)
        end
    end
end

local function rightRerange()
    for k,v in pairs(down) do
        v:Remove()
    end
    down={}

    for i=2,#right do
        local obj=right[i]
        local dy=20+(460/#right)*(i-1)
        if obj.y~=dy or x~=630 then   
            obj.tween=tween.new(0.5, obj, {y=dy}, 'outCubic')
            obj.tween:setCallback(function(obj) obj.tween=tween.new(0.5, obj, {x=630}, 'outCubic') end)
        end
    end
end

local function newDown(itemType,itemIndex)
    local item=shopData[itemType][itemIndex-1]
    for k,v in pairs(down) do
        v:Remove()
    end
    down={}
    local o
    o=loveframes.Create("panel")
    o:SetSize(400, 100)
    o:SetPos(200, 1000)
    o.tween=tween.new(1, o, {x=200,y=480}, 'outCubic')
    table.insert(down,o) 
    o=loveframes.Create("text")
    local txt=
[[code name:test 
power: 1000 
heat:500
price:1000]]
    o:SetText(item.description or txt)
    o:SetFont(love.graphics.newFont("lcd.ttf", 20))
    o:SetDefaultColor(0,255,0)
    o:SetSize(300, 90)
    o:SetPos(205, 1000)
    o.tween=tween.new(1, o, {x=205,y=480}, 'outCubic')
    table.insert(down,o) 

    if table.getIndex(player.shop[itemType],itemIndex-1) then
        o=loveframes.Create("button")
        o:SetText("install")
        o:SetSize(80, 80)
        o:SetPos(510, 1000)
        o.tween=tween.new(1, o, {x=510,y=490}, 'outCubic')
        if player.part.chassis< itemIndex then
            o:SetClickable(false)
        end
        o.OnClick = function() 
            for k,v in pairs(right) do
                v:Remove()
            end
            right={}
            for k,v in pairs(down) do
                v:Remove()
            end
            down={}
            for k,v in pairs(parts) do
                if string.find(v.name,itemType) then
                    v.tween=tween.new(0.5, v.pos, {x=tx,y=ty}, 'outCubic');
                end
            end
            leftRerange()
            tab.part[v]=itemIndex-1
            player:save()
        end
        table.insert(down,o)
    else
        o=loveframes.Create("button")
        o:SetText("purchase")
        o:SetSize(80, 80)
        o:SetPos(510, 1000)
        o.tween=tween.new(1, o, {x=510,y=490}, 'outCubic')
        if player.money< item.price then
            o:SetClickable(false)
        end
        o.OnClick = function() 
            player.money=player.money-item.price    
            table.insert(player.shop[itemType],itemIndex-1)
            player:save()
            newDown(itemType,itemIndex)
        end
        table.insert(down,o)
    end
end

local function newRightButton(partsType,v)
    local o=loveframes.Create("button")
    local x=-150
    local y=20+(460/(#shopData[partsType]+1))*#right
    o:SetWidth(150)
    o:SetPos(x, y)
    o:SetText(v.name)
    o.name=v.name
    o.index=#right+1
    o.tween=tween.new(1, o, {x=rightButtonX}, 'outCubic')
    o.OnClick = function(obj)
        rightRerange()
        newDown(partsType,obj.index)
        obj.tween=tween.new(0.5, obj, {x=rightSelectPosX}, 'outCubic')
        obj.tween:setCallback(function(obj) 
            obj.tween=tween.new(0.5, obj, {y=rightSelectPosY}, 'outCubic');
        end)  
        for k,v in pairs(parts) do
            if string.find(v.name,partsType) then
                v.tween=tween.new(0.5, v.pos, {x=ox,y=oy}, 'outCubic');
                v.tween:setCallback(function() 
                    v.tween=tween.new(0.5, v.pos, {x=px,y=py}, 'outCubic');
                end)  
            end
        end
             
    end
    o.tween:set(-0.1*(#right-1))
    table.insert(right, o)
    if player.part[partsType]==#right-1 then
        newDown(partsType,#right)
        o.tween:setCallback(function() 
            o.tween=tween.new(0.5, o, {x=rightSelectPosX,y=rightSelectPosY}, 'outCubic');
        end)  
    end
end

local function newPaintingDown()
     for k,v in pairs(down) do
        v:Remove()
    end
    down={}
    local o
    o=loveframes.Create("panel")
    o:SetSize(400, 100)
    o:SetPos(200, 1000)
    o.tween=tween.new(1, o, {x=200,y=480}, 'outCubic')
    table.insert(down,o)

    o=loveframes.Create("button")
    o:SetText("draw")
    o:SetSize(80, 80)
    o:SetPos(210, 1000)
    o:SetClickable(false)
    o.tween=tween.new(1, o, {x=210,y=490}, 'outCubic')
    o.OnClick = function() 
    end
    table.insert(down,o)

    o=loveframes.Create("button")
    o:SetText("clear")
    o:SetSize(80, 80)
    o:SetPos(360, 1000)
    o:SetClickable(false)
    o.tween=tween.new(1, o, {x=360,y=490}, 'outCubic')
    o.OnClick = function() 
    end
    table.insert(down,o)

    o=loveframes.Create("button")
    o:SetText("paint")
    o:SetSize(80, 80)
    o:SetPos(510, 1000)
    o.tween=tween.new(1, o, {x=510,y=490}, 'outCubic')
    o.OnClick = function() 
        table.copy(cp.sc,player.color)
        for k,v in pairs(down) do
            v:Remove()
        end
        down={}
        leftRerange()
        for k,v in pairs(parts) do
            if string.find(v.name,"painting") then
                v.tween=tween.new(0.5, v.pos, {x=tx,y=ty}, 'outCubic');
                v.tween:set(-1)
                v.tween:setCallback(function() parts[12].show=false end)
            end
        end
    end
    table.insert(down,o)
end


local function newPainting()
    cp:create(580,80,100)
    newPaintingDown()
end


local function newRight(name)
    for k,v in pairs(right) do
        v:Remove()
    end
    right={}
    if name=="painting" then newPainting();return end
    local o
    o=loveframes.Create("panel")
    o:SetSize(50, 500)
    o:SetPos(700, -500)
    o.tween=tween.new(1, o, {x=700,y=50}, 'outBounce')
    table.insert(right,o) 

    for k,v in pairs(shopData[name]) do
        newRightButton(name,v)
    end
end

local function newLeftButton(name,from,to)
    to=to or from
    local o=loveframes.Create("button")
    local x=-150
    local y=20+(460/#partsList)*(#left)
    o:SetWidth(150)
    o:SetPos(x, y)
    o:SetText(name)
    o.name=name
    o.tween=tween.new(1, o, {x=leftButtonX}, 'outCubic')
    o.OnClick = function(obj)
        leftRerange()
        obj.tween=tween.new(0.5, obj, {x=leftSelectPosX}, 'outCubic')
        obj.tween:setCallback(
            function(obj) 
                obj.tween=tween.new(0.5, obj, {y=leftSelectPosY}, 'outCubic');
            end
        )  
        for i=from,to do
            parts[i].tween=tween.new(0.5, parts[i].pos, {x=px,y=py}, 'outCubic'); 
            if name=="painting" then
                parts[i].tween:setCallback(function() parts[12].show=true end)
            end
        end        
        newRight(name)
    end
    o.tween:set(-0.1*(#left-1))
    table.insert(left, o)
end

local function newLeft()
    local o
    o=loveframes.Create("panel")
    o:SetSize(50, 500)
    o:SetPos(50, -500)
    o.tween=tween.new(1, o, {x=50,y=50}, 'outBounce')
    table.insert(left,o) 
    --{"chassis","body","engine","transmission","tires","nitro","disk","painting"}
    newLeftButton("chassis",6)
    newLeftButton("body",1)
    newLeftButton("engine",7)
    newLeftButton("transmission",8)
    newLeftButton("tire",2,5)
    newLeftButton("nitro",9,10)
    newLeftButton("disk",11)
    newLeftButton("painting",12)
end

    

function scene:init()

end 

function scene:enter()
    newLeft()
end

function scene:leave()
    for k,v in pairs(left) do
        v:Remove()
    end
    left={}
end


function scene:draw()
    love.graphics.setFont(font)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print("garage", title.x, 10)
   
    for k,v in pairs(parts) do
        love.graphics.setColor(0, 255, 0)
        if v.name=="disk" then
            love.graphics.circle("line", v.pos.x, v.pos.y, v.shape[3])
        elseif v.name=="painting" and v.show then
            local tab=math.polygonTrans(v.pos.x,v.pos.y+40,0,1,v.shape)
            love.graphics.setColor(unpack(player.color))
            love.graphics.polygon("outline", unpack(tab))
        else
            local tab=math.polygonTrans(v.pos.x,v.pos.y+40,0,1,v.shape)
            love.graphics.polygon("line", unpack(tab))
        end      
    end
    if parts[12].show then
        cp:update()
        cp:draw()
        love.graphics.setColor(cp.sc)
        love.graphics.polygon("outline", 600,300,780,300,780,460,600,460)
    end
    player:draw()
end

function scene:update(dt)
    for k,v in pairs(left) do
        v.tween:update(dt)
    end
    for k,v in pairs(right) do
        v.tween:update(dt)
    end
    for k,v in pairs(down) do
        v.tween:update(dt)
    end
    title.tween:update(dt)
    for k,v in pairs(parts) do
        v.tween:update(dt)
    end

end

function scene:keypressed(key)
    player:save()
    if key=="escape" then
        gamestate.switch(state.inter,state.start)
    end
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
