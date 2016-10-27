local rules={}
-----格式----
--[[
名字，内部变量
load函数，update函数，结束条件函数
]]
---------------------------
local ruleName={"std_item","std_speed","rnd_item","rnd_speed","pursue","drift","accelerate","dual","flag"}
local function playerGet()
	if game.isRapid then return end
	if game.results[1]==game.car then
		local found=false
		for i,v in ipairs(player.career.pass) do
			if ruleName[v]==game.rule.name then
				found=false
			end
		end
		if found==false then
			player.money=player.money+30*(10-player.career.ring)
			table.insert(player.career.pass, table.getIndex(ruleName,game.rule.name))
			if #player.career.pass==9 then
				player.career.pass={}
				player.career.ring=player.career.ring-1
			end
		else
			player.money=player.money+30*(10-player.career.ring)
		end
	end
end

local function commonUpdate(dt)
	if game.ready>0 then
		game.ready=game.ready-dt
	elseif game.ready<0 then
		game.ready=0
	end
	game.car:update(dt)
    for k,v in pairs(game.npc) do
        v:update(dt)
    end
    game.world:update(dt)

    game.cam:update()
    
    for k,v in pairs(game.ex) do
        v:update(dt)
    end
    for k,v in pairs(game.puff) do
        v:update()
        if v.destroy==true then
            table.remove(game.puff, k)
        end
    end
    for k,v in pairs(game.todo) do
        v()
    end
    game.todo={}
    game.time=game.time+dt
    if game.finish<0 then 
        love.graphics.printf("press space button to continue", 0, 550, 800, "center") 
        if  love.keyboard.isDown(" ")  then  
        	playerGet()
        	player:save();
        	gamestate.switch(state.inter,state.career)  
        end
    end 
end

local function item_refresh(rate,mode)
	mode=mode or "normal"
	
	if game.flag==0 and mode=="flag" then
		for i=1,10 do
			require("objs/item"):new(love.math.random(1,game.road.count), love.math.random(2,8)/10,"flag")
		end
	end
	game.item_refresh=game.item_refresh-1/60
	if game.item_refresh<0 then
		if mode=="normal" then
			game.item={}
			for j=50,game.road.count,50 do
		        for i=1,4 do
		            require("objs/item"):new(j,0.2*i)
		        end
		   	end
		   	game.item_refresh=rate
		elseif mode=="dual" then
			game.item={}
			require("objs/item"):new(1,0.5)
			require("objs/item"):new(math.floor(game.road.count/2),0.5,"disk")
			game.item_refresh=rate
		end
	end

end

local function generateCars(num,pos)
	pos=pos or 0
	game.car=car:new(true)
    game.car:setPosition(game.road.blocks[1].body:getPosition())
    game.car.isAICtrl=false
    for i=1,num do
        game.npc[i]=car:new()
        game.npc[i]:setPosition(game.road.blocks[i+1+pos].body:getPosition())
        game.npc[i].body:setAngle(game.road.blocks[i+1+pos].body:getAngle())
        game.npc[i].posInRoad=i+1+pos
    end
    game.car.ai=require("ai")
    game.allCars={}
    table.insert(game.allCars, game.car)
    table.insert(game.results,1)
    for i=1,num do
        table.insert(game.allCars, game.npc[i])
        table.insert(game.results,i+1)
    end
end

local function sortfunction(a,b)
--如果a在前面则返回true 
	local carA=game.allCars[a]
	local carB=game.allCars[b]
	if carA.lap>carB.lap then
		return true
	elseif carA.lap<carB.lap then
		return false
	else
		if carA.posInRoad>carB.posInRoad then
			return true
		else
			return false
		end
	end
end


--------------------------------------------------------------
rules.std_item={}
rules.std_item.name="std_item"
rules.std_item.lap=2
rules.std_item.item_refresh=50
rules.std_item.results={}

rules.std_item.load=function()	
	game.road=require("objs/road"):new()
    game.road:generateRndMap(5,50)
    local function design()
	end
	game.road:design(design)
    generateCars(3)
end

rules.std_item.update=function(dt)
	commonUpdate(dt)
	item_refresh(rules.std_item.item_refresh)
	rules.std_item.cond()
end


rules.std_item.cond=function()
	table.sort( game.results, sortfunction )
	for i,v in ipairs(game.allCars) do
		if v.lap>rules.std_item.lap then
			v.finished=true
		end
		if game.over==false then
			game.over=true
			game.finish=10
		end
	end
		local allfinish=true
	for i,v in ipairs(game.allCars) do
		if not v.finished then
			allfinish=false
		end
	end

	if allfinish then game.finish=-1 end
	if game.finish>0 then game.finish=game.finish-1/60 end
end

