-- local miningZones = {
--   {
--     name = "mining_zone3",
--     area = CircleZone:Create(vector3(2950.13, 2793.35, 57.64), 72.329999999999, {
--       name="mining_zone3",
--       useZ=true,
--       debugPoly=true
--     }),
--     maxMineAmount = 3,
--     rocks = {
--       { object = nil, coords = vector3(2940.188, 2823.371, 44.90134), isBeingMined = false, mined = false },
--       { object = nil, coords = vector3(2929.267, 2819.22, 46.85793) , isBeingMined = false, mined = false },
--       { object = nil, coords = vector3(2941.953, 2795.005, 40.58472), isBeingMined = false, mined = false },
--       { object = nil, coords = vector3(2932.202, 2780.675, 39.45383), isBeingMined = false, mined = false },
--       { object = nil, coords = vector3(2921.778, 2793.148, 40.58374), isBeingMined = false, mined = false },
--       { object = nil, coords = vector3(2923.443, 2810.052, 43.59846), isBeingMined = false, mined = false },
--     }
--   },
-- }

local playersMiningTotal = {}

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
	local randomZone = Config.mining_zones[math.random(#Config.mining_zones)]
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
					print("Rock has already been mined")
				elseif rock.isBeingMined then
					print("Rock is currently being mined")
				else

					-- Lets check if the player hit max amount of rocks
					if playersMiningTotal[source] == nil then
						playersMiningTotal[source] = 1
					elseif playersMiningTotal[source] >= zone.maxMineAmount then
						print("Cant mine this you're already done the amount in this zone")
						return 
					else
						playersMiningTotal[source] = playersMiningTotal[source] + 1
					end

					print("Starting to mine rock " .. playersMiningTotal[source])
					rock.isBeingMined = true
					rock.beingMinedBy = source
					TriggerClientEvent("np-mining:beginMiningRock", source, zone, rock)
				end

			end

		end

	end

end)

-- Called when player is done mining the rock
RegisterServerEvent("np-mining:completedMining")
AddEventHandler("np-mining:completedMining", function(minedZone, minedRock)

	for _, zone in pairs(Config.mining_zones) do

		if minedZone.id == zone.id then

			for _, rock in pairs(zone.rocks) do
	
				if rock.id == minedRock.id then
					rock.isBeingMined = false
					rock.isMined = true
		
					-- Figure out what they got
					local chance = math.random(0, 100)
		
					if chance < 50 then
						TriggerClientEvent("np-mining:collectRock", source, zone, rock, "gem")
					else
						TriggerClientEvent("np-mining:collectRock", source, zone, rock, "rock")
					end

					-- Player mined enough here needs to go to another zone
					if playersMiningTotal[source] >= zone.maxMineAmount then
						-- Todo
						print("Player is done in this zone move on.")
					end
					
				end
	
			end


		end
	end

end)