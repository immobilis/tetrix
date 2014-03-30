function changeState( statename )
 package.loaded[curState.name] = nil
 curState:destroy()
 require( statename )
end

function initState( state )
	function state:update( dt )
	end
	function state:draw()
	end
	function state:keypressed( key, isrepeat )
	end
	function state:destroy()
	end
end

require( "states/begin" )