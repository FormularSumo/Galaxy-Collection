HomeState = Class{__includes = BaseState}

function HomeState:init()
    gui['Campaign'] = Button('switch_state',{'CampaignState',true,true},'Campaign',font100,nil,'centre',100)
    gui['Deck Editor'] = Button('switch_state',{'DeckeditState','music','music'},'Deck Editor',font100,nil,'centre','centre')
    gui['Settings'] = Button('switch_state',{'SettingsState',true,true},'Settings',font100,nil,'centre',980-font100:getHeight('Settings'))
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

function HomeState:back()
    gStateMachine:change('ExitState',true,true)
end

function HomeState:arrow(direction)
    if mouseTouching == false then 
        return gui['Campaign']
    elseif mouseTouching == gui['Campaign'] then
        if direction == 'up' then
            return gui['Settings']
        end
        if direction == 'down' then
            return gui['Deck Editor']
        end
    elseif mouseTouching == gui['Deck Editor'] then
        if direction == 'up' then
            return gui['Campaign']
        elseif direction == 'down' then
            return gui['Settings']
        end
    elseif mouseTouching == gui['Settings'] then
        if direction == 'up' then
            return gui['Deck Editor']
        end
        if direction == 'down' then
            return gui['Campaign']
        end
    end
    return mouseTouching
end

function HomeState:exit(partial)
    exit_state(partial)
end