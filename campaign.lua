function maxed_dark_side() --Example level to make an interesting fight vs pre-built deck
    P2_deck_cards[0] = {'KyloRen',60,4}
    P2_deck_cards[1] = {'SupremeLeaderSnoke',60,4}
    P2_deck_cards[2] = {'EmperorPalpatine',60,4}
    P2_deck_cards[3] = {'DarthVader',60,4}
    P2_deck_cards[4] = {'CountDooku',60,4}
    P2_deck_cards[5] = {'NinthSister',60,4}
    P2_deck_cards[6] = {'GeneralGrievous',60,4}
    P2_deck_cards[7] = {'Maul',60,4}
    P2_deck_cards[8] = {'PongKrell',60,4}
    P2_deck_cards[9] = {'SavageOpress',60,4}
    P2_deck_cards[10] = {'AsajjVentress',60,4}
    P2_deck_cards[11] = {'EighthBrother',60,4}
    P2_deck_cards[12] = {'PreVizsla',60,4}
    P2_deck_cards[13] = {'TrillaSuduri',60,4}
    P2_deck_cards[14] = {'DarthSidiousReborn',60,4}
    P2_deck_cards[15] = {'FifthBrother',60,4}
    P2_deck_cards[16] = {'GrandInquisitor',60,4}
    P2_deck_cards[17] = {'SeventhSister',60,4}

    if Settings['videos'] then
        gStateMachine:change('GameState',{'Sand Dunes.ogv', 'video', 2, 0, 0, 0, 'Binary Sunset.oga'})
    else
        gStateMachine:change('GameState',{'Sand Dunes.jpg', 'photo', 0, 0, 0, 0, 'Binary Sunset.oga'})
    end
end

function maxed_light_side() --Example level to make an interesting fight vs pre-built deck
    P2_deck_cards[0] = {'AhsokaTanoFulcrum',60,4}
    P2_deck_cards[1] = {'Yoda',60,4}
    P2_deck_cards[2] = {'HermitLuke',60,4}
    P2_deck_cards[3] = {'MaceWindu',60,4}
    P2_deck_cards[4] = {'JediMasterObiWanKenobi',60,4}
    P2_deck_cards[5] = {'JediKnightLukeSkywalker',60,4}
    P2_deck_cards[6] = {'AaylaSecura',60,4}
    P2_deck_cards[7] = {'AgenKolar',60,4}
    P2_deck_cards[8] = {'JediKnightAnakinSkywalker',60,4}
    P2_deck_cards[9] = {'AhsokaTanoS7',60,4}
    P2_deck_cards[10] = {'SaeseeTiin',60,4}
    P2_deck_cards[11] = {'QuinlanVos',60,4}
    P2_deck_cards[12] = {'TheMandalorian',60,4}
    P2_deck_cards[13] = {'BobaFettMandalorian',60,4}
    P2_deck_cards[14] = {'Bendu',60,4}
    P2_deck_cards[15] = {'HermitYoda',60,4}
    P2_deck_cards[16] = {'NightsisterMerrin',60,4}
    P2_deck_cards[17] = {'BoKatan',60,4}
    
    gStateMachine:change('GameState',{'Voss.jpg', 'photo', 0, 1, 1, 1, 'The Mandalorian.oga'})
end

function throne_room()
    P2_deck_cards[1] = {'RoyalGuard',60,4}
    P2_deck_cards[2] = {'EmperorPalpatine',60,4}
    P2_deck_cards[3] = {'DarthVader',60,4}
    P2_deck_cards[4] = {'RoyalGuard',60,4}
   
    gStateMachine:change('GameState',{'Death Star Control Room.jpg', 'photo', 0, 1, 1 ,1, 'Imperial March piano only.oga'})
end

function endor()
    P2_deck_cards[0] = {'Tokkat',60,4}
    P2_deck_cards[1] = {'Paploo',60,4}
    P2_deck_cards[2] = {'WicketWWarrick',60,4}
    P2_deck_cards[3] = {'Teebo',60,4}
    P2_deck_cards[4] = {'ChiefChirpa',60,4}
    P2_deck_cards[5] = {'Logray',60,4}

    gStateMachine:change('GameState',{'Endor.jpg', 'photo', 0, 1, 1 ,1, 'Imperial March duet.mp3'})
end

function kamino()
    P2_deck_cards[0] = {'CaptainVaughn',60,4}
    P2_deck_cards[1] = {'CommanderGree',60,4}
    P2_deck_cards[2] = {'CommanderBacara',60,4}
    P2_deck_cards[3] = {'CommanderBly',60,4}
    P2_deck_cards[4] = {'ARCTrooper',60,4}
    P2_deck_cards[5] = {'CloneCommando',60,4}
    P2_deck_cards[6] = {'ARCTrooperEcho',60,4}
    P2_deck_cards[7] = {'ARCTrooperFives',60,4}
    P2_deck_cards[8] = {'ARCTrooperJesse',60,4}
    P2_deck_cards[9] = {'CommanderCody',60,4}
    P2_deck_cards[10] = {'CaptainRex',60,4}
    P2_deck_cards[11] = {'CloneTrooper322nd',60,4}
    P2_deck_cards[12] = {'CloneTrooper327th',60,4}
    P2_deck_cards[13] = {'CloneTrooper501st',60,4}
    P2_deck_cards[14] = {'CloneTrooper212th',60,4}
    P2_deck_cards[15] = {'CommanderWolffe',60,4}
    P2_deck_cards[16] = {'CoruscantGuardCloneTrooper',60,4}
    P2_deck_cards[17] = {'CloneCommandoGregor',60,4}

    gStateMachine:change('GameState',{'Kamino.jpg', 'photo', 0, 1, 1 ,1, 'Clone Wars Theme.oga'})
end

function maxed()
    P2_deck_cards[0] = {'MaceWindu',60,4}
    P2_deck_cards[1] = {'EmperorPalpatine',60,4}
    P2_deck_cards[2] = {'ZilloBeast',60,4}
    P2_deck_cards[3] = {'HermitLuke',60,4}
    P2_deck_cards[4] = {'DarthVader',60,4}
    P2_deck_cards[5] = {'Yoda',60,4}
    P2_deck_cards[6] = {'AhsokaTanoFulcrum',60,4}
    P2_deck_cards[7] = {'JediKnightAnakinSkywalker',60,4}
    P2_deck_cards[8] = {'SupremeLeaderSnoke',60,4}
    P2_deck_cards[9] = {'CountDooku',60,4}
    P2_deck_cards[10] = {'PongKrell',60,4}
    P2_deck_cards[11] = {'JediKnightLukeSkywalker',60,4}
    P2_deck_cards[12] = {'GrandInquisitor',60,4}
    P2_deck_cards[13] = {'HermitYoda',60,4}
    P2_deck_cards[14] = {'DarthSidiousReborn',60,4}
    P2_deck_cards[15] = {'Bendu',60,4}
    P2_deck_cards[16] = {'NinthSister',60,4}
    P2_deck_cards[17] = {'TrillaSuduri',60,4}

    gStateMachine:change('GameState',{'Belsavis.jpg', 'photo', 0, 0, 0 ,0, 'Throne Room.oga'})
end