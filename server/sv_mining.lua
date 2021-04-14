local playersMiningTotal = {}
local playersZonesCompleted = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.rock_reset_time * 1000)
		resetZoneRocks()
	end
end)

AddEventHandler("playerDropped", function()
	for _, zone in pairs(Config.mining_zones) do
		for _, rock in pairs(zone.rocks) do
			
			if rock.beingMinedBy == source and not mined then
				rock.isBeingMined = false
				rock.beingMinedBy = nil
				print("Player dropped but didn't finish mining reset it")
			end

		end
	end

end)

-- Called when player joins job to assign them a zone
RegisterServerEvent("np-mining:assignZone")
AddEventHandler("np-mining:assignZone", function()
	local zoneList = Config.mining_zones -- Stored so I can remove any zones if the person already did it and choose from that list

	-- Let me check if player hit zone limit during this run?
	if playersZonesCompleted[source] ~= nil and #playersZonesCompleted[source] >= Config.zone_limit then
		TriggerEvent("np-mining:completedRun", source)
		return print("You have completed max amount of zones this run")	 -- Notify User with UI
	end

	-- Loop through our zones and player mined zones and remove the ones theyve done
	if playersZonesCompleted[source] ~= nil then
		for index, zone in pairs(zoneList) do
			for _, playerZoneDone in pairs (playersZonesCompleted[source]) do
				if zone.id == playerZoneDone then
					table.remove(zoneList, index)
					print("Removing this zone because player has done it alrdy")
				end
			end
		end

	end

	-- Check if their is any zones the player can do (edge case)
	if #zoneList == 0 then
		TriggerEvent("np-mining:completedRun")
		return print("You have no more zones you can mine at this time.") -- Notify User with UI
	end

	local randomZoneIndex = math.random(#zoneList)
	local randomZone = zoneList[randomZoneIndex]
	-- local recentlyMined = ZoneMinedRecently(randomZone, playersZonesCompleted[source], source)

	playersMiningTotal[source] = nil -- Set to nil again once we move to another zone so then we can track that zone 
	TriggerClientEvent("np-mining:assignedZone", source, randomZone)
end)


-- Called when player tries to mine a rock in their zone
RegisterServerEvent("np-mining:attemptMine")
AddEventHandler("np-mining:attemptMine", function(miningZone, miningRock)

	-- Look for which zone theyre in
	for _, zone in pairs(Config.mining_zones) do
		for _, rock in pairs(zone.rocks) do
			if rock.id == miningRock.id then

				if rock.isMined then
					return print("Rock has already been mined") -- Notify User with UI
				end

				if rock.isBeingMined then
					return print("Rock is currently being mined") -- Notify User with UI
				end

				if zone.id == miningZone.id then
					
					-- If the user doesnt exist in table create one with default number of mines set to 0
					if playersMiningTotal[source] == nil then
						print("im nil so should be logging")
						playersMiningTotal[source] = { zone = miningZone.id, amount = 0 }
					end

					if playersMiningTotal[source].zone == zone.id then
							if playersMiningTotal[source].amount >= zone.maxMineAmount then
								return print("You can no longer mine in this zone for now. " .. playersMiningTotal[source].zone)
							else
								playersMiningTotal[source].amount = playersMiningTotal[source].amount + 1
								print("Starting to mine rock " .. playersMiningTotal[source].amount)
								rock.isBeingMined = true
								rock.beingMinedBy = source
								TriggerClientEvent("np-mining:beginMiningRock", source, zone, rock, Config.required_rock_hits, source)
								return
							end
					end

				end

			end

		end

	end

end)

-- Called when player is done mining the rock
RegisterServerEvent("np-mining:completedMining")
AddEventHandler("np-mining:completedMining", function(minedZone, minedRock, source)

	Citizen.CreateThread(function()
		for _, zone in pairs(Config.mining_zones) do
	
			if minedZone.id == zone.id then
	
				for _, rock in pairs(zone.rocks) do
		
					if rock.id == minedRock.id then
						rock.isBeingMined = false
						rock.isMined = true
			
						-- Figure out what they got
						local chance = math.random(0, 100)
			
						if chance < 50 then
							TriggerClientEvent("np-mining:collectRock", source, zone, rock, "gem") -- Notify User with UI
						else
							TriggerClientEvent("np-mining:collectRock", source, zone, rock, "rock") -- Notify User with UI
						end
	
						-- Player mined enough here needs to go to another zone
						if playersMiningTotal[source].zone == zone.id and playersMiningTotal[source].amount >= zone.maxMineAmount then
							-- Todo

							if (playersZonesCompleted[source] == nil) then
								playersZonesCompleted[source] = {}
							end

							table.insert(playersZonesCompleted[source], minedZone.id)

							print("Player is done in this zone move on. " .. playersZonesCompleted[source][1]) -- Notify User with UI
							TriggerClientEvent("np-mining:unassignZone", source)
						end
						
					end
		
				end
	
	
			end
		end
	
	end)


end)

-- Called when the player completed their amount of zones
RegisterServerEvent("np-mining:completedRun")
AddEventHandler("np-mining:completedRun", function(src)
	playersMiningTotal[src] = nil -- Remove how many rocks they mined
	playersZonesCompleted[src] = nil -- Remove them from zones completed so when they strart the job again after a "cooldown" its backto default
	TriggerClientEvent("np-mining:stopMining", src) -- Now lets tell client theyre not assigned a zone and reset their variables
end)

-- Debug event used to generate rock coords
-- RegisterServerEvent("np-mining:genRock")
-- AddEventHandler("np-mining:genRock", function(coords)
-- 	print(coords)
-- 	file = io.open( "12313123" .. "-Coords.txt", "a")
-- 	if file then
-- 	file:write(coords)
-- 	file:write("\n")
-- 	end
-- 	file:close()
-- end)

RegisterServerEvent("np-mining:resetRock")
AddEventHandler("np-mining:resetRock", function()
	resetZoneRocks()
end)
