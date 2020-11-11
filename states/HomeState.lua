HomeState = Class{__includes = BaseState}


function HomeState:init()
    background_video:play()
    sounds['Imperial March piano only']:play()
    played = false
end

local function testForBackgroundImageLoop()
    if background_video:isPlaying() then return end
    background_video:rewind()
    background_video:play()
end

function HomeState:update(dt)
    if sounds['Imperial March piano only']:isPlaying() == false and played == false then
        sounds['Imperial March duet']:play()
        played = true
    end
    testForBackgroundImageLoop()
    for k, pair in pairs(buttons) do
        if pair.should_render == 'homestate' then
            pair:update()
        end
    end
end

function HomeState:render()
    love.graphics.draw(background_video,0,0)
    for k, pair in pairs(buttons) do
        if pair.should_render == 'homestate' then
            pair:render()
        end
    end
end
