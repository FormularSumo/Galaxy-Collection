function maxed_dark_side() --Example level to make an interesting fight vs pre-built deck
    P2_deck_cards[0] = 'GeneralGrievous'
    P2_deck_cards[1] = 'DarthVader'
    P2_deck_cards[2] = 'DarthSidiousReborn'
    P2_deck_cards[3] = 'DarthSidious'
    P2_deck_cards[4] = 'CountDooku'
    P2_deck_cards[5] = 'Maul'
    P2_deck_cards[6] = 'MotherTalzin'
    P2_deck_cards[7] = 'AsajjVentress'
    P2_deck_cards[8] = 'SavageOpress'
    P2_deck_cards[9] = 'KyloRen'
    P2_deck_cards[10] = 'PreVizsla'
    P2_deck_cards[11] = 'DarkTrooper'
    P2_deck_cards[12] = 'IG11'
    P2_deck_cards[13] = 'GrandAdmiralThrawn'
    P2_deck_cards[14] = 'JangoFett'
    P2_deck_cards[15] = 'BobaFettROTJ'
    P2_deck_cards[16] = 'CadBane'
    P2_deck_cards[17] = 'IG88'

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
    P2_deck_cards[5] = 'AnakinSkywalkerROTS'
    P2_deck_cards[6] = 'Maul'
    P2_deck_cards[7] = 'ObiWanKenobi'
    P2_deck_cards[8] = 'LukeSkywalkerROTJ'
    P2_deck_cards[9] = 'CountDooku'
    P2_deck_cards[10] = 'AhsokaTanoS7'
    P2_deck_cards[11] = 'GeneralGrievous'
    P2_deck_cards[12] = 'BobaFettROTJ'
    P2_deck_cards[13] = 'TheMandalorian'
    P2_deck_cards[14] = 'BobaFettMandalorian'
    P2_deck_cards[15] = 'JangoFett'
    P2_deck_cards[16] = 'BoKatan'
    P2_deck_cards[17] = 'CadBane'

    gStateMachine:change('game',{'Death Star Control Room.jpg', 'photo', 0, 1, 1 ,1, 'Imperial March duet.mp3'})
end