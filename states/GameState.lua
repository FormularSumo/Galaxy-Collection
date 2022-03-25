GameState = Class{__includes = BaseState}

function GameState:init()
    Evolution = love.graphics.newImage('Graphics/Evolution.png')
    EvolutionMax = love.graphics.newImage('Graphics/Evolution Max.png')

    P1_deck_cards = bitser.loadLoveFile('Player 1 deck.txt')
    P1_deck = {}
    P2_deck = {}
    Projectiles = {}
    Weapons = {}
    Cards = {}
    gamespeed = 1
    NextCards = {
        [0] = 18,
        [1] = 19,
        [2] = 20,
        [3] = 21,
        [4] = 22,
        [5] = 23,
    }

    P1length = 0
    for k, pair in pairs(P1_deck_cards) do
        if k > P1length then
            P1length = k
        end
    end
    P2length = P2_deck_cards('max')

    for i=0,math.min(18,math.max(P1length,P2length)) do
        if P1_deck_cards[i] then
            P1_deck[i] = Card(P1_deck_cards[i],1,i,-1 - math.floor((i)/6))
        end
        if P2_deck_cards(i) then
            P2_deck[i] = Card(P2_deck_cards(i),2,i,12 + math.floor((i)/6))
        end
    end
end

function GameState:enter(Background)
    background['Type'] = Background[2]
    background['Seek'] = Background[3]
    if background['Type'] == 'video' then
        background['Background'] = love.graphics.newVideo('Backgrounds/' .. Background[1] .. '.ogv')
    else
        background['Background'] = love.graphics.newImage('Backgrounds/' .. Background[1] .. '.jpg')
    end

    songs[0] = love.audio.newSource('Music/' .. Background[7],'stream')
    songs[0]:play()
    calculateQueueLength()

    if Background[4] == nil then r = 0 else r = Background[4] end
    if Background[5] == nil then g = 0 else g = Background[5] end
    if Background[6] == nil then b = 0 else b = Background[6] end
    gui[1] = Button(switchState,{'HomeState'},'Main Menu',font80,nil,35,20,r,g,b)
    gui[2] = Button(pause,nil,'Pause',font100,nil,1591,0,r,g,b) -- 35 pixels from right as font100:getWidth('Pause') = 294
    gui[3] = Slider(1591,130,300,16,gamespeedSlider,0.3,0.3,0.3,r,g,b,0.25,0.25)

    if background['Seek'] > 1 then --All levels have at least a 1 second delay before spawing characters
        timer = 0 - (background['Seek'] - 1)
    else
        timer = 0
    end
    move_aim_timer = timer
    attack_timer = timer - 0.9
    love.timer.step()
end

function Move()
    RowsRemaining(P1_deck)
    RowsRemaining(P2_deck)
    if P1rowsRemaining == 1 and P2rowsRemaining == 1 then
        if P1rows[3] then
            MoveUp(P1_deck,3)
            return
        end
        if P2rows[3] then
            MoveUp(P2_deck,3)
            return
        end
    end
   
    rows = P1rows
    enemyRows = P2rows
    rowsRemaining = P2rowsRemaining
    Move2(P1_deck)
    rows = P2rows
    enemyRows = P1rows
    rowsRemaining = P1rowsRemaining
    Move2(P2_deck)
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
    if deck == P1_deck then
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
                deck[k].targety = deck[k].targety + 180
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
                deck[k].targety = deck[k].targety - 180
                deck[k].row = row - 1
                deck[k-1] = deck[k]
                deck[k] = nil
            end
        end
    end
end

function checkHealth()
    for k, pair in pairs(P1_deck) do
        if pair.health <= 0 then
            P1_deck[k] = nil
        end
    end
    for k, pair in pairs(P2_deck) do
        if pair.health <= 0 then
            P2_deck[k] = nil
        end
    end
end


function GameState:back()
    gStateMachine:change('HomeState')
end

