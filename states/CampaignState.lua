CampaignState = Class{__includes = BaseState}

function CampaignState:init()
    gui[1] = Button(switchState,{'HomeState',true,true},'Main Menu',font80,nil,50,60,1,1,1)
    gui[2] = Button(loadBattle,{'Endor', 'photo', 0, 1, 1 ,1, 'Imperial March Duet.mp3',endor},'Endor',font80,nil,'centre',40,1,1,1,true)
    gui[3] = Button(loadBattle,{'Sand Dunes', 'video', 2, 0, 0, 0, 'Binary Sunset.oga', mosEisley},'Mos Eisley',font80,nil,'centre',170,1,1,1,true)
    gui[4] = Button(loadBattle,{'Sand Dunes', 'video', 2, 0, 0, 0, 'Throne Room.oga', mosEspa},'Mos Espa',font80,nil,'centre',300,1,1,1,true)
    gui[5] = Button(loadBattle,{'Death Star Control Room', nil, 0, 1, 1, 1, 'Imperial March Piano.oga', throneRoom},'Emperor\'s Throne Room',font80,nil,'centre',430,1,1,1,true)
    gui[6] = Button(loadBattle,{'Kamino', nil, 0, 1, 1, 1, 'Clone Wars Theme.oga', kamino},'Kamino',font80,nil,'centre',560,1,1,1,true)
    gui[7] = Button(loadBattle,{'Sand Dunes', 'video', 2, 0, 0, 0, 'Clone Wars Theme.oga', geonosis},'Geonosis',font80,nil,'centre',690,1,1,1,true)
    gui[8] = Button(loadBattle,{'Sith Triumvirate', 'photo', 0, 1, 1 ,1, 'The Old Republic.oga',sithTriumvirate},'Sith Triumvirate',font80,nil,'centre',820,1,1,1,true)
    gui[9] = Button(loadBattle,{'Sand Dunes', 'video', 2, 0, 0, 0, 'Binary Sunset.oga', maxedDarkSide},'Maxed Dark Side',font80,nil,'centre',950,1,1,1,true)
    gui[10] = Button(loadBattle,{'Voss', 'photo', 0, 1, 1, 1, 'The Mandalorian.oga', maxedLightSide},'Maxed Light Side',font80,nil,'centre',1080,1,1,1,true)
    gui[11] = Button(loadBattle,{'Belsavis', 'photo', 0, 0, 0 ,0, 'Throne Room.oga', maxed},'Maxed',font80,nil,'centre',1210,1,1,1,true)
end

function CampaignState:back()
    gStateMachine:change('HomeState',true,true)
end