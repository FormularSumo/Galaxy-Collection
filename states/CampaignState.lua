CampaignState = Class{__includes = BaseState}

function CampaignState:init()
    gui[1] = Button('switch_state',{'HomeState',true,true},'Main Menu',font80,nil,'centre',60)
    gui[2] = Button('endor',nil,'Endor',font80,nil,'centre',300)
    gui[3] = Button('tatooine',nil,'Tatooine',font80,nil,'centre',430)
    gui[4] = Button('kamino',nil,'Kamino',font80,nil,'centre',560)
    gui[5] = Button('throne_room',nil,'Emperor\'s Throne Room',font80,nil,'centre',690)
    gui[6] = Button('maxed_dark_side',nil,'Maxed Dark Side',font80,nil,'centre',820)
    gui[7] = Button('maxed_light_side',nil,'Maxed Light Side',font80,nil,'centre',950)
    gui[8] = Button('maxed',nil,'Maxed',font80,nil,'centre',1080)
end

function CampaignState:back()
    gStateMachine:change('HomeState',true,true)
end

function CampaignState:exit(partial)
    exit_state(partial)
end