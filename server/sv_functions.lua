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