-- Add your things here.
local PossibleTypes = {
	'thighs',
	'zettaiRyouiki',
	'cum',
	'hentai',
	'pussy',
	'ass',
	'foot',
	'uniform',
	'tentacles',
	'public',
	'incest',
	'yuri',
	'masturbation',
	'public',
	'orgy',
	'nsfwneko',
	'sfwneko',
	'boobjob',
	'elves',
	'femdom',
	'glasses',
	'creampie',
	'panties',
	'gangbang',
	'ahegao',
	'bdsm',
	'blowjob',
}

local component = require('component')
local GPU = component.gpu
local Internet = component.internet

-- Custom Libraries
-- wget -f URL FileName
-- https://raw.githubusercontent.com/sziberov/OpenComputers/master/lib/json.lua
-- https://raw.githubusercontent.com/IgorTimofeev/Color/master/Color.lua
local JSON = assert(loadfile "JSON.lua")()
local Color = assert(loadfile "Color.lua")()

-- Built-in Libraries
local InternetAPI = require('internet')
local term = require('term')

-- Begin Input

term.clear()
print('Starting Loop...')
print('Please be patient')


local FirstRun = true

while true do
	pcall(function()
		local DecidedType = PossibleTypes[math.random(1,#PossibleTypes)]
		local BaseURL = 'http://riskyropes.com/funnyImage/' .. DecidedType

		local Response = InternetAPI.request(BaseURL)

		local Content = ''

		for Data in Response do
			Content = Content .. Data
		end

		local ImageURL = string.gsub(Content,'"','')

		local BoogleAPIURL = 'http://riskyropes.com/api/JPGToStr?url='..ImageURL

		local ImageSize = InternetAPI.request('http://riskyropes.com/api/Res?url='..ImageURL)

		local Content = ''

		for Data in ImageSize do
			Content = Content .. Data
		end

		ImageSize = JSON:decode(Content)

		local BoogleResponse = InternetAPI.request(BoogleAPIURL)

		local Content = ''
		local index = 0
		for Data in BoogleResponse do
			Content = Content .. Data:gsub(',','')
			if index % 1000 == 0 then
				os.sleep(.05)
			end
			index = index + 1
		end

		local Colors = {}

		local index = 0
		for line in Content:gmatch("[^\r\n]+") do
			local l = tonumber(line)
			if l then
				table.insert(Colors,l)
			end

			if index % 1000 == 0 then
				os.sleep(.05)
			end

			index = index + 1

		end

		local Image = {}

		local index = 1


		local LastProgress = 0

		local ExpectedAmount = #Colors / 3

		local Divise=3

		if ExpectedAmount ~= math.floor(ExpectedAmount) then
			ExpectedAmount = #Colors/4
			Divise = 4
		end

		for i = 1, #Colors,Divise do
			pcall(function() Image[index] = Color.RGBToInteger(Colors[i],Colors[i + 1],Colors[i + 2]) end)
			index = index + 1
		end

	    if FirstRun == false then
		os.sleep(30)
	    end

	    FirstRun = false

		local percent = 50 / ImageSize[2]

		local index = 1



		for y = 1, 50 do
			for x = 1, 160 do
				-- GPU.setBackground(Image[index])
				GPU.setForeground(Image[index])
				GPU.fill(x, y, 1, 1, "█")
				index = index + 1
			end
		end

		for i = 1, 3 do
			component.computer.beep(1500,.25)
		end	
	end)
    
end
