HomeState = Class{__includes = BaseState}

function HomeState:init()
    background_video:play()
    sounds['Imperial March piano only']:play()
    played = false
    gui['Battle 1'] = Button('battle1','Battle 1',font80,nil,'centre',100)
    gui['Prebuilt Deck'] = Button('prebuilt_deck','Create a pre-built deck',font50,nil,50,120)
end

local function testForBackgroundImageLoop() --Replays the background video each time it ends
    if background_video:isPlaying() then return end
    background_video:rewind()
    background_video:play()
end

function HomeState:update(dt)
    if sounds['Imperial March piano only']:isPlaying() == false and played == false and focus == true then
        sounds['Imperial March duet']:play()
        played = true
    end
    testForBackgroundImageLoop()
end

function HomeState:render()
    love.graphics.draw(background_video,0,0)
end

function HomeState:exit()
    love.audio.stop()
    background_video:pause()
    background_video:rewind()
    gui = {}
end