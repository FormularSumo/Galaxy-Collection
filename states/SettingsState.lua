SettingsState = Class{__includes = BaseState}

function SettingsState:init()
    gui['FPS toggle'] = Button('toggle_FPS',nil,'FPS Counter',font80,nil,'centre',100)
    gui['Volume Slider'] = Slider('centre',330,300,16,'volume_slider',0.3,0.3,0.3,1,1,1,Settings['volume_level'],0.5,'volume_slider2')
    gui['Volume Level'] = Text('Volume',font80,'centre',360)
    gui['Videos'] = Button('toggle_videos',nil,'Videos: ' .. tostring(Settings['videos']),font80,nil,'centre',574)

    if OS ~= 'Android' then
        gui['Toggle pause on loose focus'] = Button('toggle_pause_on_loose_focus',nil,'Pause on losing Window focus: ' .. tostring(Settings['pause_on_loose_focus']),font80,nil,'centre',788)
    end

    gui['HomeState'] = Button('switch_state',{'HomeState',true,true},'Main Menu',font80,nil,'centre',965)
end

function SettingsState:back()
    gStateMachine:change('HomeState',true,true)
end

function SettingsState:update(dt)
    if mouseTouching == gui['Volume Slider'] then
        if love.keyboard.isDown('left') then
            gui['Volume Slider']:update_percentage(gui['Volume Slider'].percentage - (dt*self.held_time^3)/4,false)
        end
        if love.keyboard.isDown('right') then
            gui['Volume Slider']:update_percentage(gui['Volume Slider'].percentage + (dt*self.held_time^3)/4,false)
        end
        if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
            self.held_time = self.held_time + dt
        else
            self.held_time = 0.5
        end
    end
end

function SettingsState:exit(partial)
    exit_state(partial)
end