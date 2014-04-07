curState = {}
curState.name = "states/builder"

initState( curState )

function curState:init()
	-- load data
	local piecesdata = require("data/pieces")
	self.pieces = piecesdata.pieces
	self.colors = piecesdata.colors
	curState.rotatePiece = piecesdata.rotatePiece

	-- remove stray data, but remember
	-- loaded packages
	package.loaded["data/pieces"] = true

	-- load resources
	self.block = love.graphics.newImage( "res/block.png" )

	-- init board
	self.board = {}
	for x = 1, 20, 1 do
		self.board[x] = {}
		for y = 1, 45, 1 do
			self.board[x][y] = 0
		end
	end

	-- randomly generate initial values regarding pieces
	math.randomseed( os.time() )
	self.current = self.pieces[math.random( 7 )]
	self.next1 = self.pieces[math.random( 7 )]
	self.next2 = self.pieces[math.random( 7 )]
	self.xpos = math.random( 20 - #self.current - 1 )
	self.ypos = -5
	self.xvel = 0
	self.yvel = 2
	self.yvmax = 2
end

function curState:update( dt )
	-- apply gravity
	self.ypos = self.ypos + self.yvel * dt

	-- yvel will remain at max if it doesn't hit anything
	self.yvel = self.yvmax
	-- check collision with other pieces
	-- and bottom of board
	for x, r in ipairs( self.current ) do
		for y, b in ipairs( r ) do
			-- check to see if this is a block and
			-- if it is on the bottom of the piece
			-- and if it is on the board
			if b ~= 0 and (not r[y + 1] or r[y + 1] == 0) and self.ypos + y - 1 >= 0 then
				-- if there is something below it then
				if self.board[math.ceil( self.xpos ) + x - 1][math.floor( self.ypos ) + y] ~= 0 or self.board[math.floor( self.xpos ) + x - 1][math.floor( self.ypos ) + y] ~= 0 then
					-- put the piece back in a cube
					self.ypos = math.floor(self.ypos)
					-- stop the piece
					self.yvel = 0
					break -- out of yloop
				end -- belowif
			end -- bottomif
		end -- yloop
		-- easy breakage when piece is stopped
		if self.yvel == 0 then break end
	end -- xloop

	-- apply x velocity
	self.xpos = self.xpos + self.xvel * dt

	-- check collision with other pieces
	-- and sides of board
	if self.xvel < 0 then
		for x, r in ipairs( self.current ) do
			for y, b in ipairs( r ) do
				-- check to see if this is a block and
				-- if it is on the left side of the piece
				-- and if it is on the board
				if b ~= 0 and ( not self.current[x - 1] or self.current[x - 1][y] == 0) and self.ypos + y - 1 >= 0 then
					-- if there is something to the left of it then
					if not self.board[math.floor(self.xpos) + x - 1] or self.board[math.floor(self.xpos) + x - 1][math.ceil(self.ypos) + y - 1] ~= 0 or self.board[math.floor(self.xpos) + x - 1][math.floor(self.ypos) + y - 1] ~= 0 then
						self.xpos = math.ceil(self.xpos)
						self.xvel = 0
						break -- out of yloop
					end -- leftif
				end -- sideif
			end -- yloop
			-- easy breakage when piece is stopped
			if self.xvel == 0 then break end
		end -- xloop
	elseif self.xvel > 0 then
		for x, r in ipairs( self.current ) do
			for y, b in ipairs( r ) do
				-- check to see if this is a block and
				-- if it is on the right side of the piece
				-- and if it is on the board
				if b ~= 0 and ( not self.current[x + 1] or self.current[x + 1][y] == 0) and self.ypos + y - 1 >= 0 then
					-- if there is something to the right of it then
					if not self.board[math.ceil(self.xpos) + x - 1] or self.board[math.ceil(self.xpos) + x - 1][math.ceil(self.ypos) + y - 1] ~= 0 or self.board[math.ceil(self.xpos) + x - 1][math.floor(self.ypos) + y - 1] ~= 0 then
						self.xpos = math.floor(self.xpos)
						self.xvel = 0
						break -- out of yloop
					end -- leftif
				end -- sideif
			end -- yloop
			-- easy breakage when piece is stopped
			if self.xvel == 0 then break end
		end -- xloop
	end

	-- if the piece has stopped then
	if self.xvel == 0 and self.yvel == 0 then
		-- put the piece on the board
		for x, r in ipairs( self.current ) do
			for y, b in ipairs( r ) do
				if b ~= 0 then
					self.board[round(self.xpos) + x - 1][round(self.ypos) + y - 1] = b
				end
			end
		end

		-- move up the queue, generate another piece, and
		-- place it above the board
		self.current = self.next1
		self.next1 = self.next2
		self.next2 = self.pieces[math.random( 7 )]
		self.xpos = math.random( 20 - #self.current - 1 )
		self.ypos = -5
		self.xvel = 0
		self.yvel = 2
	end
end

function curState:draw()
	-- draw the pieces on the board
	for x, r in ipairs( self.board ) do
		for y, b in ipairs( r ) do
			love.graphics.setColor( self.colors[b] )
			love.graphics.draw( self.block, (x * 20 - 20), (y * 20 - 20) )
		end
	end
	-- draw the current playing piece
	for x, r in ipairs( self.current ) do
		for y, b in ipairs( r ) do
			love.graphics.setColor( self.colors[b] )
			love.graphics.draw( self.block, (self.xpos * 20 - 20) + (x * 20 - 20), (self.ypos * 20 - 20) + (y * 20 - 20) )
		end
	end
end

function curState:keypressed( key, isrepeat )
	if key == "left" then
		self.xvel = -6
	elseif key == "right" then
		self.xvel = 6
	elseif key == "down" then
		self.yvmax = 8
	elseif key == "up" then
		self.yvmax = 2
	end
end

-- this is where we assign any globals to nil
-- and deny the existence of any require()d files
-- not yet unloaded
function curState:destroy()
	package.loaded["data/pieces"] = nil
end