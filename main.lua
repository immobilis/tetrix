function love.load()
	require("states/states")
end

function love.update( dt )
	curState:update