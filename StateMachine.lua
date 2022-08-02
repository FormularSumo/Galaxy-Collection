--
-- StateMachine - a state machine
--
-- Usage:
--
-- -- States are only created as need, to save memory, reduce clean-up bugs and increase speed
-- -- due to garbage collection taking longer with more data in memory.
-- --
-- -- States are added with a string identifier and an intialisation function.
-- -- It is expect the init function, when called, will return a table with
-- -- Render, Update, Enter and Exit methods.
--
-- gStateMachine = StateMachine {
-- 		['MainMenu'] = function()
-- 			return MainMenu()
-- 		end,
-- 		['InnerGame'] = function()
-- 			return InnerGame()
-- 		end,
-- 		['GameOver'] = function()
-- 			return GameOver()
-- 		end,
-- }
-- gStateMachine:change("MainGame")
--
-- Arguments passed into the Change function after the state name
-- will be forwarded to the Enter function of the state being changed too.
--
-- State identifiers should have the same name as the state table, unless there's a good
-- reason not to. i.e. MainMenu creates a state using the MainMenu table. This keeps things
-- straight forward.
--
-- =Doing Transitions=
--
StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		pause = function() end,
		back = function() end,
		keypressed = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
	self.state = nil
end

function StateMachine:change(stateName, enterParams, exitParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit(exitParams)
	if not exitParams then 
        love.audio.stop()
        songs = {}
        background = {}
    elseif exitParams == 'music' then
        background = {}
    end
    gui = {}
    paused = false
    mouseLocked = false
    yscroll = 0
    rawyscroll = 0
    blurred = nil
    collectgarbage()
	self.current = self.states[stateName]()
	self.state = stateName
	self.current:enter(enterParams)
	if songs[0] and not exitParams then
		currentSong = 0
		songs[0]:play()
	end
    if not love.mouse.isVisible() and gui[1] then
        repositionMouse(1)
    end
	maxScroll = math.max(gui[#gui].y + gui[#gui].height + 50 - 1080, 0)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:pause()
	self.current:pause()
end

function StateMachine:back()
	self.current:back()
end

function StateMachine:keypressed(key,isrepeat)
	self.current:keypressed(key,isrepeat)
end

function StateMachine:renderBackground()
	self.current:renderBackground()
end

function StateMachine:renderForeground()
	self.current:renderForeground()
end
