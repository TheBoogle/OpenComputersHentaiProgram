local component = require("component")
local gpu = component.gpu

local term = require("term")

local Hentai = assert(loadfile("Hentai.lua"))()
local Colors = assert(loadfile("Color.lua"))()
Hentai = Hentai()


term.clear()

while true do
	local HColors = Hentai:getRandomHentai()

	Hentai:drawImage(HColors)
end