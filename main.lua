function love.load()
 require("states/states")
end

function love.update( dt )
 curState:update()
end

function love.draw()
 curState:draw()
end