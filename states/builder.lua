curState = {}
curState.name = "states/builder"

initState( curState )

function curState:init()
	curState.pieces = require("data/pieces")
	curState.board = {}
	for local x = 1, 20, 1
		curState:board[x] = {}
		for local y = 1, 45, 1
			curState:board[y] = 0
		end
	end
	math.randomseed(os.time)
	curState.current = curState.pieces[math.random(7)]
	curState.next1 = curState.pieces[math.random(7)]
	curState.next2 = curState.pieces[math.random(7)]
	curState.xpos = math.random(20 - #current - 1)
	curstate.ypos = -5
end

-- this is where we assign any globals to nil
-- and deny the existence of any require()d files
function curState:destroy()
	package.loaded["data/pieces"] = nil
end