local d = require(game.ReplicatedStorage.Shared.SegmentedDisplay)

local Display = d.new(3, 20, 1)
Display.Model.Parent = workspace

local str = "1.23456789123456789\n1.23456789123456789\n1.23456789123456789"
Display:Write(str)
print(str)

while true do
	local a = math.random()
	local b = math.random()
	local c = math.random()
    local format = "%.19f"
	-- local s = string.format("%.17f", a) .. "\n" .. string.format("%.17f", b) .. "\n" .. string.format("%.17f", c)
    local s = string.format(format, a) .. string.format(format, b) .. string.format(format, c)
    Display:Write(s)
    task.wait(0.05)
end
