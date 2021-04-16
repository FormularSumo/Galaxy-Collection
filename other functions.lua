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

function exit_state(partial)
    if not partial then 
        love.audio.stop()
        songs = {}
        background = {}
    elseif partial == 'music' then
        background = {}
    end
    gui = {}
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

function switch_state(state)
    gStateMachine:change(state[1],state[2],state[3])
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

function calculate_queue_length()
    queue_length = -1
    for k, pair in pairs(songs) do
        queue_length = queue_length + 1
    end
    current_song = 0
    next_song = 1
end

function toggle_FPS()
    Settings['FPS_counter'] = not Settings['FPS_counter']
    bitser.dumpLoveFile('Settings.txt',Settings)
end

function prebuilt_deck() --Doesn't belong here, will either be deleted or moved when I add deck editing
    P1_deck_edit(0,{'DarthNoscoper',60,4})
    P1_deck_edit(1,{'HermitLuke',60,4})
    P1_deck_edit(2,{'MaceWindu',60,4})
    P1_deck_edit(3,{'Yoda',60,4})
    P1_deck_edit(4,{'AhsokaTanoFulcrum',60,4})
    P1_deck_edit(5,{'LukeSkywalkerROTJ',60,4})
    P1_deck_edit(6,{'KitFisto',60,4})
    P1_deck_edit(7,{'ObiWanKenobi',60,4})
    P1_deck_edit(8,{'HermitYoda',60,4})
    P1_deck_edit(9,{'AhsokaTanoS7',60,4})
    P1_deck_edit(10,{'JaroTapal',60,4})
    P1_deck_edit(11,{'AgenKolar',60,4})
    P1_deck_edit(12,{'BoKatan',60,4})
    P1_deck_edit(13,{'NightsisterMerrin',60,4})
    P1_deck_edit(14,{'Bendu',60,4})
    P1_deck_edit(15,{'BobaFettMandalorian',60,4})
    P1_deck_edit(16,{'TheMandalorian',60,4})
    P1_deck_edit(17,{'KoskaReeves',60,4})
end