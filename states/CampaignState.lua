CampaignState = Class{__includes = BaseState}

function CampaignState:enter()
    gui[1] = Button(function() gStateMachine:change('HomeState',true,true) end,'Main Menu',font80,nil,35,20,{1,1,1})
    gui[2] = Button(function() gStateMachine:change('GameState',{'Endor', 'Imperial March Duet.mp3', endor}) end,'Endor',font80,nil,'centre',40,{1,1,1},true)
    gui[3] = Button(function() gStateMachine:change('GameState',{'Sand Dunes', 'Binary Sunset.oga', mosEisley}) end,'Mos Eisley',font80,nil,'centre',170,{1,1,1},true)
    gui[4] = Button(function() gStateMachine:change('GameState',{'Sand Dunes', 'Throne Room.oga', mosEspa}) end,'Mos Espa',font80,nil,'centre',300,{1,1,1},true)
    gui[5] = Button(function() gStateMachine:change('GameState',{'Death Star Control Room', 'Imperial March Piano.oga', throneRoom}) end,'Emperor\'s Throne Room',font80,nil,'centre',430,{1,1,1},true)
    gui[6] = Button(function() gStateMachine:change('GameState',{'Kamino', 'Clone Wars Theme.oga', kamino}) end,'Kamino',font80,nil,'centre',560,{1,1,1},true)
    gui[7] = Button(function() gStateMachine:change('GameState',{'Geonosis', 'Clone Wars Theme.oga', geonosis}) end,'Geonosis',font80,nil,'centre',690,{1,1,1},true)
    gui[8] = Button(function() gStateMachine:change('GameState',{'Dathomir', 'Fallen Order.oga', dathomir}) end,'Dathomir',font80,nil,'centre',820,{1,1,1},true)
    gui[9] = Button(function() gStateMachine:change('GameState',{'Sith Triumvirate', 'The Old Republic.oga', sithTriumvirate}) end,'Sith Triumvirate',font80,nil,'centre',950,{1,1,1},true)
    gui[10] = Button(function() gStateMachine:change('GameState',{'Order 66', 'Throne Room.oga', jediCouncilChamber}) end,'Jedi Council Chamber',font80,nil,'centre',1080,{1,1,1},true)
    gui[11] = Button(function() gStateMachine:change('GameState',{'Voss', 'The Mandalorian.oga', maxedLightSide}) end,'Maxed Light Side',font80,nil,'centre',1210,{1,1,1},true)
    gui[12] = Button(function() gStateMachine:change('GameState',{'Sand Dunes', 'Binary Sunset.oga', maxedDarkSide}) end,'Maxed Dark Side',font80,nil,'centre',1340,{1,1,1},true)
    gui[13] = Button(function() gStateMachine:change('GameState',{'Belsavis', 'Throne Room.oga', maxed}) end,'Maxed',font80,nil,'centre',1470,{1,1,1},true)
end

function CampaignState:back()
    gStateMachine:change('HomeState',true,true)
end