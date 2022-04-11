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

print('Welcome to this Unfortunate Program')

for i = 1, #PossibleTypes do
	print(tostring(i) .. ') ' .. PossibleTypes[i])
end

local DecidedType = PossibleTypes[io.read('*n')]

term.clear()
print('Loading ' .. DecidedType)


local BaseURL = 'http://riskyropes.com/funnyImage/' .. DecidedType

local Response = InternetAPI.request(BaseURL)

local Content = ''

for Data in Response do
	Content = Content .. Data
end

local ImageURL = string.gsub(Content,'"','')

print('Got Image')

local BoogleAPIURL = 'http://riskyropes.com/api/JPGToStr?url='..ImageURL

local ImageSize = InternetAPI.request('http://riskyropes.com/api/Res?url='..ImageURL)

local Content = ''

for Data in ImageSize do
	Content = Content .. Data
end

ImageSize = JSON:decode(Content)

print('Got Original Image Size')

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

print('Starting Color Processing')
local index = 0
for line in Content:gmatch("[^\r\n]+") do
	local l = tonumber(line)
    if l then
		table.insert(Colors,l)
	end

	if index % 1000 == 0 then
		print('...')
		os.sleep(.05)
	end

	index = index + 1

end

print('Got Colors')

local Image = {}

local index = 1


local function DrawPercentBar(Progress)
	local percentBar = '['
	for i = 1, 10 do
		if Progress >= i then
			percentBar = percentBar .. 'X'
		else
			percentBar = percentBar .. ' '
		end
	end
	return percentBar .. ']' 
end

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
	local d = math.ceil((index/ExpectedAmount)*10)
	if d ~= LastProgress then
		term.clear()
		print('Processing Image...')
		print(DrawPercentBar(d))
		os.sleep(0.1)
		LastProgress = d
	end
end

os.sleep(1)
term.clear()


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
