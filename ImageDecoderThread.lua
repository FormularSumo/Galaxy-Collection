require 'love.image'
while love.thread.getChannel("imageDecoderWorking"):peek() or love.thread.getChannel("imageDecoderQueue"):peek() do --Maybe could be rewritten better
    local imageName = love.thread.getChannel("imageDecoderQueue"):pop()
    if imageName then --This is needed incase other threads have taken all remaining tasks between checking if there are any and retriving one
        local imageData = love.image.newImageData(imageName .. ".png") --Maybe change this to be passed directly

        love.thread.getChannel("imageDecoderOutput"):performAtomic( --Perform atomic so that both values are pushed sequentially and not pop'd individually or pushed in-between
            function() 
                love.thread.getChannel("imageDecoderOutput"):push(imageName)
                love.thread.getChannel("imageDecoderOutput"):push(imageData)
            end
        )
    end
end