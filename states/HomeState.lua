HomeState = Class{__includes = BaseState}

function HomeState:init()
    gui['Maxed Dark Side'] = Button('maxed_dark_side',nil,'Maxed Dark Side',font80,nil,'centre',80)
    gui['Emperor\'s Throne Room'] = Button('throne_room',nil,'Emperor\'s Throne Room',font80,nil,'centre',220)
    gui['Endor'] = Button('endor',nil,'Endor',font80,nil,'centre',360)
    gui['Maxed'] = Button('maxed',nil,'Maxed',font80,nil,'centre',500)
    gui['Prebuilt Deck'] = Button('prebuilt_deck',nil,'Create a pre-built deck',font60,nil,'centre',800)
    if OS ~= 'Android' then
        gui['Toggle pause on loose focus'] = Button('toggle_pause_on_loose_focus',nil,'Pause on losing Window focus: ' .. tostring(Settings['pause_on_loose_focus']),font60,nil,'centre',965)
    end
    gui['FPS toggle'] = Button('toggle_FPS',nil,'FPS Counter',font50,nil,1590,1000)
    gui['Volume Slider'] = Slider(65,1000,300,12,'volume_slider',0.3,0.3,0.3,1,1,1,Settings['volume_level'],0.5,'volume_slider2')
end

function HomeState:enter(partial)
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

function HomeState:update()
end

function HomeState:render()
end

function HomeState:exit(partial)
    exit_state(partial)
end