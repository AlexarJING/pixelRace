require "libs/util"
class=require "libs/middleclass"
camera=require("libs/gamera").new(0,0,9999999,9999999)
camera_mini=require("libs/gamera").new(0,0,9999999,9999999)
vec=require "libs/vector"
tween=require "libs/tween"
explosion= require "objs/explode"
car=require("objs/car")
loveframes=require("libs.loveframes")
gamestate=require("libs/gamestate")
rule=require "rules"
love.math.setRandomSeed(os.time())
reset=require("gameCtrl")
require("libs/bintable")
player=require("playerData")

function love.load() 
    state={}
    local scenes={"intro","start","garage","config","rapid","credits","quit","data","career","menu","help","inter","game"}
    for k,v in pairs(scenes) do
        state[v]=require("scenes."..v)
    end
    gamestate.registerEvents()
    gamestate.switch(state.intro)
end


function love.draw()
    loveframes.draw()
end
function love.update(dt) 
    loveframes.update(dt)
    love.window.setTitle(tostring(love.timer.getFPS()))
end 

function love.keypressed(key,isrepeat) --Callback function triggered when a key is pressed.
    loveframes.keypressed(key, isrepeat)
end

function love.mousepressed(x, y, button) 
    loveframes.mousepressed(x, y, button)
end


function love.keyreleased(key)
    loveframes.keyreleased(key) 
end

function love.textinput(text)
    loveframes.textinput(text)
end

function love.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end
--[[ 这些放在游戏场景中

function love.draw()
    
end



function love.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, isrepeat) 
    loveframes.keypressed(key, isrepeat)
end

function love.keyreleased(key)
    loveframes.keyreleased(key) 
end

function love.textinput(text)
    loveframes.textinput(text)
end

]]





--[[
function love.quit() --Callback function triggered when the game is closed.
end 
function love.resize(w,h) --Called when the window is resized.
end 
function love.textinput(text) --Called when text has been entered by the user.
end 
function love.threaderror(thread, err ) --Callback function triggered when a Thread encounters an error.
end 
function love.visible() --Callback function triggered when window is shown or hidden.
end 
function love.mousefocus(f)--Callback function triggered when window receives or loses mouse focus.
end
function love.mousepressed(x,y,button) --Callback function triggered when a mouse button is pressed.
end 
function love.mousereleased(x,y,button)--Callback function triggered when a mouse button is released.
end 
function love.errhand(err) --The error handler, used to display error messages.
end 
function love.focus(f) --Callback function triggered when window receives or loses focus.
end 
function love.keypressed(key,isrepeat) --Callback function triggered when a key is pressed.
end
function love.keyreleased(key) --Callback function triggered when a key is released.
end 
function love.run() --The main function, containing the main loop. A sensible default is used when left out.
end
]]