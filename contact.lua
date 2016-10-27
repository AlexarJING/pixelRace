local c={}

local function getDist(p1,p2)
	local dist=math.abs(p1-p2)
	local dist2=game.road.count-dist
	if dist>dist2 then dist=dist2 end
	return dist
end

local function begin(a,b,coll)
	local objA=a:getUserData()
	local objB=b:getUserData()
	local dist=getDist(objB.posInRoad,objA.posInRoad)
	if objA.type=="sensor" and objB.type~="sensor" and objB.type~="wall" then
		if dist<=5 then
			objB.posInRoad=objA.posInRoad
		end
	end
	if objA.type=="item" and objB.type=="car" and objA.enable==true and dist<=5 then
		if objA.item=="flag" then
			if objA.flag==game.flagLast then
				game.flagLast=game.flagLast+1
				objA.enable=false
				objB.flag=objB.flag+1
				local func=function()
					explosion:new(objA,5,1000,1)
				end
				if objB==game.car then
					objA:get(game.npc[1])
				else
					objA:get(game.car)
				end
				table.insert(game.todo, func)
			end
		else
			objA.enable=false
			local func=function()
				explosion:new(objA,5,1000,1)
			end
			objA:get(objB)
			table.insert(game.todo, func)
		end
	end
end

local function pre(a,b,coll)

	local objA=a:getUserData()
	local objB=b:getUserData()
	local dist=getDist(objA.posInRoad,objB.posInRoad)
	if dist>5 then
		coll:setEnabled(false)
	end
end

local function post(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	local objA=a:getUserData()
	local objB=b:getUserData()
	if objA.type=="car" and objB.type~="sensor" and objB.type~="explosion" then
		if math.abs(tangentimpulse1)>0.5 or math.abs(normalimpulse1)>0.5 then
			require("objs/spark"):new(objA,coll,normalimpulse1, tangentimpulse1)
		end
	end

end


local function endC(a,b,coll)
	local objA=a:getUserData()
	local objB=b:getUserData()
	if objA.type=="lightWall" and objB.type~="sensor" and objB.type~="explosion" then
		for i=1,7 do
			local wall=game.lightWall[objA:getIndex()-3+i]
			if wall and not wall.disable then
				wall.disable=true
				local func=function()
					explosion:new(wall,5,1000,1)
				end
				table.insert(game.todo, func)
			end
		end
	end

	if objA.type=="disk" and objA.enable==true then
		if objB.type=="wall" then objA.life=objA.life-1 end
		if objB.type=="car" and objB.enable==true then 
			objA.life=objA.life-3;
			objB.enable=false
			if not objA.shieldActive then
				local func=function()
					objB.hurt=objB.hurt+1
					objB:explode()
				end
				table.insert(game.todo, func)
			end
		end
	end
end


function c.beginContact(a,b,coll)
	begin(a,b,coll)
	begin(b,a,coll)
end

function c.endContact(a,b,coll)
	endC(a,b,coll)
	endC(b,a,coll)
end

function c.pre(a,b,coll)
	pre(a,b,coll)
end


function c.post(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	post(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	post(b, a, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

return c

