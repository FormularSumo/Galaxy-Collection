function maxed_dark_side() --Example level to make an interesting fight vs pre-built deck
    P2_deck_cards[0] = 'Maul'
    P2_deck_cards[1] = 'GeneralGrievous'
    P2_deck_cards[2] = 'DarthVader'
    P2_deck_cards[3] = 'CountDooku'
    P2_deck_cards[4] = 'GrandInquisitor'
    P2_deck_cards[5] = 'SavageOpress'
    P2_deck_cards[6] = 'TrillaSuduri'
    P2_deck_cards[7] = 'PongKrell'
    P2_deck_cards[8] = 'DarthSidious'
    P2_deck_cards[9] = 'SupremeLeaderSnoke'
    P2_deck_cards[10] = 'KyloRen'
    P2_deck_cards[11] = 'AsajjVentress'
    P2_deck_cards[12] = 'Cardo'
    P2_deck_cards[13] = 'BobaFettROTJ'
    P2_deck_cards[14] = 'DarthSidiousReborn'
    P2_deck_cards[15] = 'JangoFett'
    P2_deck_cards[16] = 'Kuruk'
    P2_deck_cards[17] = 'PurgeTrooper'

    gStateMachine:change('GameState',{'Sand Dunes.ogv', 'video', 2, 0, 0, 0, 'Binary Sunset.ogg'})
end

function throne_room()
    P2_deck_cards[1] = 'RoyalGuard'
    P2_deck_cards[2] = 'DarthSidious'
    P2_deck_cards[3] = 'DarthVader'
    P2_deck_cards[4] = 'RoyalGuard'
   
    gStateMachine:change('GameState',{'Death Star Control Room.jpg', 'photo', 0, 1, 1 ,1, 'Imperial March piano only.oga'})
end

function endor()
    P2_deck_cards[0] = 'Tokkat'
    P2_deck_cards[1] = 'Paploo'
    P2_deck_cards[2] = 'WicketWWarrick'
    P2_deck_cards[3] = 'Teebo'
    P2_deck_cards[4] = 'ChiefChirpa'
    P2_deck_cards[5] = 'Logray'
    P2_deck_cards[6] = 'DarthNoscoper'
    P2_deck_cards[7] = 'BabyYoda'


    gStateMachine:change('GameState',{'Endor.jpg', 'photo', 0, 1, 1 ,1, 'Throne Room.oga'})
end

function maxed()
    P2_deck_cards[0] = 'CountDooku'
    P2_deck_cards[1] = 'DarthVader'
    P2_deck_cards[2] = 'ZilloBeast'
    P2_deck_cards[3] = 'MaceWindu'
    P2_deck_cards[4] = 'Yoda'
    P2_deck_cards[5] = 'AnakinSkywalkerROTS'
    P2_deck_cards[6] = 'LukeSkywalkerROTJ'
    P2_deck_cards[7] = 'SupremeLeaderSnoke'
    P2_deck_cards[8] = 'DarthSidious'
    P2_deck_cards[9] = 'HermitYoda'
    P2_deck_cards[10] = 'AhsokaTanoFulcrum'
    P2_deck_cards[11] = 'ObiWanKenobi'
    P2_deck_cards[12] = 'NightsisterMerrin'
    P2_deck_cards[13] = 'BobaFettMandalorian'
    P2_deck_cards[14] = 'DarthSidiousReborn'
    P2_deck_cards[15] = 'Bendu'
    P2_deck_cards[16] = 'JangoFett'
    P2_deck_cards[17] = 'TheMandalorian'

    gStateMachine:change('GameState',{'Death Star Control Room.jpg', 'photo', 0, 1, 1 ,1, 'Clone Wars Theme.oga'})
end