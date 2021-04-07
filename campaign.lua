function maxed_dark_side() --Example level to make an interesting fight vs pre-built deck
    P2_deck_cards[0] = 'CountDooku'
    P2_deck_cards[1] = 'DarthVader'
    P2_deck_cards[2] = 'DarthSidiousReborn'
    P2_deck_cards[3] = 'DarthSidious'
    P2_deck_cards[4] = 'SupremeLeaderSnoke'
    P2_deck_cards[5] = 'GeneralGrievous'
    P2_deck_cards[6] = 'GrandInquisitor'
    P2_deck_cards[7] = 'PongKrell'
    P2_deck_cards[8] = 'Maul'
    P2_deck_cards[9] = 'SavageOpress'
    P2_deck_cards[10] = 'KyloRen'
    P2_deck_cards[11] = 'AsajjVentress'
    P2_deck_cards[12] = 'PurgeTrooper'
    P2_deck_cards[13] = 'Kuruk'
    P2_deck_cards[14] = 'JangoFett'
    P2_deck_cards[15] = 'BobaFettROTJ'
    P2_deck_cards[16] = 'Cardo'
    P2_deck_cards[17] = 'CadBane'

    gStateMachine:change('game',{'Sand Dunes.ogv', 'video', 2, 0, 0, 0, 'Binary Sunset.oga'})
end

function throne_room()
    P2_deck_cards[1] = 'RoyalGuard'
    P2_deck_cards[2] = 'DarthSidious'
    P2_deck_cards[3] = 'DarthVader'
    P2_deck_cards[4] = 'RoyalGuard'
   
    gStateMachine:change('game',{'Death Star Control Room.jpg', 'photo', 0, 1, 1 ,1, 'Imperial March piano only.oga'})
end

function endor()
    P2_deck_cards[0] = 'Tokkat'
    P2_deck_cards[1] = 'Paploo'
    P2_deck_cards[2] = 'WicketWWarrick'
    P2_deck_cards[3] = 'Teebo'
    P2_deck_cards[4] = 'ChiefChirpa'
    P2_deck_cards[5] = 'Logray'

    gStateMachine:change('game',{'Endor.jpg', 'photo', 0, 1, 1 ,1, 'Battle music 1.mp3'})
end

function maxed()
    P2_deck_cards[0] = 'DarthVader'
    P2_deck_cards[1] = 'MaceWindu'
    P2_deck_cards[2] = 'DarthSidiousReborn'
    P2_deck_cards[3] = 'ZilloBeast'
    P2_deck_cards[4] = 'DarthSidious'
    P2_deck_cards[5] = 'Yoda'
    P2_deck_cards[6] = 'CountDooku'
    P2_deck_cards[7] = 'AnakinSkywalkerROTS'
    P2_deck_cards[8] = 'SupremeLeaderSnoke'
    P2_deck_cards[9] = 'AhsokaTanoFulcrum'
    P2_deck_cards[10] = 'LukeSkywalkerROTJ'
    P2_deck_cards[11] = 'ObiWanKenobi'
    P2_deck_cards[12] = 'BoKatan'
    P2_deck_cards[13] = 'TheMandalorian'
    P2_deck_cards[14] = 'BobaFettMandalorian'
    P2_deck_cards[15] = 'JangoFett'
    P2_deck_cards[16] = 'BobaFettROTJ'
    P2_deck_cards[17] = 'Kuruk'

    gStateMachine:change('game',{'Death Star Control Room.jpg', 'photo', 0, 1, 1 ,1, 'Clone Wars Theme.oga'})
end