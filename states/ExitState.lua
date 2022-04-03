ExitState = Class{__includes = BaseState}

function ExitState:init()
    gui[1] = Button(love.event.quit,'Exit Game',font100,nil,'centre',540-font100:getHeight('Exit Game')*1.5)
    gui[2] = Button(function() gStateMachine:change('HomeState',true,true) end,'Back',font100,nil,'centre',540+font100:getHeight('Back')*0.5)
end

function ExitState:back()
    gStateMachine:change('HomeState',true,true)
end