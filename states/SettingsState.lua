SettingsState = Class{__includes = BaseState}

function SettingsState:init()
    gui[1] = Button(toggleFPS,nil,'FPS Counter',font80,nil,'centre',100)
    gui[2] = Slider('centre',330,300,16,volumeSlider,0.3,0.3,0.3,1,1,1,Settings['volume_level'],0.5,volumeSlider2)
    gui['VolumeLabel'] = Text('Volume',font80,'centre',360)
    gui[3] = Button(toggleVideos,nil,'Videos: ' .. tostring(Settings['videos']),font80,nil,'centre',574)

    if OS ~= 'Android' then
        gui[4] = Button(togglePauseOnLooseFocus,nil,'Pause on losing Window focus: ' .. tostring(Settings['pause_on_loose_focus']),font80,nil,'centre',788)
        gui[5] = Button(switchState,{'HomeState',true,true},'Main Menu',font80,nil,'centre',965)
    else
        gui[4] = Button(switchState,{'HomeState',true,true},'Main Menu',font80,nil,'centre',965)
    end
end

function SettingsState:back()
    gStateMachine:change('HomeState',true,true)
end