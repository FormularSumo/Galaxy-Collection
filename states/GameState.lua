GameState = Class{__includes = BaseState}

function GameState:init()
    evolution= love.graphics.newImage('Graphics/Evolution.png')
    evolutionMax = love.graphics.newImage('Graphics/Evolution Max.png')

    P1deckCards = bitser.loadLoveFile('Player 1 deck.txt')
    P1deck = {}
    P2deck = {}
    Projectiles = {}
    Weapons = {}
    cards = {}
    gamespeed = 1
    Nextcards = {
        [0] = 18,
        [1] = 19,
        [2] = 20,
        [3] = 21,
        [4] = 22,
        [5] = 23,
    }

    P1length = 0
    for k, pair in pairs(P1deckCards) do
        if k > P1length then
            P1length = k
        end
    end
    P2length = P2deckCards('max')

    for i=0,math.min(18,math.max(P1length,P2length)) do
        if P1deckCards[i] then
            P1deck[i] = Card(P1deckCards[i],1,i,-1 - math.floor((i)/6))
        end
        if P2deckCards(i) then
            P2deck[i] = Card(P2deckCards(i),2,i,12 + math.floor((i)/6))
        end
    end
    P1angle = math.rad(210)
    P2angle = math.rad(150)
end

function GameState:enter(Background)
    background['Name'] = Background[1]
    background['Video'] = Background[2]
    background['Seek'] = Background[3]
    createBackground()

    songs[0] = love.audio.newSource('Music/' .. Background[7],'stream')
    songs[0]:play()
    calculateQueueLength()

    if Background[4] == nil then r = 0 else r = Background[4] end
    if Background[5] == nil then g = 0 else g = Background[5] end
    if Background[6] == nil then b = 0 else b = Background[6] end
    gui[1] = Button(pause,'Pause',font100,nil,1591,0,r,g,b) -- 35 pixels from right as font100:getWidth('Pause') = 294
    gui[2] = Slider(1591,130,300,16,function(percentage) gamespeed = percentage * 4 end,0.3,0.3,0.3,r,g,b,0.25,0.25)
    gui['SpeedLabel'] = Text('Speed',font80,'centre',410,r,g,b,false)
    gui[3] = Slider('centre',570,300,16,function(percentage) love.audio.setVolume(percentage) Settings['volume_level'] = percentage end,0.3,0.3,0.3,r,g,b,Settings['volume_level'],0.5,function() bitser.dumpLoveFile('Settings.txt',Settings) end,false,false)
    gui['VolumeLabel'] = Text('Volume',font80,'centre',600,r,g,b,false)
    gui[4] = Button(function() gStateMachine:change('HomeState') end,'Main Menu',font80,nil,'centre',1080-220-font80:getHeight('Main Menu'),r,g,b,nil,false)

    if background['Seek'] > 1 then --All levels have at least a 1 second delay before spawing characters
        timer = 0 - (background['Seek'] - 1)
    else
        timer = 0
    end
    moveAimTimer = timer
    attackTimer = timer - 0.9
    love.timer.step()
end

function Move()
    RowsRemaining(P1deck)
    RowsRemaining(P2deck)
    if P1rowsRemaining == 1 and P2rowsRemaining == 1 then
        if P1rows[3] then
            MoveUp(P1deck,3)
            return
        end
        if P2rows[3] then
            MoveUp(P2deck,3)
            return
        end
    end
   
    rows = P1rows
    enemyRows = P2rows
    rowsRemaining = P2rowsRemaining
    Move2(P1deck)
    rows = P2rows
    enemyRows = P1rows
    rowsRemaining = P1rowsRemaining
    Move2(P2deck)
end

function RowsRemaining(deck)
    rows = {
        [0] = false,
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false
    }

    for k, pair in pairs(deck) do
        rows[pair.row] = true
        if rows[0] and rows[1] and rows[2] and rows[3] and rows[4] and rows[5] and rows[6] then break end
    end

    rowsRemaining = 0
    for k, pair in pairs(rows) do
        if pair == true then
            rowsRemaining = rowsRemaining + 1
        end
    end
    if deck == P1deck then
        P1rows = rows
        P1rowsRemaining = rowsRemaining
    else
        P2rows = rows
        P2rowsRemaining = rowsRemaining
    end
end

