local miningZones = {
  -- zone = BoxZone:Create(vector3(435.18, 2016.35, 110.49), 20, 20, {
  --   name="mining_zone",
  --   heading=340,
  --   debugPoly=true,
  --   minZ=106.69,
  --   maxZ=114.29
  -- }),

  {
    area = BoxZone:Create(vector3(3413.32, 2725.6, 2.37), 14.6, 10, {
      name="mining_zone",
      heading=60,
      debugPoly=true
    }),  
    mineableRocks = {
      { id = "rock1", x = 3408.016, y = 2727.448, z = 1.913579 }
    }
  }

}

local recentlyMinedRocks = {}
local miningStatus = ""
local mining = false
local insideMiningZone = false

Citizen.CreateThread(function()
    while true do
        local plyPed = GetPlayerPed(-1)
        local coord = GetEntityCoords(plyPed)
        
        -- Lets loop through all zones and see if we're in one
        for k, zone in pairs(miningZones) do
          insideMiningZone = zone.area:isPointInside(coord)

          if insideMiningZone and mining then
            miningStatus = "Inside mining zone you can start mining now"

            for k, rock in pairs(zone.mineableRocks) do

              -- Lets loop through all the recently done rocks and exclude that one
              local dis = GetDistanceBetweenCoords(coord["x"], coord["y"], coord["z"], rock["x"], rock["y"], rock["z"], false)
              DrawText3Ds(rock["x"], rock["y"], rock["z"], rock.id)
              
              if dis < 2 then
                miningStatus = "Mine meee " .. rock.id
                if IsControlJustPressed(1, 86) then
                  startMiningRock(rock)
                end
              end

              
            end


          else
            miningStatus = "Please enter a mining zone"
          end

        end

        showText(miningStatus)
        Citizen.Wait(1)
    end
end)


-- Event Handlers
RegisterNetEvent("np-mining:startMining")
AddEventHandler("np-mining:startMining", function(source)
  if not mining then
    mining = true
    print("Wanting to start mining " .. source)
  end
end)

RegisterNetEvent("np-mining:collectedRock")
AddEventHandler("np-mining:collectedRock", function(rock)

  recentlyMinedRocks[rock.id] = rock
  print(recentlyMinedRocks[rock.id])
  print("got a call that a rock was done " .. rock.id)  
end)


function startMiningRock(rock)
  if recentlyMinedRocks[rock.id] then
    return print("Rock has already been mined")
  end

  print("starting to mine " .. rock.x)
  startMiningAnimation(rock)
end
