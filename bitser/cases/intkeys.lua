local t = {}

for i = 1, 200 do
	t[love.math.random(1000)] = love.math.random(100)
end

return t, 30000, 5