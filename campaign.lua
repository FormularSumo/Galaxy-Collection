function maxed_dark_side() --Example level to make an interesting fight vs pre-built deck
    P2_deck_cards[0] = 'CountDooku'
    P2_deck_cards[1] = 'DarthVader'
    P2_deck_cards[2] = 'DarthSidiousReborn'
    P2_deck_cards[3] = 'DarthSidious'
    P2_deck_cards[4] = 'SupremeLeaderSnoke'
    P2_deck_cards[5] = 'GeneralGrievous'
    P2_deck_cards[6] = 'AsajjVentress'
    P2_deck_cards[7] = 'KyloRen'
    P2_deck_cards[8] = 'Maul'
    P2_deck_cards[9] = 'SavageOpress'
    P2_deck_cards[10] = 'GrandInquisitor'
    P2_deck_cards[11] = 'PreVizsla'
    P2_deck_cards[12] = 'CadBane'
    P2_deck_cards[13] = 'GrandAdmiralThrawn'
    P2_deck_cards[14] = 'JangoFett'
    P2_deck_cards[15] = 'BobaFettROTJ'
    P2_deck_cards[16] = 'PurgeTrooper'
    P2_deck_cards[17] = 'IG11'

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
    for i = 0, 17 ,1 do
        P2_deck_cards[i] = 'Ewok'
    end
   
    gStateMachine:change('game',{'Endor.jpg', 'photo', 0, 1, 1 ,1, 'Battle music 1.mp3'})
end

function maxed()
    P2_deck_cards[0] = 'Yoda'
    P2_deck_cards[1] = 'DarthSidious'
    P2_deck_cards[2] = 'DarthSidiousReborn'
    P2_deck_cards[3] = 'MaceWindu'
    P2_deck_cards[4] = 'DarthVader'
    P2_deck_cards[5] = 'SupremeLeaderSnoke'
    P2_deck_cards[6] = 'ObiWanKenobi'
    P2_deck_cards[7] = 'LukeSkywalkerROTJ'
    P2_deck_cards[8] = 'AhsokaTanoFulcrum'
    P2_deck_cards[9] = 'AnakinSkywalkerROTS'
    P2_deck_cards[10] = 'CountDooku'
    P2_deck_cards[11] = 'AhsokaTanoS7'
    P2_deck_cards[12] = 'BoKatan'
    P2_deck_cards[13] = 'TheMandalorian'
    P2_deck_cards[14] = 'BobaFettMandalorian'
    P2_deck_cards[15] = 'JangoFett'
    P2_deck_cards[16] = 'BobaFettROTJ'
    P2_deck_cards[17] = 'CadBane'

    gStateMachine:change('game',{'Death Star Control Room.jpg', 'photo', 0, 1, 1 ,1, 'Imperial March duet.mp3'})
end