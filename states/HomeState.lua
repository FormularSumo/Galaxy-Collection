HomeState = Class{__includes = BaseState}

function HomeState:init()
    background['Background'] = love.graphics.newVideo('Backgrounds/Starry Sky.ogv')
    background['Type'] = 'video'
    background['Seek'] = 0
    songs[0] = love.audio.newSource('Music/Imperial March piano only.oga','stream')
    songs[1] = love.audio.newSource('Music/Imperial March duet.mp3','stream')

    songs[0]:play()
    queue_length = 1
    
    gui['Battle 1'] = Button('battle1','Battle 1',font80,nil,'centre',100)
    gui['Empreror\'s Throne Room'] = Button('throne_room','Empreror\'s Throne Room',font80,nil,'centre',200)
    gui['Prebuilt Deck'] = Button('prebuilt_deck','Create a pre-built deck',font50,nil,50,120)
    gui['Toggle pause on loose focus'] = Button('toggle_pause_on_loose_focus', 'Pause on losing Window focus: ' .. tostring(pause_on_loose_focus),font50,nil,'centre',800)
    gui['Volume Slider'] = Slider(100,1000,300,12,'volume_slider',0.3,0.3,0.3,1,1,1,tostring(love.audio.getVolume()),0.5)
end

function HomeState:update()
end

function HomeState:render()
end

function HomeState:exit()
    exit_state()
end