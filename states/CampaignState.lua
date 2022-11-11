CampaignState = Class{__includes = BaseState}

function CampaignState:init()
    gui[1] = Button(function() gStateMachine:change('HomeState',true,true) end,'Main Menu',font80,nil,35,20,1,1,1)
    gui[2] = Button(function() loadBattle('Endor', nil, 0, 1, 1 ,1, 'Imperial March Duet.mp3', endor) end,'Endor',font80,nil,'centre',40,1,1,1,true)
    gui[3] = Button(function() loadBattle('Sand Dunes', true, 2, 0, 0, 0, 'Binary Sunset.oga', mosEisley) end,'Mos Eisley',font80,nil,'centre',170,1,1,1,true)
    gui[4] = Button(function() loadBattle('Sand Dunes', true, 2, 0, 0, 0, 'Throne Room.oga', mosEspa) end,'Mos Espa',font80,nil,'centre',300,1,1,1,true)
    gui[5] = Button(function() loadBattle('Death Star Control Room', nil, 0, 1, 1, 1, 'Imperial March Piano.oga', throneRoom) end,'Emperor\'s Throne Room',font80,nil,'centre',430,1,1,1,true)
    gui[6] = Button(function() loadBattle('Kamino', nil, 0, 1, 1, 1, 'Clone Wars Theme.oga', kamino) end,'Kamino',font80,nil,'centre',560,1,1,1,true)
    gui[7] = Button(function() loadBattle('Sand Dunes', true, 2, 0, 0, 0, 'Clone Wars Theme.oga', geonosis) end,'Geonosis',font80,nil,'centre',690,1,1,1,true)
    gui[8] = Button(function() loadBattle('Sith Triumvirate', nil, 0, 1, 1 ,1, 'The Old Republic.oga', sithTriumvirate) end,'Sith Triumvirate',font80,nil,'centre',820,1,1,1,true)
    gui[9] = Button(function() loadBattle('Order 66', nil, 0, 1, 1, 1, 'Throne Room.oga', jediCouncilChamber) end,'Jedi Council Chamber',font80,nil,'centre',950,1,1,1,true)
    gui[10] = Button(function() loadBattle('Voss', nil, 0, 1, 1, 1, 'The Mandalorian.oga', maxedLightSide) end,'Maxed Light Side',font80,nil,'centre',1080,1,1,1,true)
    gui[11] = Button(function() loadBattle('Sand Dunes', true, 2, 0, 0, 0, 'Binary Sunset.oga', maxedDarkSide) end,'Maxed Dark Side',font80,nil,'centre',1210,1,1,1,true)
    gui[12] = Button(function() loadBattle('Belsavis', nil, 0, 0, 0 ,0, 'Throne Room.oga', maxed) end,'Maxed',font80,nil,'centre',1340,1,1,1,true)
end

function CampaignState:back()
    gStateMachine:change('HomeState',true,true)
end