HomeState = Class{__includes = BaseState}

function HomeState:init()
    gui[1] = Button(switchState,{'CampaignState',true,true},'Campaign',font100,nil,'centre',100)
    gui[2] = Button(switchState,{'DeckeditState','music','music'},'Deck Editor',font100,nil,'centre','centre')
    gui[3] = Button(switchState,{'SettingsState',true,true},'Settings',font100,nil,'centre',980-font100:getHeight('Settings'))
end

function HomeState:enter(partial)
    if not partial then
        background['Name'] = 'Starry Sky'
        background['Video'] = Settings['videos']
        background['Seek'] = 0
        createBackground()
        if love.math.random(0,1) == 1 then
            songs[0] = love.audio.newSource('Music/Ahsoka\'s Theme.oga','stream')
            songs[1] = love.audio.newSource('Music/Across The Stars.oga','stream')
        else
            songs[1] = love.audio.newSource('Music/Ahsoka\'s Theme.oga','stream')
            songs[0] = love.audio.newSource('Music/Across The Stars.oga','stream')
        end

        songs[0]:play()
        calculateQueueLength()
    elseif partial == 'music' then
        background['Name'] = 'Starry Sky'
        background['Video'] = Settings['videos']
        background['Seek'] = 0
        createBackground()
    end
end

function HomeState:back()
    gStateMachine:change('ExitState',true,true)
end