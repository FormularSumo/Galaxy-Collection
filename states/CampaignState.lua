CampaignState = Class{__includes = BaseState}

function CampaignState:init()
    gui[1] = Button('switchState',{'HomeState',true,true},'Main Menu',font80,nil,50,60,1,1,1)
    gui[2] = Button('endor',nil,'Endor',font80,nil,'centre',40,1,1,1,true)
    gui[3] = Button('mosEisley',nil,'Mos Eisley',font80,nil,'centre',170,1,1,1,true)
    gui[5] = Button('throneRoom',nil,'Emperor\'s Throne Room',font80,nil,'centre',300,1,1,1,true)
    gui[4] = Button('kamino',nil,'Kamino',font80,nil,'centre',430,1,1,1,true)
    gui[6] = Button('maxedDarkSide',nil,'Maxed Dark Side',font80,nil,'centre',560,1,1,1,true)
    gui[7] = Button('maxedLightSide',nil,'Maxed Light Side',font80,nil,'centre',690,1,1,1,true)
    gui[8] = Button('maxed',nil,'Maxed',font80,nil,'centre',820,1,1,1,true)
end

function CampaignState:back()
    gStateMachine:change('HomeState',true,true)
end

function CampaignState:exit(partial)
    exitState(partial)
end