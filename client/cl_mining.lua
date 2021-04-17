
local assignedZone = nil
local isInZone = false
local miningStatus = "Waiting to be assigned job"
local isCurrentlyMining = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    -- For debug only
    if isInZone and assignedZone then
      if IsControlJustPressed(1, 86) then 
        attempToMineRock()
      end
    end

    showText(miningStatus)
  end
end)

function attempToMineRock()
  local ped = PlayerPedId()
  local playerCoord = GetEntityCoords(ped)
  local target = GetOffsetFromEntityInWorldCoords(ped, vector3(0,2,-3))
  local testRay = CastRayPointToPoint(playerCoord, target, 17, ped, 7)
  local _, hit, hitLocation, surfaceNormal, rockObj, _ = GetRaycastResult(testRay)

  for _, rock in pairs(assignedZone.rocks) do
    if rock.object == rockObj then
      TriggerServerEvent("np-mining:attemptMine", assignedZone, rock)
    end
      
  end

end

-- Called when the player gets assigned a zone
RegisterNetEvent("np-mining:assignedZone")
AddEventHandler("np-mining:assignedZone", function(zone)
  zone.area = CircleZone:Create(zone.coords, zone.circleSize, {
    name=zone.id,
    debugPoly=true,
  })

  zone.area:onPlayerInOut(handlePlayerEntering)

  assignedZone = zone
  miningStatus = "Assigned to zone - " .. zone.id
  print("You have been assigned to a new zone " .. zone.id)
end)

-- Called when the player gets assigned a zone
RegisterNetEvent("np-mining:unassignZone")
AddEventHandler("np-mining:unassignZone", function(zone)
  Citizen.CreateThread(function()
    miningStatus = "Looking for a new zone"
    assignedZone.area:destroy()
    assignedZone = nil
    isInZone = false
    print("UNassigned zone")
    Citizen.Wait(5000)
    TriggerServerEvent("np-mining:assignZone")
  end)
end)

-- Called when we are mining a valid rock
RegisterNetEvent("np-mining:beginMiningRock")
AddEventHandler("np-mining:beginMiningRock", function(zone, rock, hitsNeeded, source)
  isCurrentlyMining = true
  startMiningAnimation(zone, GetPlayerPed(-1), rock, hitsNeeded, source)
end)

-- Called when we are done breaking the rock and going to collect it
RegisterNetEvent("np-mining:collectRock")
AddEventHandler("np-mining:collectRock", function(zone, rock, reward)
  print("Completed mining I got " .. reward)
  isCurrentlyMining = false
end)

-- Called when user wants to stop
RegisterNetEvent("np-mining:stopMining")
AddEventHandler("np-mining:stopMining", function(zone, rock)

  if assignedZone ~= nil then
    assignedZone.area:destroy() -- Lets delete poly zone now
  end

  assignedZone = nil
  miningStatus = "Not currently mining"
  isInZone = false
  isCurrentlyMining = false
end)


function handlePlayerEntering(isPointInside, point)
  
  if assignedZone then
    if isPointInside then
      print("Player entered zone")
      generateRockObjs(assignedZone.rocks, assignedZone.rock_prop)
      isInZone = true
      miningStatus = "Start mining rocks!"
    else
      print("player left zone")
      removeRockObjs(assignedZone.rocks)
      isInZone = false
      miningStatus = "Enter Your assigned mining zone - " .. assignedZone.id
    end
  end
  
end

-- Called when player enters a mining zone and needs to generate the rocks to mine
function generateRockObjs(rocks, prop)
  local newRocks = rocks

  for i, rock in pairs(newRocks) do
    local unused, objectZ = GetGroundZFor_3dCoord(rock.coords["x"], rock.coords["y"], 99999.0, 1)
    rock.object = CreateObject(GetHashKey(prop), rock.coords["x"], rock.coords["y"], objectZ - 0.2, false, true, false)
    FreezeEntityPosition(rock.object, true)
    -- Maybe you want to create a PolyZone here so that you can "peak" to start mining
  end

  assignedZone.rocks = newRocks
end

-- Used to remove rock objs when the player leaves the zone
function removeRockObjs(rocks)

  for i, rock in pairs(rocks) do

    if rock.object ~= nil then
      DetachEntity(rock.object, 1, true)
      DeleteEntity(rock.object)
      DeleteObject(rock.object)
    end
    
  end
  
end
