local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end

local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/AsuraXowner/SentinelRise/main/' .. select(1, path:gsub('sentinelrise/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after SentinelVAPE updates.\n' .. res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'sentinelrise', 'sentinelrise/games', 'sentinelrise/profiles', 'sentinelrise/assets', 'sentinelrise/libraries', 'sentinelrise/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.VapeDeveloper then
	local commit = 'main'
	if (not isfile('sentinelrise/profiles/commit.txt')) or readfile('sentinelrise/profiles/commit.txt') ~= commit then
		wipeFolder('sentinelrise')
		wipeFolder('sentinelrise/games')
		wipeFolder('sentinelrise/guis')
		wipeFolder('sentinelrise/libraries')
	end
	writefile('sentinelrise/profiles/commit.txt', commit)
end

return loadstring(downloadFile('sentinelrise/main.lua'), 'main')()
