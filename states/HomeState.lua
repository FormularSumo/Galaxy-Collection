HomeState = Class{__includes = BaseState}

function HomeState:init()
    gui[1] = Button(function() gStateMachine:change('CampaignState',true,true) end,'Campaign',font100,nil,'centre',100)
    gui[2] = Button(function() gStateMachine:change('DeckeditState','music','music') end,'Deck Editor',font100,nil,'centre','centre')
    gui[3] = Button(function() gStateMachine:change('SettingsState',true,true) end,'Settings',font100,nil,'centre',980-font100:getHeight('Settings'))
end

function HomeState:enter(partial)
    if partial ~= true then --If partial is equal to 'music' or false or nil
        background['Name'], background['Video'], background['Seek'], rgb = backgroundInfo('Starry Sky')
        createBackground()
    end
    if not partial then --If partial is set to false or nil
        songs[1] = love.audio.newSource('Music/Ahsoka\'s Theme.oga','stream')
        songs[2] = love.audio.newSource('Music/Across The Stars.oga','stream')
        songs[3] = love.audio.newSource('Music/Fallen Order.oga','stream')
        self:shuffle(songs)
    end
end

function HomeState:shuffle(t)
    for i = #t, 2, -1 do
        local j = love.math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function HomeState:back()
    gStateMachine:change('ExitState',true,true)
end

function HomeState:exit()
    for i = 1, love.thread.getChannel("imageDecoderOutput"):getCount() do
        local result = love.thread.getChannel("imageDecoderOutput"):pop()
        if result[1] == "Graphics/Evolution" then
            evolutionImage = love.graphics.newImage(result[2])
        elseif result[1] == "Graphics/Evolution Max" then
            evolutionMaxImage = love.graphics.newImage(result[2])
        end
    end
end 