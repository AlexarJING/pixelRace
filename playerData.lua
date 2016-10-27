local player={}

local ui={}
local file= love.filesystem.newFile("gamedata.dat")

function player:save()
	file:open("w")
	local data=bintable.packtable(table.copy(player))
	file:write(data)
	file:close()
	return data
end


function player:load()
	file:open("r")
	local data=file:read()
	file:close()
	if data==nil then self:new();return end
	local tab=bintable.unpackdata(data)
	table.copy(tab,player)
	if not self.name then self:reset() end
end

local function newData(name)
	local tab={}
	tab.name=name
	tab.money=1000
	tab.totalPlayed=0
	tab.totalWin=0
	tab.winRate=0
	tab.totalDistance=0
	tab.moneySpent=0
	tab.career={
		ring=9,
		pass={}
	}
	tab.color={love.math.random(0,255),love.math.random(0,255),love.math.random(0,255)}
	tab.skin=nil
	local parts={"chassis","body","engine","transmission","tire","nitro","disk","painting"}
	tab.shop={}
	for k,v in pairs(parts) do
		tab.shop[v]={1}
	end
	tab.part={}
	for k,v in pairs(parts) do
		tab.part[v]=1
	end	
	table.copy(tab,player)
	player:save()
end

function player:new()

	local frame = loveframes.Create("frame")
	frame:SetName("					Input Name")
	frame:SetSize(300, 120)
	frame:SetPos(250,200)
	frame:ShowCloseButton(false)

	local textinput = loveframes.Create("textinput", frame)
	textinput:SetSize(300, 30)
	textinput:SetPos(20, 40)
	textinput:SetWidth(250)
	textinput:SetFont(love.graphics.newFont("lcd.ttf", 20))

	local button=loveframes.Create("button",frame)
    button:SetText("submit")
    button:SetSize(80, 30)
    button:SetPos(100, 80)
    button.OnClick = function() 
    	newData(textinput:GetText())
    	frame:Remove()
    	self:save()
	end
end

function player:reset()
	love.filesystem.remove("gamedata.dat")
	self:new()
end

local font = love.graphics.newFont("lcd.ttf", 32)
function player:draw()
	if self.money then
		love.graphics.setColor(0, 255, 0, 255)
		love.graphics.setFont(font)
		love.graphics.print("Serial: "..self.name.."   credit: "..self.money, 200, 10 )
	end
end

return player