require 'love.image'
local running = true
while running do
    local imageName = love.thread.getChannel("imageDecoderQueue"):pop()
    if imageName then --Check if there are any tasks left
        love.thread.getChannel("imageDecoderOutput"):push({imageName,love.image.newImageData(imageName .. ".png")}) --Maybe change .png to be passed directly
    else
        running = false
    end
end