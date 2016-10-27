local cam={}

function cam:new()
	camera:setPosition(0,0)
    camera:setWindow(0,0,800,1000)
    camera_mini:setWindow(650,10,150,150)
    camera_mini:setScale(0.1)
    camera:setAngle(math.pi)
end


function cam:update()
	local dr=game.car.body:getAngle()+math.pi
    local x,y=game.car.body:getPosition()
    local cr= camera:getAngle()
    local delta=dr-cr
    local v=math.getDistance(0,0,game.car.body:getLinearVelocity())
    camera:setScale(0.5+0.5*(1-v/1000))
    camera:setPosition(x,y)
    camera:setAngle(cr+(delta*3)*math.pi/200)
    camera_mini:setPosition(x,y)
    if game.shake==true then 
        local maxShake = 5
        local atenuationSpeed = 4
        game.shakeIntensity = math.max(0 , game.shakeIntensity - atenuationSpeed * 0.02)

        if game.shakeIntensity > 0 then
            local x,y = camera:getPosition()
            x = x + (100 - 200*math.random(game.shakeIntensity)) * 0.02
            y = y + (100 - 200*math.random(game.shakeIntensity)) * 0.02
            camera:setPosition(x,y)
        else
            game.shake=false
        end
    end
end




function cam:draw()
	camera:draw(function()
        game.road:draw()     
        for k,v in pairs(game.trace) do
            v:draw()
        end

        game.car:draw()
        for k,v in pairs(game.puff) do
            v:draw()
        end
        for k,v in pairs(game.ex) do
            v:draw()
        end
        for k,v in pairs(game.npc) do
            v:draw()
        end
        
        for k,v in pairs(game.spark) do
            v:draw()
            if v.destroy==true then
                table.remove(game.spark, k)
            end
        end

        for k,v in pairs(game.lightWall) do
            v:draw()
        end
        
        for k,v in pairs(game.item) do
            v:draw()
        end
    end)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.rectangle("line", 640, 5, 160, 160)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle("fill", 641, 6, 158, 159)
    camera_mini:draw(function()
        game.road:draw()
        game.car:draw()
        for k,v in pairs(game.npc) do
            v:draw()
        end
    end)

end

function cam:shake(int)
	int=int or 5
	game.shake=true
    game.shakeIntensity=int
end

return cam