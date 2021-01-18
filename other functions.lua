function pause()
    if paused == false then
        paused = true
    else
        paused = false
    end
end

function gamespeed_slider(percentage)
    gamespeed = percentage * 4
end

function return_to_main_menu()
    gStateMachine:change('home')
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