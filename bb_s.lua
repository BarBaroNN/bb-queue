local globalCounter, latestColor, ColorsTimeout = 0, nil, false
local playersInfo, connectingInfo = {}, {} 
local jsonCard = json.decode(LoadResourceFile(GetCurrentResourceName(), 'presentCard.json'))[1]
StopResource('hardcap')

AddEventHandler("playerConnecting", function(name, reject, d)
    local _source = source
    local currentSteamID, currentDiscordID
    d.defer()
    Wait(50)
    d.update(Config.HandshakingWith)
    Wait(250)

    for k, v in ipairs(GetPlayerIdentifiers(_source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            currentDiscordID = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            currentSteamID = v
        end
    end

    if not currentDiscordID then
        reject(Config.NoDiscord)
        CancelEvent()
        return
    end

    if not currentSteamID then
        reject(Config.NoSteam)
        CancelEvent()
        return
    end

    if not ProccessQueue(currentSteamID, currentDiscordID, d, _source) then
        CancelEvent()
    end
end)

function ProccessQueue(steamID, discordID, d, _source)
    local data = {name = nil, queuepts = 0}
	PerformHttpRequest("https://discordapp.com/api/guilds/" .. Config.DiscordServerID .. "/members/"..string.sub(discordID, 9), function(err, text, headers) 
		if text ~= nil then
        	local member = json.decode(text)
        	local memberRoleNames, memberRoleNamesCounter = '', 0
        	for a, b in ipairs(member.roles) do
        	    for _, roleData in pairs(Config.Roles) do
        	        if b == roleData.roleID then
        	            data.queuepts = data.queuepts + roleData.points
        	            if memberRoleNamesCounter == 0 then
        	            	memberRoleNames = roleData.name
        	            	memberRoleNamesCounter = memberRoleNamesCounter + 1
        	            else
        	            	memberRoleNames = memberRoleNames .. ' & ' .. roleData.name
        	            end
        	        end
        	    end
        	end

        	local localname, localdec = "", ""
        	for k, v in pairs(member.user) do
        	    if k == "username" then
        	        localname = v
        	    elseif k == "discriminator" then
        	        localdec = tostring(v)
        	    end
        	end
			data.name = localname .. "#" .. tostring(localdec)
			memberRoleNames = memberRoleNames ~= "" and memberRoleNames or "Member"


        	AddPlayer(steamID, discordID, data.name, data.queuepts, memberRoleNames, _source, d)
		else
        	AddPlayer(steamID, discordID, "Not Found", 0, "None", _source, d)
		end
		
        local stop = false
        repeat
        	for k, v in pairs(connectingInfo) do
        		if v.steamID == steamID then
        			stop = true
        		end
        	end

			for k, v in ipairs(playersInfo) do
				if v.steamID == steamID and (GetPlayerPing(v.source) == 0) then
					dropPlayerFromQueue(steamID, discordID)
					d.done(Config.Error)
					return false
				end
			end

            local currentMessage = GetMessage()
            d.presentCard(currentMessage, function(data, rawData) end)
            Wait(0)
        until stop
	
        d.done()
		return true
	end, "GET", "", {["Content-type"] = "application/json", ["Authorization"] = "Bot " .. Config.DiscordBotToken})
	return false
end

AddEventHandler("playerDropped", function(reason)
    local _source = source
    dropPlayerFromQueue(GetPlayerIdentifier(_source, 1), GetPlayerIdentifier(_source, 3))
end)

RegisterServerEvent('bb-queue:removeConnected')
AddEventHandler('bb-queue:removeConnected', function()
	local _source = source
	for k, v in pairs(connectingInfo) do
		if v.steamID == GetPlayerIdentifier(_source) then
			table.remove(connectingInfo, k)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)
        CheckConnecting()

        if #playersInfo > 0 and #connectingInfo + #GetPlayers() < Config.maxServerSlots then
            ConnectFirst()
        end
    end
end)

function dropPlayerFromQueue(steamID, discordID, count)
	if count then
		local queueCount = #playersInfo
    	for currentPlayer = count, queueCount do
    		playersInfo[currentPlayer] = playersInfo[currentPlayer + 1]
    	end
	else
		for k, v in pairs(playersInfo) do
			if v.steamID == steamID or v.discordID == discordID then
				local queueCount = #playersInfo
    			local saveCred = nil
    			for currentPlayer = k + 1, queueCount do
    				playersInfo[currentPlayer - 1] = playersInfo[currentPlayer]
    			end
    			playersInfo[queueCount] = nil
    			return
			end
		end
	end
end

function AddPlayer(steamID, discordID, discordName, queuePts, roleNames, source, d)
    local _source = source

    if #playersInfo == 0 then
    	playersInfo[1] = {
    		steamID = steamID,
    		steamName = GetPlayerName(_source),
    		discordID = discordID,
    		discordName = discordName, 
    		points = queuePts,
    		roleNames = roleNames,
    		source = _source
    	}
    else
    	for k, v in pairs(playersInfo) do
    		if v.points < queuePts then
    			local queueCount = #playersInfo
    			local saveCred = nil
    			for currentPlayer = k, queueCount + 1 do
    				if currentPlayer == k then
    					saveCred = playersInfo[currentPlayer + 1]
    					playersInfo[currentPlayer + 1] = playersInfo[currentPlayer]
    				else
    					local currentSaveCred = playersInfo[currentPlayer + 1]
    					playersInfo[currentPlayer + 1] = saveCred
    					saveCred = currentSaveCred
    				end
    			end

    			playersInfo[k] = {
    				steamID = steamID,
    				steamName = GetPlayerName(_source),
    				discordID = discordID,
    				discordName = discordName, 
    				points = queuePts,
    				roleNames = roleNames,
    				source = _source
    			}
    			return
    		end
    	end

    	playersInfo[#playersInfo + 1] = {
    		steamID = steamID,
    		steamName = GetPlayerName(_source),
    		discordID = discordID,
    		discordName = discordName, 
    		points = queuePts,
    		roleNames = roleNames,
    		source = _source
    	}
    end
end

function CheckConnecting()
    for k, v in pairs(playersInfo) do
        if GetPlayerPing(v.source) == 500 then
           	dropPlayerFromQueue(nil, nil, k)
        end
    end

    for k, v in pairs(connectingInfo) do
        if GetPlayerPing(v.source) == -1 then
            if v.errorsNum > 1 then
                table.remove(connectingInfo, k)
            end
            v.errorsNum = v.errorsNum + 1
        end
    end
end

function ConnectFirst()
    if #playersInfo == 0 then 
    	return 
    end
    
    table.insert(connectingInfo, {steamID = playersInfo[1].steamID, source = playersInfo[1].source, errorsNum = 0})
    dropPlayerFromQueue(nil, nil, 1)
end

function GetMessage()
    local msg = ""
    local cardd = jsonCard
    local counter = 1
    for k, v in pairs(playersInfo) do
    	if counter < 10 then
        	msg = msg .. '['..tostring(k)..'] ' .. v.steamName .. ' (' .. v.discordName .. ') | ' .. v.roleNames .. '\n'
        	counter = counter + 1
        elseif counter == 10 then
        	msg = msg .. 'And ' .. #playersInfo - counter .. ' more players.\n'
        	counter = counter + 1
        end
    end

    cardd.body[2].text = msg
    cardd.body[3].text = "Queue Length: " .. tostring(#playersInfo) .. " | Player Count: " .. #GetPlayers() .. "/" .. Config.maxServerSlots

    if not ColorsTimeout then
    	startColorTimeout()
    	local changedColor = false
    	repeat
    		local currentColor = Config.Colors[math.random(#Config.Colors)]
    		if currentColor ~= latestColor then
    			cardd.body[1].color = currentColor
    			cardd.body[3].color = currentColor
    			cardd.body[4].color = currentColor
    			latestColor = currentColor
    			changedColor = true
    		end
    	until changedColor
    end
    return cardd
end

function startColorTimeout()
	ColorsTimeout = true
	Wait(1500)
	ColorsTimeout = false
end

RegisterCommand('bb-resetConnects', function()
	for k, v in pairs(connectingInfo) do
		table.remove(connectingInfo, k)
	end
end)
