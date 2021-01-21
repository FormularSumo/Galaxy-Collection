HomeState = Class{__includes = BaseState}

function HomeState:init()
    videos['background_video'] = love.graphics.newVideo('Videos/Starry Background.ogv')
    sounds['Imperial March piano only'] = love.audio.newSource('Music/Imperial March piano only.oga','stream')
    sounds['Imperial March duet'] = love.audio.newSource('Music/Imperial March duet.mp3','stream')

    videos['background_video']:play()
    sounds['Imperial March piano only']:play()
    played = false
    
    gui['Battle 1'] = Button('battle1','Battle 1',font80,nil,'centre',100)
    gui['Prebuilt Deck'] = Button('prebuilt_deck','Create a pre-built deck',font50,nil,50,120)
end

local function testForBackgroundImageLoop() --Replays the background video each time it ends
    if videos['background_video']:isPlaying() then return end
    videos['background_video']:rewind()
    videos['background_video']:play()
end

function HomeState:update(dt)
    if sounds['Imperial March piano only']:isPlaying() == false and played == false and focus == true then
        sounds['Imperial March duet']:play()
        played = true
    end
    testForBackgroundImageLoop()
end

function HomeState:render()
    love.graphics.draw(videos['background_video'],0,0)
end

function HomeState:exit()
    love.audio.stop()
    gui = {}
    sounds = {}
    videos = {}
    collectgarbage()
end