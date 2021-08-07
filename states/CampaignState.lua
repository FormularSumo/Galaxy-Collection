CampaignState = Class{__includes = BaseState}

function CampaignState:init()
    backstate = {'HomeState',true,true}
    gui['HomeState'] = Button('back',nil,'Main Menu',font80,nil,'centre',100)
    gui['Maxed Dark Side'] = Button('maxed_dark_side',nil,'Maxed Dark Side',font80,nil,'centre',380)
    gui['Emperor\'s Throne Room'] = Button('throne_room',nil,'Emperor\'s Throne Room',font80,nil,'centre',520)
    gui['Endor'] = Button('endor',nil,'Endor',font80,nil,'centre',660)
    gui['Kamino'] = Button('kamino',nil,'Kamino',font80,nil,'centre',800)
    gui['Maxed'] = Button('maxed',nil,'Maxed',font80,nil,'centre',940)
end

function CampaignState:exit(partial)
    exit_state(partial)
end