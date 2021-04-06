HomeState = Class{__includes = BaseState}

function HomeState:init()
    background['Background'] = love.graphics.newVideo('Backgrounds/Starry Sky.ogv')
    background['Type'] = 'video'
    background['Seek'] = 0
    songs[0] = love.audio.newSource('Music/Across the stars.oga','stream')
    songs[1] = love.audio.newSource('Music/The Mandalorian.oga','stream')
    songs[2] = love.audio.newSource('Music/Cantina Band.oga','stream')
    songs[3] = love.audio.newSource('Music/Imperial March Duet.mp3','stream')

    songs[0]:play()
    queue_length = 3
    
    gui['Maxed Dark Side'] = Button('maxed_dark_side','Maxed Dark Side',font80,nil,'centre',80)
    gui['Emperor\'s Throne Room'] = Button('throne_room','Emperor\'s Throne Room',font80,nil,'centre',220)
    gui['Endor'] = Button('endor','Endor',font80,nil,'centre',360)
    gui['Maxed'] = Button('maxed','Maxed',font80,nil,'centre',500)
    gui['Prebuilt Deck'] = Button('prebuilt_deck','Create a pre-built deck',font50,nil,'centre',750)
    gui['Toggle pause on loose focus'] = Button('toggle_pause_on_loose_focus', 'Pause on losing Window focus: ' .. tostring(Settings['pause_on_loose_focus']),font50,nil,'centre',900)
    gui['Volume Slider'] = Slider(100,1000,300,12,'volume_slider',0.3,0.3,0.3,1,1,1,Settings['volume_level'],0.5,'volume_slider2')
end

function HomeState:update()
end

function HomeState:render()
end

function HomeState:exit()
    exit_state()
end