HomeState = Class{__includes = BaseState}

function HomeState:enter(partial)
    if partial ~= true then --If partial is equal to 'music' or false or nil
        background = backgroundInfo('Starry Sky')
        background = love.graphics.newImage(background)
    end
    if not partial then --If partial is set to false or nil
        songs[1] = love.audio.newSource('Music/Ahsoka\'s Theme.oga','stream')
        songs[2] = love.audio.newSource('Music/Across The Stars.oga','stream')
        songs[3] = love.audio.newSource('Music/Fallen Order.oga','stream')
        self:shuffle(songs)
    end

    gui[1] = Button(function() gStateMachine:change('CampaignState',true,true) end,'Campaign',font100,nil,'centre',100)
    gui[2] = Button(function() gStateMachine:change('DeckeditState','music','music') end,'Deck Editor',font100,nil,'centre','centre')
    gui[3] = Button(function() gStateMachine:change('SettingsState',true,true) end,'Settings',font100,nil,'centre',980-font100:getHeight('Settings'))
end

function HomeState:shuffle(t)
    for i = #t, 2, -1 do
        local j = love.math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function HomeState:back()
end