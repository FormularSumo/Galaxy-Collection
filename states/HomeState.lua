HomeState = Class{__includes = BaseState}

function HomeState:init()
    gui['CampaignState'] = Button('switch_state',{'CampaignState',true,true},'Campaign',font80,nil,'centre',100)
    gui['Prebuilt Deck'] = Button('prebuilt_deck',nil,'Create a pre-built deck',font80,nil,'centre',500)
    gui['SettingsState'] = Button('switch_state',{'SettingsState',true,true},'Settings',font80,nil,'centre',965)
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

function HomeState:exit(partial)
    exit_state(partial)
end