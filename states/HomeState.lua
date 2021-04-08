HomeState = Class{__includes = BaseState}

function HomeState:init()
    gui['CampaignState'] = Button('switch_state',{'CampaignState',true,true},'Campaign',font80,nil,'centre',100)
    gui['Prebuilt Deck'] = Button('prebuilt_deck',nil,'Create a pre-built deck',font80,nil,'centre',500)
    gui['SettingsState'] = Button('switch_state',{'SettingsState',true,true},'Settings',font80,nil,'centre',965)
end

function HomeState:exit(partial)
    exit_state(partial)
end