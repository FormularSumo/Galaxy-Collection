function maxed_dark_side() --Example level to make an interesting fight vs pre-built deck
    P2_deck_cards[0] = {'Maul',60,4}
    P2_deck_cards[1] = {'GeneralGrievous',60,4}
    P2_deck_cards[2] = {'DarthVader',60,4}
    P2_deck_cards[3] = {'CountDooku',60,4}
    P2_deck_cards[4] = {'GrandInquisitor',60,4}
    P2_deck_cards[5] = {'SavageOpress',60,4}
    P2_deck_cards[6] = {'TrillaSuduri',60,4}
    P2_deck_cards[7] = {'PongKrell',60,4}
    P2_deck_cards[8] = {'DarthSidious',60,4}
    P2_deck_cards[9] = {'SupremeLeaderSnoke',60,4}
    P2_deck_cards[10] = {'KyloRen',60,4}
    P2_deck_cards[11] = {'AsajjVentress',60,4}
    P2_deck_cards[12] = {'Kuruk',60,4}
    P2_deck_cards[13] = {'BobaFettROTJ',60,4}
    P2_deck_cards[14] = {'DarthSidiousReborn',60,4}
    P2_deck_cards[15] = {'JangoFett',60,4}
    P2_deck_cards[16] = {'PreVizsla',60,4}
    P2_deck_cards[17] = {'Cardo',60,4}


    gStateMachine:change('GameState',{'Sand Dunes.ogv', 'video', 2, 0, 0, 0, 'Binary Sunset.oga'})
end

function throne_room()
    P2_deck_cards[1] = {'RoyalGuard',60,4}
    P2_deck_cards[2] = {'DarthSidious',60,4}
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
    P2_deck_cards[4] = {'ArcTrooper',60,4}
    P2_deck_cards[5] = {'CloneCommando',60,4}
    P2_deck_cards[6] = {'ArcTrooperEcho',60,4}
    P2_deck_cards[7] = {'ArcTrooperFives',60,4}
    P2_deck_cards[8] = {'ArcTrooperJesse',60,4}
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
    P2_deck_cards[0] = {'HermitLuke',60,4}
    P2_deck_cards[1] = {'DarthVader',60,4}
    P2_deck_cards[2] = {'ZilloBeast',60,4}
    P2_deck_cards[3] = {'MaceWindu',60,4}
    P2_deck_cards[4] = {'Yoda',60,4}
    P2_deck_cards[5] = {'AnakinSkywalkerROTS',60,4}
    P2_deck_cards[6] = {'LukeSkywalkerROTJ',60,4}
    P2_deck_cards[7] = {'SupremeLeaderSnoke',60,4}
    P2_deck_cards[8] = {'DarthSidious',60,4}
    P2_deck_cards[9] = {'HermitYoda',60,4}
    P2_deck_cards[10] = {'AhsokaTanoFulcrum',60,4}
    P2_deck_cards[11] = {'CountDooku',60,4}
    P2_deck_cards[12] = {'NightsisterMerrin',60,4}
    P2_deck_cards[13] = {'BobaFettMandalorian',60,4}
    P2_deck_cards[14] = {'DarthSidiousReborn',60,4}
    P2_deck_cards[15] = {'Bendu',60,4}
    P2_deck_cards[16] = {'JangoFett',60,4}
    P2_deck_cards[17] = {'TheMandalorian',60,4}

    gStateMachine:change('GameState',{'Death Star Control Room.jpg', 'photo', 0, 1, 1 ,1, 'Throne Room.oga'})
end