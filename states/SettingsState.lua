SettingsState = Class{__includes = BaseState}

function SettingsState:enter()
    gui[1] = Button(function() gStateMachine:change('HomeState',true,true) end,'Main Menu',font70,nil,'centre',50)
    gui[2] = Button(function() toggleSetting('FPS_counter') end,'FPS Counter',font80,nil,'centre',250)
    gui[3] = Slider('centre',350,300,16,function(percentage) love.audio.setVolume(percentage) Settings['volume_level'] = percentage end,{0.3,0.3,0.3},{1,1,1},Settings['volume_level'],0.5,function() bitser.dumpLoveFile('Settings.txt',Settings) end)
    gui['VolumeLabel'] = Text('Volume',font80,'centre',480)
    gui[4] = Button(function() toggleSetting('videos') gui[4]:toggle() updateBackground() end,function() return 'Videos: ' .. tostring(Settings['videos']) end,font80,nil,'centre',664)

    if OS ~= 'Android' then
        gui[5] = Button(function() toggleSetting('pause_on_loose_focus') gui[5]:toggle() end,function() return ('Pause on losing Window focus: ' .. tostring(Settings['pause_on_loose_focus'])) end,font80,nil,'centre',848)
    else
        gui[5] = Button(function() love.system.openURL('https://docs.google.com/document/d/1byO6tONbLSp6fiS2z8zM9zzbytuskc25wgCKwmUS16Q/edit?usp=sharing') end,"Privacy Policy",font80,nil,'centre',848)
    end
end

function SettingsState:keypressed(key,isrepeat)
    if not isrepeat then
        if key == 'm' then
            gui[2].percentage = love.audio.getVolume()
        end
    end
end

function SettingsState:back()
    gStateMachine:change('HomeState',true,true)
end