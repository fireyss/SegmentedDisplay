local d = require(game.ReplicatedStorage.Shared.SegmentedDisplay)

local Display = d.new(3, 20, { Scale = 1, GlassDistortion = true })
Display.Model.Parent = workspace

-- local str = "1.23456789123456789\n1.23456789123456789\n1.23456789123456789"
-- Display:Write(str)
-- print(str)

local list = {
	"The quick brown fox jumped over the lazy dog.",
	("Interestingly, 3000 mites had been released that day."):upper(),
	".-."
}

while true do
	for i, v in list do
		Display:Write(v)
		task.wait(3)
	end
end

-- while true do
-- 	local a = math.random()
-- 	local b = math.random()
-- 	local c = math.random()
-- 	local format = "%.19f"
-- 	-- local s = string.format("%.17f", a) .. "\n" .. string.format("%.17f", b) .. "\n" .. string.format("%.17f", c)
-- 	local s = string.format(format, a) .. string.format(format, b) .. string.format(format, c)
-- 	Display:Write(s)
-- 	task.wait(0.05)
-- end
