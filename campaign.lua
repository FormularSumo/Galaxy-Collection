function battle1() --The 1st level of the game campaign, will in future be all Ewoks I think, currently these characters to make an interesting fight vs pre-built deck
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

    gStateMachine:change('game',{'Sand Dunes', 'video', 2})
end

function throne_room() --The 1st level of the game campaign, will in future be all Ewoks I think, currently these characters to make an interesting fight vs pre-built deck
    P2_deck_cards[1] = 'RoyalGuard'
    P2_deck_cards[2] = 'DarthSidious'
    P2_deck_cards[3] = 'DarthVader'
    P2_deck_cards[4] = 'RoyalGuard'
   
    gStateMachine:change('game',{'Endor', 'photo', 0})
end