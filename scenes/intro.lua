local scene = gamestate.new()
local screen={
	{
		text="A LOVE2D GAME",
		x=400,
		y=300
	},
	{
		text="Alexar Game Studio",
		x=400,
		y=300
	}
}
local index=1
local time=0.5
local alpha=255
local show=false
local font = love.graphics.newFont("lcd.ttf", 80)
love.graphics.setFont(font)
function scene:init()

end 

function scene:enter()

end


function scene:draw()
	love.graphics.setColor(0, 255, 0, alpha)
    love.graphics.printf(screen[index].text, 0, 200, 800, "center")
end

function scene:update(dt)
    alpha=alpha-255*time/60
    if alpha<0 then
    	index=index+1
    	if screen[index] then
    		alpha=255
    	else
    		index=index-1
    		if show==false then player:load();show=true end
    		alpha=0
    		if player.name then
    			gamestate.switch(state.inter,state.start)
    		end
    	end
    end
end 

function scene:keypressed(key)
    if key=="escape" then
        index=index+1
        if not screen[index] then alpha=0 end
    end
end

function scene:leave()


end
return scene