HomeState = Class{__includes = BaseState}


function HomeState:init()
    background_video = love.graphics.newVideo('Videos/Stary background.ogv')
    background_video:play()
end

local function testForBackgroundImageLoop()
    if background_video:isPlaying() then return end
    background_video:rewind()
    background_video:play()
end

function HomeState:update(dt)
    testForBackgroundImageLoop()
    -- Battle1:update()
end

function HomeState:render()
    love.graphics.draw(background_video,0,0)
    -- Battle1:render()
end