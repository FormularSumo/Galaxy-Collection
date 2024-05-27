require 'love.image'
while love.thread.getChannel("imageDecoderWorking"):peek() or love.thread.getChannel("imageDecoderQueue"):peek() do --Maybe could be rewritten better
    local imageName = love.thread.getChannel("imageDecoderQueue"):pop()
    if imageName then --This is needed incase other threads have taken all remaining tasks between checking if there are any and retriving one
        love.thread.getChannel("imageDecoderOutput"):push({imageName,love.image.newImageData(imageName .. ".png")}) --Maybe change .png to be passed directly
    end
end