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

function round( num )
	local x = 0
	if num<0 then x=-.5 else x=.5 end
	local integer = math.modf(num+x)
	return integer
end