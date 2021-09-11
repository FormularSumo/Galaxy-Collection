SettingsState = Class{__includes = BaseState}

function SettingsState:init()
    gui[1] = Button('toggle_FPS',nil,'FPS Counter',font80,nil,'centre',100)
    gui[2] = Slider('centre',330,300,16,'volume_slider',0.3,0.3,0.3,1,1,1,Settings['volume_level'],0.5,'volume_slider2')
    gui['VolumeLabel'] = Text('Volume',font80,'centre',360)
    gui[3] = Button('toggle_videos',nil,'Videos: ' .. tostring(Settings['videos']),font80,nil,'centre',574)

    if OS ~= 'Android' then
        gui[4] = Button('toggle_pause_on_loose_focus',nil,'Pause on losing Window focus: ' .. tostring(Settings['pause_on_loose_focus']),font80,nil,'centre',788)
        gui[5] = Button('switch_state',{'HomeState',true,true},'Main Menu',font80,nil,'centre',965)
    else
        gui[4] = Button('switch_state',{'HomeState',true,true},'Main Menu',font80,nil,'centre',965)
    end
end

function SettingsState:back()
    gStateMachine:change('HomeState',true,true)
end

function SettingsState:update(dt)
    if mouseTouching == false or mouseTouching == gui[2] then
        if love.keyboard.wasDown('left') then
            gui[2]:update_percentage(gui[2].percentage - (dt*self.held_time^3)/4,false)
        end
        if love.keyboard.wasDown('right') then
            gui[2]:update_percentage(gui[2].percentage + (dt*self.held_time^3)/4,false)
        end
        if (love.keyboard.wasDown('left') or love.keyboard.wasDown('right')) and not (love.keyboard.wasDown('left') and love.keyboard.wasDown('right')) then
            self.held_time = self.held_time + dt
        else
            self.held_time = 0.5
            if love.keyboard.wasReleased('left') or love.keyboard.wasReleased('right') then
                _G[gui[2].func2]()
                reposition_mouse(gui[2])
            end
        end
    end
end

function SettingsState:exit(partial)
    exit_state(partial)
end