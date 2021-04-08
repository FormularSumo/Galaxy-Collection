CampaignState = Class{__includes = BaseState}

function CampaignState:init()
    gui['HomeState'] = Button('switch_state',{'HomeState',true,true},'Main Menu',font80,nil,'centre',100)
    gui['Maxed Dark Side'] = Button('maxed_dark_side',nil,'Maxed Dark Side',font80,nil,'centre',380)
    gui['Emperor\'s Throne Room'] = Button('throne_room',nil,'Emperor\'s Throne Room',font80,nil,'centre',520)
    gui['Endor'] = Button('endor',nil,'Endor',font80,nil,'centre',660)
    gui['Maxed'] = Button('maxed',nil,'Maxed',font80,nil,'centre',800)
end

function CampaignState:exit(partial)
    exit_state(partial)
end