rules.std_item.draw=require("render")

--------------------------------------
rules.std_speed={}
rules.std_speed.name="std_speed"
rules.std_speed.lap=4

rules.std_speed.load=function()	
	game.road=require("objs/road"):new()
    game.road:generateRndMap(5,60)
    local function design()
	end
	game.road:design(design)
	generateCars(3)
end

rules.std_speed.update=function(dt)
	commonUpdate(dt)
	rules.std_speed.cond()
end


rules.std_speed.cond=function()
	table.sort( game.results, sortfunction )
	for i,v in ipairs(game.allCars) do
		if v.lap>rules.std_item.lap then
			v.finished=true
		end
		if game.over==false then
			game.over=true
			game.finish=10
		end
	end
		local allfinish=true
	for i,v in ipairs(game.allCars) do
		if not v.finished then
			allfinish=false
		end
	end

	if allfinish then game.finish=-1 end
	if game.finish>0 then game.finish=game.finish-1/60 end
end

rules.std_speed.draw=require("render")
-----------------------------------------------------------

rules.rnd_item={}
rules.rnd_item.name="rnd_item"
rules.rnd_item.lap=3
rules.rnd_item.item_refresh=50

rules.rnd_item.load=function()	
	game.road=require("objs/road"):new()
    game.road:generateRndMap(5,50)
    local function design()
	end
	game.road:design(design)
    generateCars(3)
end

rules.rnd_item.update=function(dt)
	commonUpdate(dt)
	item_refresh(rules.rnd_item.item_refresh)
	rules.rnd_item.cond()
end


rules.rnd_item.cond=function()
	table.sort( game.results, sortfunction )
	for i,v in ipairs(game.allCars) do
		if v.lap>rules.std_item.lap then
			v.finished=true
		end
		if game.over==false then
			game.over=true
			game.finish=10
		end
	end
		local allfinish=true
	for i,v in ipairs(game.allCars) do
		if not v.finished then
			allfinish=false
		end
	end

	if allfinish then game.finish=-1 end
	if game.finish>0 then game.finish=game.finish-1/60 end
end

rules.rnd_item.draw=require("render")

--------------------------------------
rules.rnd_speed={}
rules.rnd_speed.name="rnd_speed"
rules.rnd_speed.lap=4

rules.rnd_speed.load=function()	
	game.road=require("objs/road"):new()
	game.road:generateRndMap(5,60)    
    local function design()
	end
	game.road:design(design)
	generateCars(3)
end

rules.rnd_speed.update=function(dt)
	commonUpdate(dt)
	rules.rnd_speed.cond()
end


rules.rnd_speed.cond=function()
	table.sort( game.results, sortfunction )
	for i,v in ipairs(game.allCars) do
		if v.lap>rules.std_item.lap then
			v.finished=true
		end
		if game.over==false then
			game.over=true
			game.finish=10
		end
	end
		local allfinish=true
	for i,v in ipairs(game.allCars) do
		if not v.finished then
			allfinish=false
		end
	end

	if allfinish then game.finish=-1 end
	if game.finish>0 then game.finish=game.finish-1/60 end
end

rules.rnd_speed.draw=require("render")


----------------pursue---------------------------
rules.pursue={}
rules.pursue.name="pursue"
rules.pursue.lap=3

rules.pursue.load=function()	
	game.road=require("objs/road"):new()
    game.road:generateRndMap(5,50)
    local function design()
	end
	game.road:design(design)
    generateCars(1,math.ceil(game.road.count/2))
end

rules.pursue.update=function(dt)
	commonUpdate(dt)
	item_refresh(rules.rnd_item.item_refresh)
	rules.pursue.cond()
end


rules.pursue.cond=function()
	local dist=math.getLoopDist(game.car.posInRoad,game.npc[1].posInRoad,game.road.count)
	if dist==0 then
		game.finish=-1
		game.over=true
		table.sort( game.results, function(a,b) 
			if game.allCars[a].lap>=game.allCars[b].lap then
				return true
			else
				return false
			end
		end )
	end
	
	if game.finish>0 then game.finish=game.finish-1/60 end
end

rules.pursue.draw=require("render")

-----------------------------drift------------------------
rules.drift={}
rules.drift.name="drift"
rules.drift.lap=3
rules.drift.time=20
rules.drift.player=3
rules.drift.result={}
for i=1,rules.drift.player+1 do
	rules.drift.result[i]=false
end
rules.drift.load=function()	
	game.road=require("objs/road"):new()
    game.road.size=3
  
	
    local function design()
		game.road:addTrack("c",360)
	end
	game.road:design(design)
	--game.road:generateRndMap(5,50)
    generateCars(rules.drift.player)

end

