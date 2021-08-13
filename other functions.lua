function pause(pause)
    if pause ~= nil then 
        paused = pause
    else
        paused = not paused
    end
    if songs[0] ~= nil then
        if paused then songs[current_song]:pause() else songs[current_song]:play() end
    end
    if gStateMachine.state == 'GameState' then
        if paused == true then
            gui[2]:update_text('Play',1591+(font100:getWidth('Pause')-font100:getWidth('Play'))/2)
        else
            gui[2]:update_text('Pause',1591)
        end
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

function exit_game()
    love.event.quit()
end

function reposition_mouse(gui)
    if gui ~= nil then
        love.mouse.setPosition(push:toReal(gui.x+gui.width/2,gui.y+gui.height/2))
    end
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

function toggle_pause_on_loose_focus()
    Settings['pause_on_loose_focus'] = not Settings['pause_on_loose_focus']
    gui[4]:update_text('Pause on losing Window focus: ' .. tostring(Settings['pause_on_loose_focus']))
    bitser.dumpLoveFile('Settings.txt',Settings)
end

function toggle_videos()
    Settings['videos'] = not Settings['videos']
    gui[3]:update_text('Videos: ' .. tostring(Settings['videos']))
    bitser.dumpLoveFile('Settings.txt',Settings)
end

function toggle_FPS()
    Settings['FPS_counter'] = not Settings['FPS_counter']
    bitser.dumpLoveFile('Settings.txt',Settings)
end

function tutorial()
    bitser.dumpLoveFile('Player 1 deck.txt',P1_deck_cards)
    P1_deck_edit(0,{'AnakinSkywalkerROTS',60,4})
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

    P1_cards[0] = {'Maul',60,4}
    P1_cards[1] = {'GeneralGrievous',60,4}
    P1_cards[2] = {'DarthVader',60,4}
    P1_cards[3] = {'CountDooku',60,4}
    P1_cards[4] = {'GrandInquisitor',60,4}
    P1_cards[5] = {'SavageOpress',60,4}
    P1_cards[6] = {'TrillaSuduri',60,4}
    P1_cards[7] = {'PongKrell',60,4}
    P1_cards[8] = {'DarthSidious',60,4}
    P1_cards[9] = {'SupremeLeaderSnoke',60,4}
    P1_cards[10] = {'KyloRen',60,4}
    P1_cards[11] = {'AsajjVentress',60,4}
    P1_cards[12] = {'Cardo',60,4}
    P1_cards[13] = {'BobaFettROTJ',60,4}
    P1_cards[14] = {'DarthSidiousReborn',60,4}
    P1_cards[15] = {'JangoFett',60,4}
    P1_cards[16] = {'Kuruk',60,4}
    P1_cards[17] = {'PurgeTrooper',60,4}
    P1_cards[18] = {'Tokkat',60,4}
    P1_cards[19] = {'Paploo',60,4}
    P1_cards[20] = {'WicketWWarrick',60,4}
    P1_cards[21] = {'Teebo',60,4}
    P1_cards[22] = {'ChiefChirpa',60,4}
    P1_cards[23] = {'Logray',60,4}
    P1_cards[24] = {'ArcTrooperEcho',60,4}
    P1_cards[25] = {'ArcTrooperFives',60,4}
    P1_cards[26] = {'ArcTrooperJesse',60,4}
    P1_cards[27] = {'CommanderCody',60,4}
    P1_cards[28] = {'CaptainRex',60,4}
    P1_cards[29] = {'CloneTrooper322nd',60,4}
    P1_cards[30] = {'CloneTrooper327th',60,4}
    P1_cards[31] = {'CloneTrooper501st',60,4}
    P1_cards[32] = {'CloneTrooper212th',60,4}
    P1_cards[33] = {'CommanderWolffe',60,4}
    P1_cards[34] = {'CoruscantGuardCloneTrooper',60,4}
    P1_cards[35] = {'CloneCommandoGregor',60,4}
    P1_cards[37] = {'ZilloBeast',60,4}
    bitser.dumpLoveFile('Player 1 cards.txt',P1_cards)

    P1_cards = {}

    UserData['Credits'] = 100
end