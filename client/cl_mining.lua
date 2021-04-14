
local assignedZone = nil
local isInZone = false
local miningStatus = "Waiting to be assigned job"

-- Todo ass player dropcheck and remove rocks they were currently mining if they were

Citizen.CreateThread(function()

  while true do
    Citizen.Wait(1)

    -- For debug only
    if isInZone then
      local playerPed = GetPlayerPed(-1)
      local playerCoords = GetEntityCoords(playerPed)

      for i, rock in pairs(assignedZone.rocks) do

        local rockDist = GetDistanceBetweenCoords(playerCoords, rock.coords)
        if rockDist < 3 then
          if IsControlJustPressed(1, 86) then
            TriggerServerEvent("np-mining:attemptMine", assignedZone, rock)

          end
        end
        DrawText3Ds(rock.coords["x"], rock.coords["y"], rock.coords["z"], rock.id)

      end

    end

    showText(miningStatus)
  end
end)

-- Called when the player gets assigned a zone
RegisterNetEvent("np-mining:assignedZone")
AddEventHandler("np-mining:assignedZone", function(zone)
  zone.area = CircleZone:Create(zone.coords, 73, {
    name=zone.id,
    debugPoly=true,
  })

  zone.area:onPlayerInOut(handlePlayerEntering)

  assignedZone = zone
  miningStatus = "Assigned to zone - " .. zone.id
end)

-- Called when we are mining a valid rock
RegisterNetEvent("np-mining:beginMiningRock")
AddEventHandler("np-mining:beginMiningRock", function(zone, rock)
  startMiningAnimation(zone, GetPlayerPed(-1), rock)
end)

-- Called when we are done breaking the rock and going to collect it
RegisterNetEvent("np-mining:collectRock")
AddEventHandler("np-mining:collectRock", function(zone, rock, reward)
  print("Completed mining I got " .. reward)
end)


function handlePlayerEntering(isPointInside, point)
  
  if assignedZone then
    if isPointInside then
      print("Player entered zone")
      generateRockObjs(assignedZone.rocks)
      isInZone = true
      miningStatus = "Start mining rocks!"
    else
      print("player left zone")
      removeRockObjs(assignedZone.rocks)
      isInZone = false
      miningStatus = "Enter Your assigned mining zone"
    end
  end
  
end

-- Called when player enters a mining zone and needs to generate the rocks to mine
function generateRockObjs(rocks)
  local newRocks = rocks

  for i, rock in pairs(newRocks) do
    local unused, objectZ = GetGroundZFor_3dCoord(rock.coords["x"], rock.coords["y"], 99999.0, 1)
    rock.object = CreateObject(GetHashKey("prop_rock_3_d"), rock.coords["x"], rock.coords["y"], objectZ - 0.2, true, true, false)
    print("Creating rock obj " .. rock.object)
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
