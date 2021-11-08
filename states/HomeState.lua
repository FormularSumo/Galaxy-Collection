HomeState = Class{__includes = BaseState}

function HomeState:init()
    gui[1] = Button('switch_state',{'CampaignState',true,true},'Campaign',font100,nil,'centre',100)
    gui[2] = Button('switch_state',{'DeckeditState','music','music'},'Deck Editor',font100,nil,'centre','centre')
    gui[3] = Button('switch_state',{'SettingsState',true,true},'Settings',font100,nil,'centre',980-font100:getHeight('Settings'))
end

function HomeState:enter(partial)
    if not partial then
        if Settings['videos'] then
            background['Background'] = love.graphics.newVideo('Backgrounds/Starry Sky.ogv')
            background['Type'] = 'video'
        else
            background['Background'] = love.graphics.newImage('Backgrounds/Starry Sky.jpg')
            background['Type'] = 'photo'
        end
        background['Seek'] = 0
        if love.math.random(0,1) == 1 then
            songs[0] = love.audio.newSource('Music/Ahsoka\'s Theme.oga','stream')
            songs[1] = love.audio.newSource('Music/Across The Stars.oga','stream')
        else
            songs[1] = love.audio.newSource('Music/Ahsoka\'s Theme.oga','stream')
            songs[0] = love.audio.newSource('Music/Across The Stars.oga','stream')
        end

        songs[0]:play()
        calculate_queue_length()
    elseif partial == 'music' then
        if Settings['videos'] then
            background['Background'] = love.graphics.newVideo('Backgrounds/Starry Sky.ogv')
            background['Type'] = 'video'
        else
            background['Background'] = love.graphics.newImage('Backgrounds/Starry Sky.jpg')
            background['Type'] = 'photo'
        end
        background['Seek'] = 0
    end
end

function HomeState:back()
    gStateMachine:change('ExitState',true,true)
end

function HomeState:exit(partial)
    exit_state(partial)
end