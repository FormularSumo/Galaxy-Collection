HomeState = Class{__includes = BaseState}

function HomeState:init()
    gui[1] = Button(function() gStateMachine:change('CampaignState',true,true) end,'Campaign',font100,nil,'centre',100)
    gui[2] = Button(function() gStateMachine:change('DeckeditState','music','music') end,'Deck Editor',font100,nil,'centre','centre')
    gui[3] = Button(function() gStateMachine:change('SettingsState',true,true) end,'Settings',font100,nil,'centre',980-font100:getHeight('Settings'))
end

function HomeState:enter(partial)
    if not partial then
        if love.math.random(0,1) == 1 then
            songs[0] = love.audio.newSource('Music/Ahsoka\'s Theme.oga','stream')
            songs[1] = love.audio.newSource('Music/Across The Stars.oga','stream')
        else
            songs[1] = love.audio.newSource('Music/Ahsoka\'s Theme.oga','stream')
            songs[0] = love.audio.newSource('Music/Across The Stars.oga','stream')
        end
    background = love.graphics.newImage('Backgrounds/Starry Sky.jpg')
end

function HomeState:back()
    gStateMachine:change('ExitState',true,true)
end