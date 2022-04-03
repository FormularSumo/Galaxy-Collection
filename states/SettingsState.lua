SettingsState = Class{__includes = BaseState}

function SettingsState:init()
    gui[1] = Button(function() toggleSetting('FPS_counter') end,'FPS Counter',font80,nil,'centre',100)
    gui[2] = Slider('centre',330,300,16,function(percentage) love.audio.setVolume(percentage) Settings['volume_level'] = percentage end,0.3,0.3,0.3,1,1,1,Settings['volume_level'],0.5,function() bitser.dumpLoveFile('Settings.txt',Settings) end)
    gui['VolumeLabel'] = Text('Volume',font80,'centre',360)
    gui[3] = Button(function() toggleSetting('videos') gui[3]:toggle() updateBackground() end,function() return 'Videos: ' .. tostring(Settings['videos']) end,font80,nil,'centre',574)

    if OS ~= 'Android' then
        gui[4] = Button(function() toggleSetting('pause_on_loose_focus') gui[4]:toggle() end,function() return ('Pause on losing Window focus: ' .. tostring(Settings['pause_on_loose_focus'])) end,font80,nil,'centre',788)
        gui[5] = Button(function() gStateMachine:change('HomeState',true,true) end,'Main Menu',font80,nil,'centre',965)
    else
        gui[4] = Button(function() gStateMachine:change('HomeState',true,true) end,'Main Menu',font80,nil,'centre',965)
    end
end

function SettingsState:back()
    gStateMachine:change('HomeState',true,true)
end