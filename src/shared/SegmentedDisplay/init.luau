--!strict
local Display = {}
Display.__index = Display

local WIDTH_SCALE = 0.66

local CharacterSet = require("@self/CharacterSet")
local SegmentTemplate = script.Segment

local function Weld(P0: BasePart, P1: BasePart)
	local Weld = Instance.new("Weld")
	Weld.Parent = P0
	Weld.C0 = P1.CFrame:ToObjectSpace(P0.CFrame)
	Weld.Part0 = P0
	Weld.Part1 = P1
	return
end

local function MakeSegment()
	return SegmentTemplate:Clone()
end

function Display.new(CharHeight: number, CharWidth: number, Scale: number)
	local self = setmetatable({}, Display)
	self.CharWidth = CharWidth
	self.CharHeight = CharHeight

	self.Model = Instance.new("Model")
	self.Background = Instance.new("Part")
	self.Background.Anchored = true
	self.Background.Size = Vector3.new(CharWidth * WIDTH_SCALE, CharHeight, 0)
	self.Background.Color = Color3.new()
	self.Background.Material = Enum.Material.Neon
	local bcf = self.Background.CFrame

	self.Segments = {}

	for y = 0, CharHeight - 1 do
		for x = 0, CharWidth - 1 do
			local Segment = MakeSegment()
			Segment:PivotTo(bcf * CFrame.new((x + 1 - 0.5 * CharWidth) * WIDTH_SCALE, (y + 1 - 0.5 * CharHeight), -0.1))
			Weld(self.Background, Segment.Pivot)
			Segment.Parent = self.Model
			table.insert(self.Segments, Segment)
		end
	end

	self.Background.Parent = self.Model

	return self
end

local function TogglePart(Part: BasePart, isOn: boolean)
	if isOn then
		Part.Material = Enum.Material.Neon
		Part.Color = Color3.new(0.972549, 0.301961, 0.301961)
	else
		Part.Material = Enum.Material.SmoothPlastic
		Part.Color = Color3.new(0.345098, 0.215686, 0.215686)
	end
end

local function testBitPos(bitstring: number, position: number): boolean
	local shift = bit32.lshift(bitstring, position - 1) --index from 1 so we take 1 away from position
	return bit32.band(shift, 0b1000000000000000) == 0b1000000000000000
end

local function ToggleSegment(Segment: typeof(SegmentTemplate), Character: string | nil, ActivateDot: boolean)
	TogglePart(Segment.Dot, ActivateDot)
	local BitString = CharacterSet[Character] or 0
	for i = 1, 16 do
		local part = Segment[i]
		TogglePart(part, testBitPos(BitString, i))
	end
end

function Display:Write(message: string)
	message = message:upper()
	local segmentindex = 1
	local i = 0
	while true do
		i += 1
		local Segment: typeof(SegmentTemplate) = self.Segments[#self.Segments - segmentindex + 1]
		if not Segment then
			break
		end
		local Character = message:sub(i, i)
		if Character == "\n" then
			local mod = segmentindex % self.CharWidth
			local dar = self.CharWidth - mod + 1

			for k = segmentindex, dar + segmentindex - 1 do
				local _Segment = self.Segments[#self.Segments - k + 1]
				if not _Segment then
					break
				end
				ToggleSegment(_Segment, nil, false)
			end
			segmentindex += dar
		else
			if i == 1 and Character == "." then
				ToggleSegment(Segment, nil, true)
			else
				if Character == "." then
					continue
				end
				local hasDot = message:sub(i + 1, i + 1) == "."
				ToggleSegment(Segment, Character, hasDot)
			end
			segmentindex += 1
		end
	end
end

return Display
