function maxed_dark_side() --Example level to make an interesting fight vs pre-built deck
    P2_deck_cards[0] = 'Maul'
    P2_deck_cards[1] = 'CountDooku'
    P2_deck_cards[2] = 'DarthSidious'
    P2_deck_cards[3] = 'DarthVader'
    P2_deck_cards[4] = 'GeneralGrievous'
    P2_deck_cards[5] = 'SavageOpress'
    P2_deck_cards[6] = 'MagnaGuard'
    P2_deck_cards[7] = 'PreVizsla'
    P2_deck_cards[8] = 'KyloRen'
    P2_deck_cards[9] = 'AsajjVentress'
    P2_deck_cards[10] = 'DarkTrooper'
    P2_deck_cards[11] = 'Droideka'
    P2_deck_cards[12] = 'RedGuard'
    P2_deck_cards[13] = 'CadBane'
    P2_deck_cards[14] = 'JangoFett'
    P2_deck_cards[15] = 'BobaFett'
    P2_deck_cards[16] = 'RoyalGuard'
    P2_deck_cards[17] = 'B2RPSuperBattleDroid'

    gStateMachine:change('game',{'Sand Dunes', 'video', 2, 0, 0, 0})
end

function throne_room()
    P2_deck_cards[1] = 'RoyalGuard'
    P2_deck_cards[2] = 'DarthSidious'
    P2_deck_cards[3] = 'DarthVader'
    P2_deck_cards[4] = 'RoyalGuard'
   
    gStateMachine:change('game',{'Death Star Control Room', 'photo', 0, 1, 1 ,1})
end

function endor()
    for i = 0, 17 ,1 do
        P2_deck_cards[i] = 'Ewok'
    end
   
    gStateMachine:change('game',{'Endor', 'photo', 0, 1, 1 ,1})
end

function maxed()
    P2_deck_cards[0] = 'Yoda'
    P2_deck_cards[1] = 'DarthSidious'
    P2_deck_cards[2] = 'DarthSidiousReborn'
    P2_deck_cards[3] = 'MaceWindu'
    P2_deck_cards[4] = 'DarthVader'
    P2_deck_cards[5] = 'AnakinF3'
    P2_deck_cards[6] = 'Maul'
    P2_deck_cards[7] = 'ObiWanKenobi'
    P2_deck_cards[8] = 'JediKnightLuke'
    P2_deck_cards[9] = 'CountDooku'
    P2_deck_cards[10] = 'AhsokaS7'
    P2_deck_cards[11] = 'GeneralGrievous'
    P2_deck_cards[12] = 'CaptainRex'
    P2_deck_cards[13] = 'TheMandalorian'
    P2_deck_cards[14] = 'JangoFett'
    P2_deck_cards[15] = 'BobaFett'
    P2_deck_cards[16] = 'CadBane'
    P2_deck_cards[17] = 'HanSoloOld'

    gStateMachine:change('game',{'Death Star Control Room', 'photo', 0, 1, 1 ,1})
end