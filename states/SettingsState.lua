SettingsState = Class{__includes = BaseState}

function SettingsState:init()
    gui['FPS toggle'] = Button('toggle_FPS',nil,'FPS Counter',font80,nil,'centre',100)
    if OS ~= 'Android' then
        gui['Toggle pause on loose focus'] = Button('toggle_pause_on_loose_focus',nil,'Pause on losing Window focus: ' .. tostring(Settings['pause_on_loose_focus']),font80,nil,'centre',250)
    end
    gui['Volume Slider'] = Slider('centre',430,300,12,'volume_slider',0.3,0.3,0.3,1,1,1,Settings['volume_level'],0.5,'volume_slider2')
    gui['Volume Level'] = Text('Volume',font60,'centre',460)
    gui['HomeState'] = Button('switch_state',{'home',true,true},'Main Menu',font80,nil,'centre',965)
end

function SettingsState:enter(partial)
    if not partial then
        background['Background'] = love.graphics.newVideo('Backgrounds/Starry Sky.ogv')
        background['Type'] = 'video'
        background['Seek'] = 0
        songs[0] = love.audio.newSource('Music/Across the stars.oga','stream')
        songs[1] = love.audio.newSource('Music/The Mandalorian.oga','stream')
        songs[2] = love.audio.newSource('Music/Cantina Band.oga','stream')
        songs[3] = love.audio.newSource('Music/Imperial March duet.mp3','stream')

        songs[0]:play()
        calculate_queue_length()
    end
end

function SettingsState:exit(partial)
    exit_state(partial)
end