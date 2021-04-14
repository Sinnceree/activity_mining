function ZoneMinedRecently(targetZone, playerMinedZones, source)
  if playerMinedZones ~= nil then
		for _, zone in pairs(playerMinedZones) do
			if zone == targetZone.id then
				return true
			end
		end

  else
    return false
	end

  return false
end


function resetZoneRocks()
	print("Checking if any rocks need to be reset...")
	for _, zone in pairs(Config.mining_zones) do
		for _, rock in pairs(zone.rocks) do

			if not rock.isBeingMined and rock.isMined then
				rock.isMined = false
				rock.beingMinedBy = nil
			end

		end
	end
end
