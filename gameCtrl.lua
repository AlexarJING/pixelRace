return function()
	if game then
		game.world:destroy()
	end
	game={}
	game.font = love.graphics.newFont("lcd.ttf", 16)
	game.fontBig = love.graphics.newFont("lcd.ttf", 32)
	game.fontHuge = love.graphics.newFont("lcd.ttf", 100)
	love.graphics.setFont(game.font)
	game.carIndex=0
	game.world = love.physics.newWorld(0,0)
	game.trace={}
	game.puff={}
	contact=require("contact")
	game.world:setCallbacks(contact.beginContact, contact.endContact,contact.pre,contact.post)
	love.physics.setMeter(10)
	game.oRPM=0
	game.npc={}
	game.ex={}
	game.spark={}
	game.lightWall={}
	game.item={}
	game.cam=require "camera"
	game.cam:new()
	game.todo={}
	game.item_refresh=0
	game.time=0
	game.flag=0
	game.flagLast=1
	game.ready=5
	game.finish=0
	game.results={}
end