require 'love.image'
while love.thread.getChannel("imageDecoderWorking"):peek() or love.thread.getChannel("imageDecoderQueue"):peek() do --Maybe oculd be rewritten better
    if love.thread.getChannel("imageDecoderQueue"):peek() then
        imageName = love.thread.getChannel("imageDecoderQueue"):pop()
        imageData = love.image.newImageData(imageName .. ".png") --Maybe change this to be passed directly

        love.thread.getChannel("imageDecoderOutput"):performAtomic( --Perform atomic so that both values are pushed sequentially and not pop'd individually or pushed in-between
            function() 
                love.thread.getChannel("imageDecoderOutput"):push(imageName)
                love.thread.getChannel("imageDecoderOutput"):push(imageData)
            end
        )
    end
end