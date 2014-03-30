curState = {}
curState.name = "states/begin"

initState( curState )

curState.logo = love.graphics.newImage( "res/logo.gif" )
curState.choice = 0

function curState:update( dt )
	-- nope nuthin
end

function curState:draw()
	love.graphics.draw( self.logo, love.window.getWidth() / 2, love.window.getHeight() / 2, 0, 1, 1, self.logo:getWidth() / 2, self.logo:getHeight() / 2 )
	love.graphics.print( "BEGIN", love.window.getWidth() / 2 - self.logo:getWidth() / 2, love.window.getHeight() / 2  + self.logo:getHeight() / 2 + 10 )
	love.graphics.print( "END", love.window.getWidth() / 2 - self.logo:getWidth() / 2, love.window.getHeight() / 2  + self.logo:getHeight() / 2 + 30 )
	love.graphics.print( ">", love.window.getWidth() / 2 - self.logo:getWidth() / 2 - 10, love.window.getHeight() / 2  + self.logo:getHeight() / 2 + 10 + 20 * self.choice )
end

function curState:keypressed( key, isrepeat )
	if key == "down" then
		if self.choice == 0 then
			self.choice = 1
		elseif self.choice == 1 then
			self.choice = 0
		end
	elseif key == "up" then
		if self.choice == 0 then
			self.choice = 1
		elseif self.choice == 1 then
			self.choice = 0
		end
	elseif key == "return" then
		if self.choice == 1 then
			love.event.quit()
		elseif self.choice == 0 then
			changeState( "states/builder" )
		end
	end
end