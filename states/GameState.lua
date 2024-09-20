GameState = Class{__includes = BaseState}

function GameState:enter(infoTable)
    if type(infoTable[3]) == 'string' then --If player 2 is using a table rather than function (ie it's a saved deck rather than s saved level), create a wrapper function around it
        self.P2length = 0 --Easier to work out here than later as we have access to the original table as well as wrapper function

        if infoTable[3] == Settings['active_table'] then
            self.P2battleCards = function(index) return infoTable[3][index] end
            for k, v in pairs(infoTable[3]) do
                if k > self.P2length then
                    self.P2length = k
                end
            end
        else
            local deckTable = bitser.loadLoveFile(infoTable[3])
            self.P2battleCards = function(index) return deckTable[index] end
            for k, v in pairs(deckTable) do
                if k > self.P2length then
                    self.P2length = k
                end
            end
        end
    else
        self.P2battleCards = infoTable[3]
        self.P2length = self.P2battleCards('max')
    end

    if infoTable[4] then --Campaign doesn't pass player 1 deck as the active deck will always be used, but sandbox does as it can be any deck or level
        if type(infoTable[4]) == 'string' then
            self.P1length = 0

            if infoTable[4] == Settings['active_table'] then
                self.P1battleCards = function(index) return infoTable[4][index] end
                for k, v in pairs(infoTable[4]) do
                    if k > self.P1length then
                        self.P1length = k
                    end
                end
            else
                local deckTable = bitser.loadLoveFile(infoTable[4])
                self.P1battleCards = function(index) return deckTable[index] end
                for k, v in pairs(deckTable) do
                    if k > self.P1length then
                        self.P1length = k
                    end
                end
            end
        else
            self.P1battleCards = infoTable[4]
            self.P1length = self.P1battleCards('max')
        end
    else
        self.P1length = 0
        self.P1battleCards = function(index) return P1deckCards[index] end
        for k, pair in pairs(P1deckCards) do
            if k > self.P1length then
                self.P1length = k
            end
        end
    end

    P1deck = {}
    P2deck = {}
    self.graphics = {}
    self.graphicsShields = {}
    self.imagesInfo = {}
    self.imagesIndexes = {}
    self.imagesData = {}
    self.gamespeed = 1
    self.P1Nextcards = {
        [0] = 18,
        [1] = 19,
        [2] = 20,
        [3] = 21,
        [4] = 22,
        [5] = 23,
    }
    self.P2Nextcards = {
        [0] = 18,
        [1] = 19,
        [2] = 20,
        [3] = 21,
        [4] = 22,
        [5] = 23,
    }
    self.P1currentRows = {
        [0] = 0,
        [1] = 1,
        [2] = 2,
        [3] = 3,
        [4] = 4,
        [5] = 5,
    }
    self.P2currentRows = {
        [0] = 0,
        [1] = 1,
        [2] = 2,
        [3] = 3,
        [4] = 4,
        [5] = 5,
    }
    self.P1initialRows = {
        [0] = 0,
        [1] = 1,
        [2] = 2,
        [3] = 3,
        [4] = 4,
        [5] = 5,
    }
    self.P2initialRows = {
        [0] = 0,
        [1] = 1,
        [2] = 2,
        [3] = 3,
        [4] = 4,
        [5] = 5,
    }
    self.P1rowsMoved = {
        [0] = false,
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false,
    }
    self.P2rowsMoved = {
        [0] = false,
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false,
    }

    self.evolutionSpriteBatch = love.graphics.newSpriteBatch(evolutionImage,612) --Presumably having a smaller limit has some benefit, so set it to to highest it can be. Love2d can automatically exapnd it if needed.
    self.evolutionMaxSpriteBatch = love.graphics.newSpriteBatch(evolutionMaxImage,204)

    for i=0,math.min(18,math.max(self.P1length,self.P2length)) do
        if self.P1battleCards(i) then
            P1deck[i] = Card(self.P1battleCards(i),1,i,-1 - math.floor((i)/6),self.graphics,self.imagesInfo,self.imagesIndexes,self.evolutionSpriteBatch,self.evolutionMaxSpriteBatch)
        end
        if self.P2battleCards(i) then
            P2deck[i] = Card(self.P2battleCards(i),2,i,12 + math.floor((i)/6),self.graphics,self.imagesInfo,self.imagesIndexes,self.evolutionSpriteBatch,self.evolutionMaxSpriteBatch)
        end
    end
    for k, pair in pairs(self.imagesInfo) do
        love.thread.getChannel("imageDecoderQueue"):push(k) --It's unnecessary to check here if images have already been pushed, as this is the first time they any are pushed
        pair[2] = true --Mark image as pushed
    end
    for i = 1,#imageDecoderThreads do
        imageDecoderThreads[i]:start()
    end
    self.P1angle = math.rad(210)
    self.P2angle = math.rad(150)
    self.next = next


    backgroundCanvas = love.graphics.newCanvas(1920,1080) --Somehow making this "self" causes Moonshine to not work at all
    background['Name'] = infoTable[1]
    background['Filename'],background['Video'],background['Seek'], rgb = backgroundInfo(background['Name'])
    createBackground()

    songs[1] = love.audio.newSource('Music/' .. infoTable[2],'stream')

    gui[1] = Button(pause,'Pause',font100,nil,1591,0,rgb) -- 35 pixels from right as font100:getWidth('Pause') = 294
    gui[2] = Slider(1591,130,300,16,function(percentage) self.gamespeed = percentage * 4 end,{0.3,0.3,0.3},rgb,0.25,0.25)
    gui['SpeedLabel'] = Text('Speed',font80,'centre',410,rgb,false)
    gui[3] = Slider('centre',570,300,16,function(percentage) love.audio.setVolume(percentage) Settings['volume_level'] = percentage end,{0.3,0.3,0.3},rgb,Settings['volume_level'],0.5,function() bitser.dumpLoveFile('Settings.txt',Settings) end,false,false)
    gui['VolumeLabel'] = Text('Volume',font80,'centre',600,rgb,false)
    gui[4] = Button(function() gStateMachine:change('HomeState') end,'Main Menu',font80,nil,'centre',1080-220-font80:getHeight('Main Menu'),rgb,nil,false)

    if not background['Video'] then --backgroundInfo works this out via Setting and background
        self.timer = 0 --Equals to 1 second delay before characters appear
    else
        self.timer = -(background['Seek'] - 1), 0 --If background has a starting animation (such as fade in), delay character spawning until it's finished
    end
    self.moveAimTimer = self.timer
    self.attackTimer = self.timer - 0.9
    love.timer.step()
end

function GameState:Move() --Handles moving rows up and down
    self:RowsRemaining(P1deck)
    self:RowsRemaining(P2deck)

    if not self:Move1() then --Special movement cases
        self:Move2(P1deck,self.P1rows) --General-purpose movement
        self:Move2(P2deck,self.P2rows)
        self.P1rowsMoved = {
            [0] = false,
            [1] = false,
            [2] = false,
            [3] = false,
            [4] = false,
            [5] = false,
        }
        self.P2rowsMoved = {
            [0] = false,
            [1] = false,
            [2] = false,
            [3] = false,
            [4] = false,
            [5] = false,
        }
    end
end

function GameState:RowsRemaining(deck)
    local rowsRemaining = 0
    local rows = {
        [0] = false,
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false
    }

    for k, pair in pairs(deck) do
        if rows[pair.row] == false then
            rows[pair.row] = true
            rowsRemaining = rowsRemaining + 1
            if rowsRemaining == 6 then break end
        end
    end

    if deck == P1deck then
        self.P1rows = rows
        self.P1rowsRemaining = rowsRemaining
    else
        self.P2rows = rows
        self.P2rowsRemaining = rowsRemaining
    end
end

--This function handles odd block movements, where there's a consolidated 1/3/5 rows on both teams. This is to ensure they always meet/centre with each other, as quickly as possible.
function GameState:Move1()
    if self.P1rowsRemaining == 1 and self.P2rowsRemaining == 1 then
        --If one player's row is in the top two rows, other player's row will move to upper centre to meet faster
        if (self.P1rows[0] or self.P1rows[1]) and self.P2rows[3] then
            if self.P1rows[0] then
                self:MoveDown(P1deck,0)
            else
                self:MoveDown(P1deck,1)
            end
            self:MoveUp(P2deck,3)
            return true
        elseif (self.P2rows[0] or self.P2rows[1]) and self.P1rows[3] then
            if self.P1rows[0] then
                self:MoveDown(P2deck,0)
            else
                self:MoveDown(P2deck,1)
            end
            self:MoveUp(P1deck,3)
            return true
        --If one player's row is in the bottom two rows, other player's row will move to lower centre to meet faster
        elseif (self.P1rows[4] or self.P1rows[5]) and self.P2rows[2] then
            if self.P1rows[4] then
                self:MoveUp(P1deck,4)
            else
                self:MoveUp(P1deck,5)
            end
            self:MoveDown(P2deck,2)
            return true
        elseif (self.P2rows[4] or self.P2rows[5]) and self.P1rows[2] then
            if self.P1rows[4] then
                self:MoveUp(P2deck,4)
            else
                self:MoveUp(P2deck,5)
            end
            self:MoveDown(P1deck,2)
            return true
        --Make sure rows line up if in middle two rows
        elseif self.P1rows[2] and self.P2rows[3] then
            self:MoveUp(P2deck,3)
            return true
        elseif self.P2rows[2] and self.P1rows[3] then
            self:MoveUp(P1deck,3)
            return true
        end
    elseif self.P1rowsRemaining == 3 and self.P2rowsRemaining == 3 then
        -- If one player's rows are in the top three rows, other player's rows will move to upper centre to meet faster
        if (self.P1rows[3] and self.P1rows[4] and self.P1rows[5]) and (self.P2rows[1] and self.P2rows[2] and self.P2rows[3]) then
            self:MoveUp(P1deck,3)
            self:MoveUp(P1deck,4)
            self:MoveUp(P1deck,5)
            self:MoveDown(P2deck,3)
            self:MoveDown(P2deck,2)
            self:MoveDown(P2deck,1)
            return true
        elseif (self.P2rows[3] and self.P2rows[4] and self.P2rows[5]) and (self.P1rows[1] and self.P1rows[2] and self.P1rows[3]) then
            self:MoveUp(P2deck,3)
            self:MoveUp(P2deck,4)
            self:MoveUp(P2deck,5)
            self:MoveDown(P1deck,3)
            self:MoveDown(P1deck,2)
            self:MoveDown(P1deck,1)
            return true
        --If one player's rows are in the bottom three rows, other player's rows will down to lower centre to meet faster
        elseif (self.P1rows[0] and self.P1rows[1] and self.P1rows[2]) and (self.P2rows[2] and self.P2rows[3] and self.P2rows[4]) then
            self:MoveDown(P1deck,2)
            self:MoveDown(P1deck,1)
            self:MoveDown(P1deck,0)
            self:MoveUp(P2deck,2)
            self:MoveUp(P2deck,3)
            self:MoveUp(P2deck,4)
            return true
        elseif (self.P2rows[0] and self.P2rows[1] and self.P2rows[2]) and (self.P1rows[2] and self.P1rows[3] and self.P1rows[4]) then
            self:MoveDown(P2deck,2)
            self:MoveDown(P2deck,1)
            self:MoveDown(P2deck,0)
            self:MoveUp(P1deck,2)
            self:MoveUp(P1deck,3)
            self:MoveUp(P1deck,4)
            return true
        --Make sure rows line up if in middle 4 rows
        elseif (self.P1rows[1] and self.P1rows[2] and self.P1rows[3]) and (self.P2rows[2] and self.P2rows[3] and self.P2rows[4]) then
            self:MoveUp(P2deck,2)
            self:MoveUp(P2deck,3)
            self:MoveUp(P2deck,4)
            return true
        elseif (self.P2rows[1] and self.P2rows[2] and self.P2rows[3]) and (self.P1rows[2] and self.P1rows[3] and self.P1rows[4]) then
            self:MoveUp(P1deck,2)
            self:MoveUp(P1deck,3)
            self:MoveUp(P1deck,4)
            return true
        end
    elseif self.P1rowsRemaining == 5 and self.P2rowsRemaining == 5 then
        --Make sure rows line up if in middle 6 rows
        if (self.P1rows[0] and self.P1rows[1] and self.P1rows[2] and self.P1rows[3] and self.P1rows[4]) and (self.P2rows[1] and self.P2rows[2] and self.P2rows[3] and self.P2rows[4] and self.P2rows[5]) then
            self:MoveUp(P2deck,1)
            self:MoveUp(P2deck,2)
            self:MoveUp(P2deck,3)
            self:MoveUp(P2deck,4)
            self:MoveUp(P2deck,5)
            return true
        end
        if (self.P2rows[0] and self.P2rows[1] and self.P2rows[2] and self.P2rows[3] and self.P2rows[4]) and (self.P1rows[1] and self.P1rows[2] and self.P1rows[3] and self.P1rows[4] and self.P1rows[5]) then
            self:MoveUp(P1deck,1)
            self:MoveUp(P1deck,2)
            self:MoveUp(P1deck,3)
            self:MoveUp(P1deck,4)
            self:MoveUp(P1deck,5)
            return true
        end
    elseif self.P1rowsRemaining == 1 and self.P2rowsRemaining == 3 then
        --Make sure rows centre if there's a 1 against 3 situation
        if (self.P2rows[2] and self.P2rows[3] and self.P2rows[4]) then
            if self.P1rows[0] or self.P1rows[1] or self.P1rows[2] then
                self:MoveUp(P2deck,2)
                self:MoveUp(P2deck,3)
                self:MoveUp(P2deck,4)
                if self.P1rows[0] then
                    self:MoveDown(P1deck,0)
                elseif self.P1rows[1] then
                    self:MoveDown(P1deck,1)
                end
                return true
            end
        elseif (self.P2rows[1] and self.P2rows[2] and self.P2rows[3]) then
            if self.P1rows[4] or self.P1rows[5] then
                self:MoveDown(P2deck,3)
                self:MoveDown(P2deck,2)
                self:MoveDown(P2deck,1)
                if self.P1rows[4] then
                    self:MoveUp(P1deck,4)
                else
                    self:MoveUp(P1deck,5)
                end
                return true
            elseif self.P1rows[3] then
                self:MoveUp(P1deck,3)
                return true
            end
        end
    elseif self.P1rowsRemaining == 3 and self.P2rowsRemaining == 1 then
        --Make sure rows centre if there's a 1 against 3 situation
        if (self.P1rows[2] and self.P1rows[3] and self.P1rows[4]) then
            if self.P2rows[0] or self.P2rows[1] or self.P2rows[2] then
                self:MoveUp(P1deck,2)
                self:MoveUp(P1deck,3)
                self:MoveUp(P1deck,4)
                if self.P2rows[0] then
                    self:MoveDown(P2deck,0)
                elseif self.P2rows[1] then
                    self:MoveDown(P2deck,1)
                end
                return true
            end
        elseif (self.P1rows[1] and self.P1rows[2] and self.P1rows[3]) then
            if self.P2rows[4] or self.P2rows[5] then
                self:MoveDown(P1deck,3)
                self:MoveDown(P1deck,2)
                self:MoveDown(P1deck,1)
                if self.P2rows[4] then
                    self:MoveUp(P2deck,4)
                else
                    self:MoveUp(P2deck,5)
                end
                return true
            elseif self.P2rows[3] then
                self:MoveUp(P2deck,3)
                return true
            end
        end
    elseif self.P1rowsRemaining == 3 and self.P2rowsRemaining == 5 then
        --Make sure rows centre if there's a 3 against 5 situation
        if (self.P2rows[1] and self.P2rows[2] and self.P2rows[3] and self.P2rows[4] and self.P2rows[5]) then
            if (self.P1rows[0] or self.P1rows[3]) and self.P1rows[1] and self.P1rows[2] then
                self:MoveUp(P2deck,1)
                self:MoveUp(P2deck,2)
                self:MoveUp(P2deck,3)
                self:MoveUp(P2deck,4)
                self:MoveUp(P2deck,5)
                if self.P1rows[0] then
                    self:MoveDown(P1deck,2)
                    self:MoveDown(P1deck,1)
                    self:MoveDown(P1deck,0)
                end
                return true
            end
        elseif (self.P2rows[0] and self.P2rows[1] and self.P2rows[2] and self.P2rows[3] and self.P2rows[4]) then
            if (self.P1rows[2] or self.P1rows[5]) and self.P1rows[3] and self.P1rows[4] then
                if self.P1rows[5] then
                    self:MoveDown(P2deck,4)
                    self:MoveDown(P2deck,3)
                    self:MoveDown(P2deck,2)
                    self:MoveDown(P2deck,1)
                    self:MoveDown(P2deck,0)
                    self:MoveUp(P1deck,3)
                    self:MoveUp(P1deck,4)
                    self:MoveUp(P1deck,5)
                else
                    self:MoveUp(P1deck,2)
                    self:MoveUp(P1deck,3)
                    self:MoveUp(P1deck,4)
                end
                return true
            end
        end
    elseif self.P1rowsRemaining == 5 and self.P2rowsRemaining == 3 then
        --Make sure rows centre if there's a 3 against 5 situation
        if (self.P1rows[1] and self.P1rows[2] and self.P1rows[3] and self.P1rows[4] and self.P1rows[5]) then
            if (self.P2rows[0] or self.P2rows[3]) and self.P2rows[1] and self.P2rows[2] then
                self:MoveUp(P1deck,1)
                self:MoveUp(P1deck,2)
                self:MoveUp(P1deck,3)
                self:MoveUp(P1deck,4)
                self:MoveUp(P1deck,5)
                if self.P2rows[0] then
                    self:MoveDown(P2deck,2)
                    self:MoveDown(P2deck,1)
                    self:MoveDown(P2deck,0)
                end
                return true
            end
        elseif (self.P1rows[0] and self.P1rows[1] and self.P1rows[2] and self.P1rows[3] and self.P1rows[4]) then
            if (self.P2rows[2] or self.P2rows[5]) and self.P2rows[3] and self.P2rows[4] then
                if self.P2rows[5] then
                    self:MoveDown(P1deck,4)
                    self:MoveDown(P1deck,3)
                    self:MoveDown(P1deck,2)
                    self:MoveDown(P1deck,1)
                    self:MoveDown(P1deck,0)
                    self:MoveUp(P2deck,3)
                    self:MoveUp(P2deck,4)
                    self:MoveUp(P2deck,5)
                else
                    self:MoveUp(P2deck,2)
                    self:MoveUp(P2deck,3)
                    self:MoveUp(P2deck,4)
                end
                return true
            end
        end
    end
end

function GameState:Move2(deck,rows)
    if rows[0] == false and rows[1] == false and rows[5] == true then
        self:MoveUp(deck,2)
        self:MoveUp(deck,3)
        self:MoveUp(deck,4)
        self:MoveUp(deck,5)
    elseif rows[4] == false and rows[5] == false and rows[0] == true then
        self:MoveDown(deck,3)
        self:MoveDown(deck,2)
        self:MoveDown(deck,1)
        self:MoveDown(deck,0)
    else
        if rows[2] == false then
            if (rows[0] == false and rows[5] == true) or (rows[1] == false and rows[4] == true) then
                self:MoveUp(deck,3)
                self:MoveUp(deck,4)
                self:MoveUp(deck,5)
            else
                self:MoveDown(deck,1)
                self:MoveDown(deck,0)
            end
        end
        if rows[1] == false then
            self:MoveDown(deck,0)
        end
        if rows[3] == false then
            if (rows[5] == false and rows[0] == true) or (rows[4] == false and rows[1] == true) then
                self:MoveDown(deck,2)
                self:MoveDown(deck,1)
                self:MoveDown(deck,0)
            else
                self:MoveUp(deck,4)
                self:MoveUp(deck,5)
            end
        end
        if rows[4] == false then
            self:MoveUp(deck,5)
        end
    end
end

function GameState:MoveDown(deck,row)
    if deck == P1deck then
        rowsMoved = self.P1rowsMoved
    else
        rowsMoved = self.P2rowsMoved
    end
    if not rowsMoved[row] then
        rowsMoved[row] = true
        if deck == P1deck then
            if not self.P1rows[row] then return end
            self.P1currentRows[self.P1initialRows[row]] = self.P1currentRows[self.P1initialRows[row]] + 1

            self.P1initialRows[row+1] = self.P1initialRows[row]
            self.P1initialRows[row] = nil
        else
            if not self.P2rows[row] then return end
            self.P2currentRows[self.P2initialRows[row]] = self.P2currentRows[self.P2initialRows[row]] + 1

            self.P2initialRows[row+1] = self.P2initialRows[row]
            self.P2initialRows[row] = nil
        end
        local deckIndexes = {} -- This is used to save a copy of the current card indexes (numbers) so they don't get incorrectly overwritten when modifying the table
        for k, pair in pairs(deck) do
            table.insert(deckIndexes,k)
        end
        for k, pair in pairs(deckIndexes) do
            if deck[pair].row == row then
                deck[pair].number = deck[pair].number + 1
                deck[pair].targetY = deck[pair].targetY + 180
                deck[pair].row = row + 1
                deck[pair+1] = deck[pair]
                deck[pair] = nil
            end
        end
    end
end

function GameState:MoveUp(deck,row)
    if deck == P1deck then
        rowsMoved = self.P1rowsMoved
    else
        rowsMoved = self.P2rowsMoved
    end
    if not rowsMoved[row] then
        rowsMoved[row] = true
        if deck == P1deck then
            if not self.P1rows[row] then return end
            self.P1currentRows[self.P1initialRows[row]] = self.P1currentRows[self.P1initialRows[row]] - 1

            self.P1initialRows[row-1] = self.P1initialRows[row]
            self.P1initialRows[row] = nil
        else
            if not self.P2rows[row] then return end
            self.P2currentRows[self.P2initialRows[row]] = self.P2currentRows[self.P2initialRows[row]] - 1

            self.P2initialRows[row-1] = self.P2initialRows[row]
            self.P2initialRows[row] = nil
        end
        local deckIndexes = {} -- This is used to save a copy of the current card indexes (numbers) so they don't get incorrectly overwritten when modifying the table
        for k, pair in pairs(deck) do
            table.insert(deckIndexes,k)
        end
        for k, pair in pairs(deckIndexes) do
            if deck[pair].row == row then
                deck[pair].number = deck[pair].number - 1
                deck[pair].targetY = deck[pair].targetY - 180
                deck[pair].row = row - 1
                deck[pair-1] = deck[pair]
                deck[pair] = nil
            end
        end
    end
end

function GameState:pause()
    if not winner then
        if paused == true then
            gui[1]:updateText('Play','centre',220,font80)
            gui[2]:updatePosition('centre',380)
            if not winner then
                gui[4]:updateText('Main Menu','centre',1080-220-font80:getHeight('Main Menu'))
            end
            gui[2].default = false
            gui[3].default = true
            gui[4].visible = true
            gui['SpeedLabel'].visible = true
            gui[3].visible = true
            gui['VolumeLabel'].visible = true

            love.graphics.origin()
            love.graphics.setCanvas(backgroundCanvas)
            love.graphics.clear()
            love.graphics.draw(background['Background'])
            self:renderBattle()
            blur(function() love.graphics.draw(backgroundCanvas) end)
            love.graphics.setCanvas()
        else
            gui[1]:updateText('Pause',1591,0,font100)
            gui[2]:updatePosition('1591',130,1591,0)
            gui[4]:updateText('Main Menu',35,20)
            gui[2].default = true
            gui[3].default = false
            if not winner then
                gui[4].visible = false
            end
            gui['SpeedLabel'].visible = false
            gui[3].visible = false
            gui['VolumeLabel'].visible = false
        end
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
        dt = dt * self.gamespeed
        self.timer = self.timer + dt
        if self.timer >= 7.4 then self.timer = self.timer - 1 end
        self.moveAimTimer = self.moveAimTimer + dt
        self.attackTimer = self.attackTimer + dt

        for k, pair in pairs(P1deck) do
            pair:update(dt)
        end
        for k, pair in pairs(P2deck) do
            pair:update(dt)
        end

        if self.timer > 6.4 then
            if self.timer < 6.9 then
                if self.P1angle < math.rad(270) then
                    self.P1angle = self.P1angle + dt * 2
                end
                if self.P2angle > math.rad(90) then
                    self.P2angle = self.P2angle - dt * 2
                end
            elseif self.timer < 7.4 then
                if self.P1angle > math.rad(210) then
                    self.P1angle = self.P1angle - dt * 2
                end
                if self.P2angle < math.rad(150) then
                    self.P2angle = self.P2angle + dt * 2
                end
            end
        end

        if self.moveAimTimer >= 1 then
            self.moveAimTimer = self.moveAimTimer - 1
            if love.thread.getChannel("imageDecoderOutput"):peek() then
                for i = 1, love.thread.getChannel("imageDecoderOutput"):getCount() do
                    local result = love.thread.getChannel("imageDecoderOutput"):pop()
                    self.imagesInfo[result[1]][2] = true
                    local width, height
                    width, height = result[2]:getDimensions()
                    if width == 115 and height == 173 then --Ie if Card, not weapon/projectile
                        self.imagesIndexes[result[1]] = #self.imagesData+1
                        table.insert(self.imagesData,result[2])
                        for i=1,#self.imagesInfo[result[1]][1] do
                            self.imagesInfo[result[1]][1][i].image = true
                        end
                    else
                        self.graphics[result[1]] = love.graphics.newSpriteBatch(love.graphics.newImage(result[2]))
                        for i=1,#self.imagesInfo[result[1]][1] do
                            self.imagesInfo[result[1]][1][i]:init2(self.graphics[result[1]])
                        end
                    end

                    self.imagesInfo[result[1]] = nil
                end
                self.imagesArrayLayer = love.graphics.newArrayImage(self.imagesData)
            end

            if self.timer < 7 then --Because moveAimTimer is created after timer, 7 seconds into a battle this will always be false
                for k, pair in pairs(P1deck) do
                    pair:move()
                end
                for k, pair in pairs(P2deck) do
                    pair:move()
                end
                
                if self.timer > 3 and (self.P2length > self.timer * 6 or self.P1length > self.timer * 6) then
                    if self.P1length > self.timer * 6 then
                        for i=0,5 do
                            if self.P1battleCards(self.P1Nextcards[i]) then
                                P1deck[self.P1Nextcards[i]] = Card(self.P1battleCards(self.P1Nextcards[i]),1,self.P1Nextcards[i],-1,self.graphics,self.imagesInfo,self.imagesIndexes,self.evolutionSpriteBatch,self.evolutionSpriteBatch)
                                self.P1Nextcards[i] = self.P1Nextcards[i] + 6
                            end
                        end
                    end
                    if self.P2length > self.timer * 6 then
                        for i=0,5 do
                            if self.P2battleCards(self.P2Nextcards[i]) then
                                P2deck[self.P2Nextcards[i]] = Card(self.P2battleCards(self.P2Nextcards[i]),2,self.P2Nextcards[i],12,self.graphics,self.imagesInfo,self.imagesIndexes,self.evolutionSpriteBatch,self.evolutionSpriteBatch)
                                self.P2Nextcards[i] = self.P2Nextcards[i] + 6
                            end
                        end
                    end
                    for k, pair in pairs(self.imagesInfo) do
                        if pair[2] == false then
                            love.thread.getChannel("imageDecoderQueue"):push(k)
                            pair[2] = true --Mark image as pushed
                        end
                    end
                    for i = 1,#imageDecoderThreads do
                        imageDecoderThreads[i]:start()
                    end
                end

            else
                if self.P2length > 42 or self.P1length > 42 then
                    if self.P1length > 42 then
                        for i=0,5 do
                            if not P1deck[42+self.P1currentRows[i]] and self.P1battleCards(self.P1Nextcards[i]) ~= nil then
                                P1deck[42+self.P1currentRows[i]] = Card(self.P1battleCards(self.P1Nextcards[i]),1,42+self.P1currentRows[i],-2,self.graphics,self.imagesInfo,self.imagesIndexes,self.evolutionSpriteBatch,self.evolutionMaxSpriteBatch)
                                self.P1Nextcards[i] = self.P1Nextcards[i] + 6
                            end
                        end
                    end
                    if self.P2length > 42 then
                        for i=0,5 do
                            if not P2deck[42+self.P2currentRows[i]] and self.P2battleCards(self.P2Nextcards[i]) ~= nil then
                                P2deck[42+self.P2currentRows[i]] = Card(self.P2battleCards(self.P2Nextcards[i]),2,42+self.P2currentRows[i],13,self.graphics,self.imagesInfo,self.imagesIndexes,self.evolutionSpriteBatch,self.evolutionMaxSpriteBatch)
                                self.P2Nextcards[i] = self.P2Nextcards[i] + 6
                            end
                        end
                    end
                    for k, pair in pairs(self.imagesInfo) do
                        if pair[2] == false then
                            love.thread.getChannel("imageDecoderQueue"):push(k)
                            pair[2] = true --Mark image as pushed
                        end
                    end
                    for i = 1,#imageDecoderThreads do
                        imageDecoderThreads[i]:start()
                    end
                end

                local deckIndexes = {} -- This is used to save a copy of the current card indexes (numbers) so they don't get incorrectly overwritten when modifying the table
                for k, pair in pairs(P1deck) do
                    table.insert(deckIndexes,k)
                end
                for k, pair in pairs(deckIndexes) do
                    P1deck[pair]:move2()
                end
                for k, pair in pairs(deckIndexes) do --Empty table
                    deckIndexes[k] = nil
                end 
                for k, pair in pairs(P2deck) do
                    table.insert(deckIndexes,k)
                end
                for k, pair in pairs(deckIndexes) do
                    P2deck[pair]:move2()
                end
            end

            if self.timer > 3 then
                self:Move()
            end

            for k, pair in pairs(P1deck) do
                pair:aim()
            end
            for k, pair in pairs(P2deck) do
                pair:aim()
            end
        end

        if self.attackTimer >= 1 then
            self.attackTimer = self.attackTimer - 1

            for k, pair in pairs(P1deck) do
                pair.dodge = 0
                pair.attacksTaken = 0
            end
            for k, pair in pairs(P2deck) do
                pair.dodge = 0
                pair.attacksTaken = 0
            end

            for k, pair in pairs(P1deck) do
                pair:attack(self.graphics)
            end
            for k, pair in pairs(P2deck) do
                pair:attack(self.graphics)
            end

            for k, pair in pairs(P1deck) do
                if pair.health <= 0 then
                    pair:deleteEvolutionSprites(self.evolutionSpriteBatch,self.evolutionMaxSpriteBatch)
                    pair:deleteGraphics(self.graphics)
                    P1deck[k] = nil
                end
            end
            for k, pair in pairs(P2deck) do
                if pair.health <= 0 then
                    pair:deleteEvolutionSprites(self.evolutionSpriteBatch,self.evolutionMaxSpriteBatch)
                    pair:deleteGraphics(self.graphics)
                    P2deck[k] = nil
                end
            end
            
            if not self.next(P1deck) then
                P1deck = nil
            end
            if not self.next(P2deck) then
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
                self.graphics = nil
                self.imagesInfo = nil
                collectgarbage()
            end
        end
    end
end

function GameState:renderBattle()
    if P1deck ~= nil or P2deck~= nil then
        if P1deck ~= nil then
            for k, pair in pairs(P1deck) do
                pair:render(self.evolutionSpriteBatch,self.evolutionMaxSpriteBatch,self.imagesIndexes,self.imagesArrayLayer)
            end
        end
        if P2deck ~= nil then
            for k, pair in pairs(P2deck) do
                pair:render(self.evolutionSpriteBatch,self.evolutionMaxSpriteBatch,self.imagesIndexes,self.imagesArrayLayer)
            end
        end

        if self.evolutionMaxSpriteBatch:getCount() > 0 then
            love.graphics.draw(self.evolutionMaxSpriteBatch)
        end
        if self.evolutionSpriteBatch:getCount() > 0 then
            love.graphics.draw(self.evolutionSpriteBatch)
        end

        if not winner then 
            if self.timer > 6.4 then
                if P1deck ~= nil then
                    for k, pair in pairs(P1deck) do
                        if pair.weaponManager ~= nil then
                            pair.weaponManager:render(self.graphics,self.P1angle)
                        end
                    end
                end
                if P2deck ~= nil then
                    for k, pair in pairs(P2deck) do
                        if pair.weaponManager ~= nil then
                            pair.weaponManager:render(self.graphics,self.P2angle)
                        end
                    end
                end
            end

            if P1deck ~= nil and P2deck ~= nil then
                for k, pair in pairs(P1deck) do
                    if pair.projectileManager ~= nil then
                        pair.projectileManager:render(self.graphics)
                    end
                end
                for k, pair in pairs(P2deck) do
                    if pair.projectileManager ~= nil then
                        pair.projectileManager:render(self.graphics)
                    end
                end

                if self.graphicsShields ~= {} then --Statistically most battles will not contain shields, so don't both checking for them if so
                    for k, pair in pairs(self.graphics) do
                        if self.graphicsShields[k] then
                            love.graphics.draw(pair)
                        end
                    end
                    for k, pair in pairs(self.graphics) do
                        if not self.graphicsShields[k] then
                            love.graphics.draw(pair)
                        end
                    end
                else
                    for k, pair in pairs(self.graphics) do
                        love.graphics.draw(pair)
                    end
                end
            end
        end

        love.graphics.setColor(0.3,0.3,0.3)
        if P1deck ~= nil then
            for k, pair in pairs(P1deck) do
                pair:renderHealthBar1()
            end
        end
        if P2deck ~= nil then
            for k, pair in pairs(P2deck) do
                pair:renderHealthBar1()
            end
        end

        if P1deck ~= nil then
            for k, pair in pairs(P1deck) do
                pair:renderHealthBar2()
            end
        end
        if P2deck ~= nil then
            for k, pair in pairs(P2deck) do
                pair:renderHealthBar2()
            end
        end
        love.graphics.setColor(1,1,1)
    end
end

function GameState:renderBackground()
    if paused and not winner then
        love.graphics.draw(backgroundCanvas)
        return true
    end
end

function GameState:renderNormal()
    if winner then
        self:renderBattle()
    end
end

function GameState:renderForeground()
    if not winner and not paused then
        self:renderBattle()
    elseif winner then
        love.graphics.print({rgb,'Winner: ' .. winner},35,110)
    end
end

function GameState:exit()
    P1deck = nil
    P2deck = nil
    winner = nil
    backgroundCanvas = nil
end