function battle1() --The 1st level of the game campaign, will in future be all Ewoks I think, currently these characters to make an interesting fight vs pre-built deck
    P2_deck_cards[0] = 'Maul'
    P2_deck_cards[1] = 'CountDooku'
    P2_deck_cards[2] = 'DarthSidiousReborn'
    P2_deck_cards[3] = 'DarthVader'
    P2_deck_cards[4] = 'GeneralGrievous'
    P2_deck_cards[5] = 'KyloRen'
    P2_deck_cards[6] = 'Droideka'
    P2_deck_cards[7] = 'PreVizsla'
    P2_deck_cards[8] = 'SavageOpress'
    P2_deck_cards[9] = 'AsajjVentress'
    P2_deck_cards[10] = 'MagnaGuard'
    P2_deck_cards[11] = 'B1BattleDroid'
    P2_deck_cards[12] = 'B2RPSuperBattleDroid'
    P2_deck_cards[13] = 'CadBane'
    P2_deck_cards[14] = 'JangoFett'
    P2_deck_cards[15] = 'BobaFett'
    P2_deck_cards[16] = 'Greedo'
    P2_deck_cards[17] = 'B2SuperBattleDroid'

    gStateMachine:change('game')
end

function prebuilt_deck() --Doesn't belong here, will either be deleted or moved when I add deck editing
    P1_deck_edit(0,'AhsokaS7')
    P1_deck_edit(1,'AnakinF3')
    P1_deck_edit(2,'Yoda')
    P1_deck_edit(3,'MaceWindu')
    P1_deck_edit(4,'ObiWanKenobi')
    P1_deck_edit(5,'Rey')
    P1_deck_edit(6,'Ewok')
    P1_deck_edit(7,'BabyYoda')
    P1_deck_edit(8,'JediKnightLuke')
    P1_deck_edit(9,'BenKenobi')
    P1_deck_edit(10,'R2D2')
    P1_deck_edit(11,'C3P0')
    P1_deck_edit(12,'FarmboyLuke')
    P1_deck_edit(13,'HanSoloOld')
    P1_deck_edit(14,'CaptainRex')
    P1_deck_edit(15,'TheMandalorian')
    P1_deck_edit(16,'Chewbacca')
    P1_deck_edit(17,'Hondo')
end