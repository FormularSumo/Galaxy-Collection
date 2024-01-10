function pause(pause)
    if pause ~= nil then 
        paused = pause
    else
        paused = not paused
    end
    if songs[0] then
        if paused then songs[currentSong]:pause() else songs[currentSong]:play() end
    end
    if background['Video'] then
        if paused then background['Background']:pause() else background['Background']:play() end
    end
    if not (winner and gStateMachine.state == 'GameState') then
        gStateMachine:pause()
        if gStateMachine.state == 'GameState' and not blurred then
            blurred = 1
        else
            blurred = nil
        end
    end
end

function loadBattle(background,videos,seek,r,g,b,music,level)
    P2deckCards = level
    if videos and Settings['videos'] then
        gStateMachine:change('GameState',{background, true, seek, r, g, b, music})
    else
        gStateMachine:change('GameState',{background, false, seek, r, g, b, music})
    end
end

function createBackground()
    if background['Video'] then
        background['Background'] = love.graphics.newVideo('Backgrounds/' .. background['Name'] .. '.ogv')
        background['Background']:play()
    else
        background['Background'] = love.graphics.newImage('Backgrounds/' .. background['Name'] .. '.jpg')
    end
end

function updateBackground()
    if Settings['videos'] then
        if love.filesystem.getInfo('Backgrounds/' .. background['Name'] .. '.ogv') then
            background['Video'] = true
        else
            return
        end
    else
        background['Video'] = false
    end
    createBackground()
    collectgarbage()
end

function repositionMouse(index)
    if gui[index] then
        mouseTouching = gui[index]
    else
        for k, pair in pairs(gui) do
            if pair == index then
                mouseTouching = index
                break
            end
        end
        if mouseTouching ~= index then 
            return
        end
    end

    if mouseTouching.y + mouseTouching.height > VIRTUALHEIGHT then
        yscroll = yscroll + (VIRTUALHEIGHT - (mouseTouching.y + mouseTouching.height + 50))
        mouseTouching.y = mouseTouching.initialY + yscroll
    elseif mouseTouching.y < 0 then
        yscroll = yscroll - (mouseTouching.y - 50)
        mouseTouching.y = mouseTouching.initialY + yscroll
    end
    if mouseTouching.percentage then
        mouseButtonX,mouseButtonY = push.toReal(mouseTouching.x + (mouseTouching.width*mouseTouching.percentage),mouseTouching.y + mouseTouching.height/2)
    else
        mouseButtonX,mouseButtonY = push.toReal(mouseTouching.x+mouseTouching.width/2,mouseTouching.y+mouseTouching.height/2)
    end
    love.mouse.setPosition(mouseButtonX,mouseButtonY)
    love.mouse.setVisible(false)
end

function toggleSetting(setting,toggle)
    if toggle ~= nil then
        if toggle == Settings[setting] then return false end
        Settings[setting] = toggle
    else
        Settings[setting] = not Settings[setting]
    end
    bitser.dumpLoveFile('Settings.txt',Settings)
end

function controllerBinds(button)
    if button == 'a' then
        return 'return'
    elseif button == 'b' then
        return 'escape'
    elseif button == 'start' then
        return 'space'
    elseif button == 'dpleft' then
        return 'left'
    elseif button == 'dpright' then
        return 'right'
    elseif button == 'dpup' then
        return 'up'
    elseif button == 'dpdown' then
        return 'down'
    end
    return false
end

function wrap(str, limit)
    limit = limit or 72
    local here = 1
  
    -- the "".. is there because :gsub returns multiple values
    return ""..str:gsub("(%s+)()(%S+)()",
    function(sp, st, word, fi)
          if fi-here > limit then
            here = st
            return "\n"..word
          end
    end)
  end
  
function P1deckEdit(position,name)
    P1deckCards = bitser.loadLoveFile('Player 1 deck.txt')

    if name and name[1] == 'Blank' then name = nil end
    P1deckCards[position] = name

    bitser.dumpLoveFile('Player 1 deck.txt',P1deckCards)
end

function P1cardsEdit(position,name)
    P1cards = bitser.loadLoveFile('Player 1 cards.txt')

    if name and name[1] == 'Blank' then name = nil end
    P1cards[position] = name

    bitser.dumpLoveFile('Player 1 cards.txt',P1cards)
end

function characterStrength(character)
    if character == nil then return 0 end
    if character[1] then
        stats = Characters[character[1]]
        modifier = ((character[2] + (60 - character[2]) / 1.7) / 60) * (1 - ((4 - character[3]) * 0.1))
    else
        stats = Characters[character]
        modifier = 1
    end

    if stats['range'] == 1 then
        offense = ((stats['meleeOffense']*modifier)/800)^4 * 0.9
    else
        rangedOffense = stats['rangedOffense'] or stats['meleeOffense']

        rangedOffense = (rangedOffense/800)^4
        meleeOffense = ((stats['meleeOffense']*modifier)/800)^4

        rangeFactor = ((stats['range']-1.5)/20)^0.55*4.6
        
        if rangedOffense < meleeOffense then
            offense = meleeOffense * 0.9 + rangedOffense * 0.1 * rangeFactor^0.1
        else
            rangeProportion = rangeFactor / (rangeFactor + 1)
            offense = meleeOffense * (1-rangeProportion) + rangedOffense * rangeProportion + (rangedOffense * rangeFactor^0.1 - rangedOffense) * 0.1
        end
    end
    if offense < 10 then
        offense = 10 - (10-offense) / 2
    end
    return offense+((stats['defense']*modifier)/800)^4*(1+stats['evade']^0.6*0.3)
end

function compareCharacterStrength(character1, character2)
    return characterStrength(character1) > characterStrength(character2)
end

function tutorial()
    P1cards = {}
    P1deckCards = {}
    bitser.dumpLoveFile('Player 1 deck.txt',P1deckCards)

    P1deckEdit(1,{'Grogu',60,4})
    P1deckEdit(2,{'Farmboy Luke Skywalker',60,4})
    P1deckEdit(3,{'C-3PO',60,4})
    P1deckEdit(4,{'R2-D2',60,4})

    bitser.dumpLoveFile('Player 1 cards.txt',P1cards)
    P1cards = nil
    UserData['Credits'] = 100
end