CampaignState = Class{__includes = BaseState}

function CampaignState:init()
    gui['HomeState'] = Button('switch_state',{'HomeState',true,true},'Main Menu',font80,nil,'centre',100)
    gui['Maxed Dark Side'] = Button('maxed_dark_side',nil,'Maxed Dark Side',font80,nil,'centre',380)
    gui['Emperor\'s Throne Room'] = Button('throne_room',nil,'Emperor\'s Throne Room',font80,nil,'centre',520)
    gui['Endor'] = Button('endor',nil,'Endor',font80,nil,'centre',660)
    gui['Maxed'] = Button('maxed',nil,'Maxed',font80,nil,'centre',800)
end

function CampaignState:enter(partial)
    if not partial then
        background['Background'] = love.graphics.newVideo('Backgrounds/Starry Sky.ogv')
        background['Type'] = 'video'
        background['Seek'] = 0
        songs[0] = love.audio.newSource('Music/Across the stars.oga','stream')
        songs[1] = love.audio.newSource('Music/The Mandalorian.oga','stream')
        songs[2] = love.audio.newSource('Music/Cantina Band.oga','stream')
        songs[3] = love.audio.newSource('Music/Imperial March duet.mp3','stream')
        songs[4] = love.audio.newSource('Music/throne room.ogg','stream')

        songs[0]:play()
        calculate_queue_length()
    end
end

function CampaignState:exit(partial)
    exit_state(partial)
end