
local function infoDraw()
	love.graphics.setFont(game.font)
    --------------info------------
    love.graphics.setColor(0, 255, 0, 255)
    local text=[[
press a,d to steer
press w,s to hit the gas
press space to drift
press t to switch auto pilot and manual control
press r to Reset
press f to swith the auto or manual transmission
press p to trigger the Nitrous Oxide
press o to lanch the disk
press 1,2 to use item
    ]]
    love.graphics.print(text, 10, 10)
    local speed=math.floor(game.car:getForwardSpeed()/3)
    love.graphics.print("speed: "..math.abs(speed), 10, 300)
    love.graphics.print("lap:"..game.car.lap, 10, 320)
    local txt
    if speed<0 then txt="R" else txt=game.car.shift end
    love.graphics.print("shift:"..txt, 10, 340)
    local rpm=math.floor(18000*speed/game.car.maxFSpeed)
    if game.oRPM-rpm>0 then 
        game.oRPM=game.oRPM-50+10*love.math.random()
    else
        game.oRPM=game.oRPM+50+10*love.math.random()
    end
    local target=math.floor(950+ 50*love.math.random())
    if game.oRPM<target  then game.oRPM=target end
    love.graphics.print("rpm:"..math.floor(game.oRPM), 10, 360)
    local t
    if game.car.isAICtrl then t="auto" else t="manual" end
    love.graphics.print("control: "..t, 10,380)
    if game.car.isAutoTrans then t="auto" else t="manual" end
    love.graphics.print("transmission: "..t, 10,400)
    if game.car.isAutoTrans then t="auto" else t="manual" end
    love.graphics.print("nitrous oxide: "..math.floor(game.car.n2o).."%", 10,420)
    love.graphics.print("disk recharge: "..game.car.diskRecharge.." times", 10,440)
    love.graphics.print("game timing: "..string.sub(tostring(game.time),1,5), 10,460)
    ------alert---------------

    if rpm>5500 then
        love.graphics.print("Over Heat!!!", 350, 340)
    end
    if game.car.wrongWay then
        love.graphics.print("wrong way!!!", 350, 300)
    end



    -------------hud------------------------------
    love.graphics.setColor(0,255,0)
    love.graphics.rectangle("line", 770, 200, 20, 250)

    for i=1,game.car.n2o do
        love.graphics.setColor(i*255/100, 0, 255)
        love.graphics.rectangle("fill", 771, 451-i*2.5, 18, 2)

    end

    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("line", 620, 580, 70)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", 620, 580, 69)
    love.graphics.setColor(255, 0, 0)
    local r=0.75*math.pi*game.oRPM/7000
    local px,py=math.axisRot(0,50,r-1.7*math.pi)
    love.graphics.line(620, 580,px+620,py+580)
    love.graphics.print(math.floor(game.oRPM), 585, 585)
    love.graphics.print("r/m", 620, 585)

    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("line", 750, 550, 100)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", 750, 550, 99)
    love.graphics.setColor(255, 0, 0)
    local r=0.75*math.pi*math.abs(speed)/425
    local px,py=math.axisRot(0,75,r-1.7*math.pi)
    love.graphics.line(750, 560,px+750,py+550)
    love.graphics.print(speed, 720, 570)
    love.graphics.print("km/h", 750, 570)

    --[[
    love.graphics.setColor(0,255,0)
    love.graphics.rectangle("line", 10, 490, 150, 100)
    love.graphics.line(30, 540, 140, 540)
    love.graphics.line(30, 510, 30, 570)
    love.graphics.line(140, 510, 140, 570)
    love.graphics.line(85, 510, 85, 570)
    local pos={{30,510},{30,570},{85,510},{85,570},{85,570}}
    love.graphics.setColor(255,0,0)
    love.graphics.circle("fill", pos[game.car.shift][1],pos[game.car.shift][2],5)]]

    love.graphics.setColor(0,255,0)
    love.graphics.rectangle("line",10, 500,80,80)    
    love.graphics.rectangle("line",100, 500,80,80)
    
    if game.car.item[1].type then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(game.car.item[1].canvas, 13, 503)
    else
        love.graphics.print("ITEM SLOT", 20,530)
    end
    love.graphics.setColor(0,255,0)
    if game.car.item[2].type then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(game.car.item[2].canvas, 103, 503)
    else
        love.graphics.print("ITEM SLOT", 110,530)
    end
end






local function miniDraw()

    local x,y=200,300
    love.graphics.setColor(255, 255, 255,100)
    for k,v in pairs(game.road.miniMap) do
        love.graphics.circle("fill", v[1]+x, v[2]+y, 2)
    end

    love.graphics.setColor(0, 0, 255, 255)
    for k,v in pairs(game.npc) do
        local px,py=v.body:getPosition()
        love.graphics.circle("fill", (px-99999)/50+x, (py-99999)/50+y, 3)
    end

    love.graphics.setColor(255, 0, 0, 255)
    local px,py=game.car.body:getPosition()
    love.graphics.circle("fill", (px-99999)/50+x, (py-99999)/50+y, 3)
end

local function resultDraw()
    love.graphics.setColor(0,0, 0,100)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    love.graphics.setColor(0, 255, 0)
    love.graphics.setFont(game.fontBig)
    love.graphics.printf("results "..math.ceil(game.finish), 0, 50, 800, "center")
    love.graphics.printf("No.".."|~~~~|".."name".."|~~|".."lap".."|~~~|".."lap time".."|~~|score", 80, 100, 800, "left")
    for i,v in ipairs(game.results) do
        love.graphics.print(i..".", 100, 100+i*50)
        love.graphics.print(game.allCars[v].name, 200, 100+i*50)
        love.graphics.print(game.allCars[v].lap, 400, 100+i*50)
        love.graphics.print(math.round(game.allCars[v].time,2), 550, 100+i*50)
        love.graphics.print(math.round(game.allCars[v].score,2), 700, 100+i*50)
    end 
end


return function()
 
    if game.ready~=0 then
        game.cam:draw()
        infoDraw()
        miniDraw()
        love.graphics.setColor(0,0, 0,100)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        love.graphics.setFont(game.fontHuge)
        local txt=math.ceil(game.ready)
        love.graphics.setColor(0, 255, 0,255)
        love.graphics.print(txt, 350,250)
    elseif game.finish~=0 or love.keyboard.isDown("tab") then
        game.cam:draw()
        infoDraw()
        miniDraw()
        resultDraw() 
    else
        game.cam:draw()
        infoDraw()
        miniDraw()
    end
end
