curState = {}
curState.name = "states/builder"

initState( curState )

function curState:init()
	-- load data
	local piecesdata = require("data/pieces")
	self.pieces = piecesdata.pieces
	self.colors = piecesdata.colors

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
end

function curState:update( dt )
	-- apply gravity
	self.ypos = self.ypos + 2 * dt
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

-- this is where we assign any globals to nil
-- and deny the existence of any require()d files
-- not yet unloaded
function curState:destroy()
	package.loaded["data/pieces"] = nil
end