function GameState:update(dt)
    if love.keyboard.wasPressed('space') == true then
        pause()
    end

    if love.keyboard.wasPressed('right') and mouseTouching == gui[1] then
        repositionMouse(2)
    elseif love.keyboard.wasPressed('left') and mouseTouching == gui[2] then
        repositionMouse(1)
    end

    if paused == false and not winner then
        dt = dt * gamespeed
        timer = timer + dt
        if timer >= 7.4 then timer = timer - 1 end
        move_aim_timer = move_aim_timer + dt
        attack_timer = attack_timer + dt

        for k, pair in pairs(P1_deck) do
            pair:update(dt)
        end
        for k, pair in pairs(P2_deck) do
            pair:update(dt)
        end

        if move_aim_timer >= 1 then
            move_aim_timer = move_aim_timer - 1

            if timer < 7 then
                for k, pair in pairs(P1_deck) do
                    pair:move()
                end

                for k, pair in pairs(P2_deck) do
                    pair:move()
                end
                
                if timer > 3 and P2length > timer * 6 then
                    for i=0,5 do
                        if P2_deck_cards(NextCards[i]) then
                            P2_deck[NextCards[i]] = Card(P2_deck_cards(NextCards[i]),2,NextCards[i],12)
                            NextCards[i] = NextCards[i] + 6
                        end
                    end
                end

            else
                if P2length > timer * 6 then
                    for i=0,5 do
                        if not P2_deck[36+i] and P2_deck_cards(NextCards[i]) then
                            P2_deck[36+i] = Card(P2_deck_cards(NextCards[i]),2,36+i,12)
                            NextCards[i] = NextCards[i] + 6
                        end
                    end
                end
                for k, pair in pairs(P1_deck) do
                    pair:move2()
                end 
                for k, pair in pairs(P2_deck) do
                    pair:move2()
                end
            end

            if timer > 3 then
                Move()
            end

            for k, pair in pairs(P1_deck) do
                pair:aim()
            end
            for k, pair in pairs(P2_deck) do
                pair:aim()
            end
        end

        if attack_timer >= 1 then
            attack_timer = attack_timer - 1

            for k, pair in pairs(P1_deck) do
                pair.dodge = 0
                pair.attacks_taken = 0
            end
            for k, pair in pairs(P2_deck) do
                pair.dodge = 0
                pair.attacks_taken = 0
            end

            for k, pair in pairs(P1_deck) do
                pair:attack()
            end
            for k, pair in pairs(P2_deck) do
                pair:attack()
            end

            checkHealth()
            
            if not next(P1_deck) then
                P1_deck = nil
            end
            if not next(P2_deck) then
                P2_deck = nil
            end
            if P1_deck == nil or P2_deck == nil then
                if P1_deck == nil and P2_deck == nil then 
                    winner = 'Draw'
                elseif P1_deck == nil then
                    winner = 'P2'
                elseif P2_deck == nil then
                    winner = 'P1'
                end
                Projectiles = nil
                Weapons = nil
                Cards = nil
                collectgarbage()
            end
        end
    end
end

function GameState:render()
    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            pair:render()
        end
    end
    if P2_deck ~= nil then
        for k, pair in pairs(P2_deck) do
            pair:render()
        end
    end

    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            if pair.weapon ~= nil then
                pair.weapon:render()
            end
        end
    end
    if P2_deck ~= nil then
        for k, pair in pairs(P2_deck) do
            if pair.weapon ~= nil then
                pair.weapon:render()
            end
        end
    end

    if P1_deck ~= nil then
        for k, pair in pairs(P1_deck) do
            if pair.projectile ~= nil then
                pair.projectile:render()
            end
        end
    end
    if P2_deck ~= nil then
        for k, pair in pairs(P2_deck) do
            if pair.projectile ~= nil then
                pair.projectile:render()
            end
        end
    end

    if winner then 
        love.graphics.print({{r,g,b},'Winner: ' .. winner},35,110)
    end
end

function GameState:exit()
    P1_deck = nil
    P2_deck = nil
    deck = nil
    winner = nil
    P1_deck_cards = {}
    P2_deck_cards = nil
    NextCards = nil
    Evolution = nil
    EvolutionMax = nil
    timer = nil
    move_aim_timer = nil
    attack_timer = nil
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
    Cards = nil
    exitState()
end