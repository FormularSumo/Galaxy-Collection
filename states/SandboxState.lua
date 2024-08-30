SandboxState = Class{__includes = BaseState}

function SandboxState:enter()
    -- self.backgroundSelection
    -- self.musicSelection
    gui[1] = Button(function() gStateMachine:change('HomeState',true,true) end,'Main Menu',font70,nil,'centre',50)
    -- gui[2] = Slider('centre',330,300,16,function(percentage) love.audio.setVolume(percentage) Settings['volume_level'] = percentage end,{0.3,0.3,0.3},{1,1,1},Settings['volume_level'],0.5,function() bitser.dumpLoveFile('Settings.txt',Settings) end)
    -- gui['VolumeLabel'] = Text('Volume',font80,'centre',360)
    -- gui[3] = Button(function() toggleSetting('videos') gui[3]:toggle() updateBackground() end,function() return 'Videos: ' .. tostring(Settings['videos']) end,font80,nil,'centre',574)

    gui[5] = Button(function() gStateMachine:change('GameState',{'Endor', 'Imperial March Duet.mp3', endor},nil,nil) end,'Begin',font100,nil,'centre',850) --Placeholder gamestate function

end

function SandboxState:back()
    gStateMachine:change('HomeState',true,true)
end