function Move2(deck)
    if rows[0] == false and rows[1] == false and rows[5] == true then
        MoveUp(deck,2)
        MoveUp(deck,3)
        MoveUp(deck,4)
        MoveUp(deck,5)
    elseif rows[4] == false and rows[5] == false and rows[0] == true then
        MoveDown(deck,3)
        MoveDown(deck,2)
        MoveDown(deck,1)
        MoveDown(deck,0)
    else
        if rows[2] == false then
            if (rows[0] == false and rows[5] == true) or (rows[1] == false and rows[4] == true) or ((rowsRemaining == 1 and enemyRows[2]) and (rows[5] or not rows[0] and rows[4])) then
                MoveUp(deck,3)
                MoveUp(deck,4)
                MoveUp(deck,5)
                return
            else
                MoveDown(deck,1)
                MoveDown(deck,0)
            end
        elseif rows[1] == false then 
            MoveDown(deck,0)
        end
        if rows[3] == false then
            if (rows[5] == false and rows[0] == true) or (rows[4] == false and rows[1] == true) or (rowsRemaining == 1 and enemyRows[3])  then
                MoveDown(deck,2)
                MoveDown(deck,1)
                MoveDown(deck,0)
                return
            else
                MoveUp(deck,4)
                MoveUp(deck,5)
            end
        elseif rows[4] == false then
            MoveUp(deck,5)
        end
    end
end

function MoveDown(deck,row)
    if rows[row] then
        for k, pair in pairs(deck) do
            if deck[k].row == row then
                deck[k].number = deck[k].number + 1
                deck[k].targetY = deck[k].targetY + 180
                deck[k].row = row + 1
                deck[k+1] = deck[k]
                deck[k] = nil
            end
        end
    end
end

function MoveUp(deck,row)
    if rows[row] then
        for k, pair in pairs(deck) do
            if deck[k].row == row then
                deck[k].number = deck[k].number - 1
                deck[k].targetY = deck[k].targetY - 180
                deck[k].row = row - 1
                deck[k-1] = deck[k]
                deck[k] = nil
            end
        end
    end
end

function checkHealth()
    for k, pair in pairs(P1deck) do
        if pair.health <= 0 then
            P1deck[k] = nil
        end
    end
    for k, pair in pairs(P2deck) do
        if pair.health <= 0 then
            P2deck[k] = nil
        end
    end
end


function GameState:pause()
    if paused == true then
        gui[1]:updateText('Play','centre',220,font80)
        gui[2]:updatePosition('centre',380)
        gui[2].default = false
        if not winner then
            gui[4]:updateText('Main Menu','centre',1080-220-font80:getHeight('Main Menu'))
        end
        gui[2].visible = true
        gui[4].visible = true
        gui['SpeedLabel'].visible = true
        gui[3].visible = true
        gui['VolumeLabel'].visible = true
    else
        gui[1]:updateText('Pause',1591,0,font100)
        gui[2].default = true
        gui[2]:updatePosition('1591',130,1591,0)
        gui[4]:updateText('Main Menu',35,20)
        if not winner then
            gui[4].visible = false
        end
        gui['SpeedLabel'].visible = false
        gui[3].visible = false
        gui['VolumeLabel'].visible = false
    end
end

function GameState:back()
    if not winner then
        pause()
    else
        gStateMachine:change('HomeState')
    end
end

function GameState:keypressed(key,isrepeat)
    if not isrepeat then
        if key == 'm' then
            gui[3].percentage = love.audio.getVolume()
        elseif gui[2] then
            if key == 'pageup' then 
                gui[2]:updatePercentage(gui[2].percentage * 2,false)
            elseif key == 'pagedown' then
                gui[2]:updatePercentage(gui[2].percentage / 2,false)
            end
        end
    end
    if key == 'space' then
        pause()
    end
end

