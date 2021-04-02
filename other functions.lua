function pause(pause)
    if pause ~= nil then 
        paused = pause
    else
        paused = not paused
    end
    if songs[0] ~= nil then
        if paused then songs[current_song]:pause() else songs[current_song]:play() end
    end
end

function exit_state()
    love.audio.stop()
    gui = {}
    songs = {}
    background = {}
    current_song = 0
    next_song = 1
    paused = false
    collectgarbage()
end

function toggle_pause_on_loose_focus()
    Settings['pause_on_loose_focus'] = not Settings['pause_on_loose_focus']
    gui['Toggle pause on loose focus']:update_text('Pause on losing Window focus: ' .. tostring(Settings['pause_on_loose_focus']))
    bitser.dumpLoveFile('Settings.txt',Settings)
end

function gamespeed_slider(percentage)
    gamespeed = percentage * 4
end

function volume_slider(percentage)
    love.audio.setVolume(percentage)
    Settings['volume_level'] = percentage
end

function volume_slider2()
    bitser.dumpLoveFile('Settings.txt',Settings)
end

function return_to_main_menu()
    gStateMachine:change('home')
end

function update_mouse_position()
    mouseDown = true
    mouseLastX,mouseLastY = push:toGame(love.mouse.getPosition())
    if mouseLastX == nil or mouseLastY == nil then
        mouseLastX = -1
        mouseLastY = -1
        mouseDown = false
    end
end

function testForBackgroundImageLoop(video,seek) --Replays the inputted video if it's finished
    if video:isPlaying() then return end
    video:seek(seek)
    video:play()
end

function prebuilt_deck() --Doesn't belong here, will either be deleted or moved when I add deck editing
    P1_deck_edit(0,'LukeSkywalkerROTJ')
    P1_deck_edit(1,'AhsokaTanoFulcrum')
    P1_deck_edit(2,'MaceWindu')
    P1_deck_edit(3,'Yoda')
    P1_deck_edit(4,'AnakinSkywalkerROTS')
    P1_deck_edit(5,'ObiWanKenobi')
    P1_deck_edit(6,'PloKoon')
    P1_deck_edit(7,'SaeseeTiin')
    P1_deck_edit(8,'AhsokaTanoS7')
    P1_deck_edit(9,'KitFisto')
    P1_deck_edit(10,'KiAdiMundi')
    P1_deck_edit(11,'ShaakTi')
    P1_deck_edit(12,'CaptainRex')
    P1_deck_edit(13,'BoKatan')
    P1_deck_edit(14,'BobaFettMandalorian')
    P1_deck_edit(15,'TheMandalorian')
    P1_deck_edit(16,'CaraDune')
    P1_deck_edit(17,'CommanderCody')
end