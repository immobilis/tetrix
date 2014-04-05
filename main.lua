function love.load()
	require("states/states")
end

function love.update( dt )
	curState:update( dt )
end

function love.draw()
	curState:draw()
end

function love.keypressed( key, isrepeat )
	curState:keypressed( key, isrepeat )
end