function GameState:update(dt)
    if paused == false and not winner then
        dt = dt * gamespeed
        timer = timer + dt
        if timer >= 7.4 then timer = timer - 1 end
        moveAimTimer = moveAimTimer + dt
        attackTimer = attackTimer + dt

        for k, pair in pairs(P1deck) do
            pair:update(dt)
        end
        for k, pair in pairs(P2deck) do
            pair:update(dt)
        end

        if timer > 6.4 then
            if timer < 6.9 then
                if P1angle < math.rad(270) then
                    P1angle = P1angle + dt * 2
                end
                if P2angle > math.rad(90) then
                    P2angle = P2angle - dt * 2
                end
            elseif timer < 7.4 then
                if P1angle > math.rad(210) then
                    P1angle = P1angle - dt * 2
                end
                if P2angle < math.rad(150) then
                    P2angle = P2angle + dt * 2
                end
            end
        end

        if moveAimTimer >= 1 then
            moveAimTimer = moveAimTimer - 1

            if timer < 7 then
                for k, pair in pairs(P1deck) do
                    pair:move()
                end
                for k, pair in pairs(P2deck) do
                    pair:move()
                end
                
                if timer > 3 and P2length > timer * 6 then
                    for i=0,5 do
                        if P2deckCards(Nextcards[i]) then
                            P2deck[Nextcards[i]] = Card(P2deckCards(Nextcards[i]),2,Nextcards[i],12)
                            Nextcards[i] = Nextcards[i] + 6
                        end
                    end
                end

            else
                if P2length > timer * 6 then
                    for i=0,5 do
                        if not P2deck[36+i] and P2deckCards(Nextcards[i]) then
                            P2deck[36+i] = Card(P2deckCards(Nextcards[i]),2,36+i,12)
                            Nextcards[i] = Nextcards[i] + 6
                        end
                    end
                end
                for k, pair in pairs(P1deck) do
                    pair:move2()
                end 
                for k, pair in pairs(P2deck) do
                    pair:move2()
                end
            end

            if timer > 3 then
                Move()
            end

            for k, pair in pairs(P1deck) do
                pair:aim()
            end
            for k, pair in pairs(P2deck) do
                pair:aim()
            end
        end

        if attackTimer >= 1 then
            attackTimer = attackTimer - 1

            for k, pair in pairs(P1deck) do
                pair.dodge = 0
                pair.attacksTaken = 0
            end
            for k, pair in pairs(P2deck) do
                pair.dodge = 0
                pair.attacksTaken = 0
            end

            for k, pair in pairs(P1deck) do
                pair:attack()
            end
            for k, pair in pairs(P2deck) do
                pair:attack()
            end

            checkHealth()
            
            if not next(P1deck) then
                P1deck = nil
            end
            if not next(P2deck) then
                P2deck = nil
            end
            if P1deck == nil or P2deck == nil then
                if P1deck == nil and P2deck == nil then 
                    winner = 'Draw'
                elseif P1deck == nil then
                    winner = 'P2'
                elseif P2deck == nil then
                    winner = 'P1'
                end
                gui[4].visible = true
                gui[4]:updateText('Main Menu',35,20)
                if mouseTouching == gui[1] and not love.mouse.isVisible() then repositionMouse(gui[4]) end
                gui[1] = gui[4]
                for k, pair in pairs(gui) do
                    if k ~= 1 then
                        gui[k] = nil
                    end
                end
                Projectiles = nil
                Weapons = nil
                cards = nil
                collectgarbage()
            end
        end
    end
end

function GameState:renderBackground()
    if P1deck ~= nil then
        for k, pair in pairs(P1deck) do
            pair:render()
        end
    end
    if P2deck ~= nil then
        for k, pair in pairs(P2deck) do
            pair:render()
        end
    end

    if timer >  6.4 then
        if P1deck ~= nil then
            for k, pair in pairs(P1deck) do
                if pair.weapon ~= nil then
                    pair.weapon:render()
                end
            end
        end
        if P2deck ~= nil then
            for k, pair in pairs(P2deck) do
                if pair.weapon ~= nil then
                    pair.weapon:render()
                end
            end
        end
    end

    if P1deck ~= nil then
        for k, pair in pairs(P1deck) do
            if pair.projectile ~= nil then
                pair.projectile:render()
            end
        end
    end
    if P2deck ~= nil then
        for k, pair in pairs(P2deck) do
            if pair.projectile ~= nil then
                pair.projectile:render()
            end
        end
    end
end

function GameState:renderForeground()
    if winner then 
        love.graphics.print({{r,g,b},'Winner: ' .. winner},35,110)
    end
end

function GameState:exit()
    P1deck = nil
    P2deck = nil
    deck = nil
    winner = nil
    P1deckCards = {}
    P2deckCards = nil
    Nextcards = nil
    evolution= nil
    evolutionMax = nil
    timer = nil
    moveAimTimer = nil
    attackTimer = nil
    P1length = nil
    P2length = nil
    rowsRemaining = nil
    P1rowsRemaining = nil
    P2rowsRemaining = nil
    rows = nil
    P1rows = nil
    P2rows = nil
    Projectiles = nil
    Weapons = nil
    cards = nil
    P1angle = nil
    P2angle = nil
    exitState()
end