HomeState = Class{__includes = BaseState}

function HomeState:init()
    backstate = nil
    gui['CampaignState'] = Button('switch_state',{'CampaignState',true,true},'Campaign',font100,nil,'centre',100)
    gui['SettingsState'] = Button('switch_state',{'SettingsState',true,true},'Settings',font100,nil,'centre',980-font100:getHeight('Settings'))
    gui['Deck Editor'] = Button('switch_state',{'DeckeditState','music','music'},'Deck Editor',font100,nil,'centre','centre')
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
        songs[0] = love.audio.newSource('Music/Across the stars.oga','stream')
        songs[1] = love.audio.newSource('Music/The Mandalorian.oga','stream')
        songs[2] = love.audio.newSource('Music/Cantina Band.oga','stream')

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

function HomeState:exit(partial)
    exit_state(partial)
end