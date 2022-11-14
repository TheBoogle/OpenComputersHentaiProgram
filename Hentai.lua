local Hentai = {}
Hentai.__index = Hentai

local component = require("component")
local gpu = component.gpu

local internet = require("internet")
local term = require("term")
local JSON = assert(loadfile("JSON.lua"))()
local Colors = assert(loadfile("Color.lua"))()

local function getResponse(URL)
	local Response = internet.request(URL)
	local ResponseString = ""

	for Chunk in Response do
		ResponseString = ResponseString .. Chunk
	end

	return ResponseString
end

local function getJsonResponse(URL)
	return JSON:decode(getResponse(URL))
end

function Hentai:genURL(Endpoint)
	return self.BaseURL .. Endpoint
end

function Hentai:drawImage(ColorString)

	-- Split the string into a table
	
	local ColorTable = {}

	local CIndex = 1

	for Color in ColorString:gmatch("%d+") do
		local N = tonumber(Color)
		
		if N then
			table.insert(ColorTable, N)
		end

		CIndex = CIndex + 1

		if CIndex % 1000 == 0 then
			os.sleep(0.05)
		end
	end

	-- Process Colors

	local Image = {}

	for ColorIndex = 1, #ColorTable, 3 do
		local R = ColorTable[ColorIndex]
		local G = ColorTable[ColorIndex + 1]
		local B = ColorTable[ColorIndex + 2]

		if not R or not G or not B then break end

		local FinalColor = Colors.RGBToInteger(R, G, B)
		table.insert(Image, FinalColor)

		if ColorIndex % 1000 == 0 then
			os.sleep(0.05)
		end
	end

	term.clear()

	local ColorIndex = 1

	for Y = 1, self.Height do
		for X = 1, self.Width do
			--if not Image[ColorIndex] then break end
			
			pcall(function() 
				gpu.setForeground(Image[ColorIndex])

				gpu.fill(X, Y, 1, 1, "█")
			end)

			ColorIndex = ColorIndex + 1

			if ColorIndex % 1000 == 0 then
				os.sleep(0.05)
			end
		end
	end

	for i = 1, 3 do
		component.computer.beep(1500,.25)
	end

end

function Hentai:getRandomHentai()
	return getResponse(self:genURL("/randomHentai/hentai"))
end

return function()
	local Width, Height = gpu.getResolution()

	local self = {
		BaseURL = "http://riskyropes.com:5000/api",
		Width = Width,
		Height = Height
	}

	setmetatable(self, Hentai)

	return self
end