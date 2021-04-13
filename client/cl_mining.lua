local miningZones = {
  -- zone = BoxZone:Create(vector3(435.18, 2016.35, 110.49), 20, 20, {
  --   name="mining_zone",
  --   heading=340,
  --   debugPoly=true,
  --   minZ=106.69,
  --   maxZ=114.29
  -- }),

  {
    name = "mine_zone2",
    area = BoxZone:Create(vector3(3372.43, 2656.71, -3.14), 44.8, 36.8, {
      name="mine_zone2",
      heading=351,
      debugPoly=true,
      minZ=-2.09,
      maxZ=9.71
    }),
    maxMineAmount = 3
  },

  {
    name = "mine_zone1",
    area = BoxZone:Create(vector3(3413.32, 2725.6, 2.37), 14.6, 10, {
      name="mine_zone1",
      heading=60,
      debugPoly=true
    }),  
    maxMineAmount = 3,
  }
}

local assignedZone = nil
local zonesMined = {}

local miningStatus = ""
local miningStarted = false
local insideMiningZone = false
local isMining = false

Citizen.CreateThread(function()

  while true do
    local playerPed = GetPlayerPed(-1)
    local playerCoord = GetEntityCoords(playerPed)

    -- Show message if theyre currently mining
    if isMining and miningStarted then
      miningStatus = "Currently Mining"
    elseif not isMining and miningStarted then
      miningStatus = "Waiting for player to mine"
    end

    -- Now lets check if theyre assign a zone and trying to mine inside of it
    if assignedZone and miningStarted then
      insideMiningZone = assignedZone.area:isPointInside(playerCoord)

      -- Now if the player is in the zone and clicks their button to mind in my case "E" lets start doing that
      if insideMiningZone and IsControlJustPressed(1, 86) then
        startMiningRock(assignedZone)
      elseif not insideMiningZone then
        miningStatus = "Please enter your assigned mining zone: " .. assignedZone.name
      end
      -- print(insideMiningZone)
    end

    showText(miningStatus)
    Citizen.Wait(1)
  end
  
end)


-- Event Handlers
RegisterNetEvent("np-mining:startMining")
AddEventHandler("np-mining:startMining", function(source)
  if not miningStarted then
    print("Wanting to start mining " .. source)
    TriggerEvent("np-mining:assignZone")
  end
end)


RegisterNetEvent("np-mining:stopMining")
AddEventHandler("np-mining:stopMining", function(source)
  if miningStarted then
    miningStarted = false
    assignedZone = nil
    print("Stopped mining")
  end
end)

RegisterNetEvent("np-mining:collectedRock")
AddEventHandler("np-mining:collectedRock", function(zone)
  isMining = false
  zonesMined[zone.name] = zonesMined[zone.name] + 1

  if (zonesMined[zone.name] == zone.maxMineAmount) then
    print("Completed mining in this zone move on!")
    miningStatus = "Completed mining in this zone move on!"
  end

  Citizen.Wait(1000)
  pickupRock()
end)


-- Used to generate a zone for the "Player" to mine
RegisterNetEvent("np-mining:assignZone")
AddEventHandler("np-mining:assignZone", function(zone)

  if not assignedZone then
    local randomZone = miningZones[math.random(#miningZones)]
    assignedZone = randomZone
    miningStarted = true
    print("You have been assigned to: " .. assignedZone.name)
  end
  
end)


function startMiningRock(zone)
  -- Lets check if we already mined this zone or not to add it
  if not zonesMined[zone.name] then
    zonesMined[zone.name] = 0
    print("Zone hasnt been mined in yet lets set it to zero")
  end

  if zonesMined[zone.name] == zone.maxMineAmount then
    return print("This zone has reached its mine limit for now")
  end

  if isMining then
    return
  end


  isMining = true
  print("starting to mine " .. zone.name)
  
  startMiningAnimation(zone)
end