rules.drift.update=function(dt)
	commonUpdate(dt)
	item_refresh(rules.rnd_item.item_refresh)
	rules.drift.cond()
end


rules.drift.cond=function()
	table.sort( game.results, sortfunction )
	for i,v in ipairs(game.allCars) do
		if v.lap>rules.std_item.lap then
			if not v.finished then
				v.score=v.score-v.time*10
			end
			v.finished=true
		end
		if game.over==false then
			game.over=true
			game.finish=10
		end
	end
	local allfinish=true
	for i,v in ipairs(game.allCars) do
		if not v.finished then
			allfinish=false
		end
	end

	if allfinish then game.finish=-1 end
	if game.finish>0 then game.finish=game.finish-1/60 end
	if game.finish<0 then
		--按分数排列
		table.sort( game.results, function(a,b) 
			if game.allCars[a].score>=game.allCars[b].score then
				return true
			else
				return false
			end
		end )
	end
end

rules.drift.draw=require("render")


--------------------------------acc--------------------------------

rules.accelerate={}
rules.accelerate.name="accelerate"
rules.accelerate.player=1
rules.accelerate.result={}

rules.accelerate.load=function()	
	game.road=require("objs/road"):new()
    game.road.size=1	
    local function design()
		for i=1,10 do
			--if love.math.random(1,10)>8 then
				game.road:addTrack("s",50)
			--else
				game.road:addTrack("c",15*love.math.random(-1,1))
			--end
		end
		
	end
	game.road:design(design)
    generateCars(rules.accelerate.player)
    game.car.isAutoTrans=false
end

rules.accelerate.update=function(dt)
	commonUpdate(dt)
	rules.accelerate.cond()
end


rules.accelerate.cond=function()
	table.sort( game.results, sortfunction )
	for i,v in ipairs(game.allCars) do
		if v.posInRoad>=game.road.count then
			v.finished=true
			v.time=game.time
		end
		if game.over==false then
			game.over=true
			game.finish=10
		end
	end

	local allfinish=true
	for i,v in ipairs(game.allCars) do
		if not v.finished then
			allfinish=false
		end
	end

	if allfinish then game.finish=-1 end

	if game.finish>0 then game.finish=game.finish-1/60 end
	if game.finish<0 then
		--按分数排列
		table.sort( game.results, function(a,b) 
			if game.allCars[a].time<game.allCars[b].time then
				return true
			else
				return false
			end
		end )
	end
end

rules.accelerate.draw=require("render")

-------------------------------dual-----------------------------------
rules.dual={}
rules.dual.name="dual"
rules.dual.time=50
rules.dual.player=1
rules.dual.result={}
rules.dual.item_refresh=10

rules.dual.load=function()	
	game.road=require("objs/road"):new()
    game.road.size=3
  
    local function design()
		game.road:addTrack("c",360)
	end
	game.road:design(design)
	--game.road:generateRndMap(5,50)
    generateCars(rules.dual.player,math.ceil(game.road.count/2))

end

rules.dual.update=function(dt)
	commonUpdate(dt)
	item_refresh(rules.dual.item_refresh,"dual")
	rules.dual.cond()
end


rules.dual.cond=function()
	if game.time>=rules.dual.time then
		if game.over==false then
			game.over=true
			game.finish=-1
		end

	end
	table.sort( game.results, sortfunction )
	if game.finish>0 then game.finish=game.finish-1/60 end
	if game.finish<0 then
		--按分数排列
		table.sort( game.results, function(a,b) 
			if game.allCars[a].score>game.allCars[b].score then
				return true
			else
				return false
			end
		end )
	end
end

rules.dual.draw=require("render")

-----------------------------flag------------------------------
rules.flag={}
rules.flag.name="flag"
rules.flag.time=50
rules.flag.player=1
rules.flag.result={}
rules.flag.item_refresh=10

rules.flag.load=function()	
	game.road=require("objs/road"):new()
    game.road.size=3
  
    local function design()
		game.road:addTrack("c",360)
	end
	game.road:design(design)
	--game.road:generateRndMap(5,50)
    generateCars(rules.flag.player,math.ceil(game.road.count/2))

end

rules.flag.update=function(dt)
	commonUpdate(dt)
	item_refresh(rules.flag.item_refresh,"flag")
	rules.flag.cond()
end


rules.flag.cond=function()
	if game.flagLast==game.flag+1 then
		if game.over==false then
			game.over=true
			game.finish=-1
		end
	end
	if game.finish>0 then game.finish=game.finish-1/60 end
	if game.finish<0 then
		--按分数排列
		table.sort( game.results, function(a,b) 
			if game.allCars[a].score>game.allCars[b].score then
				return true
			else
				return false
			end
		end )
	end
end

rules.flag.draw=require("render")
return rules
