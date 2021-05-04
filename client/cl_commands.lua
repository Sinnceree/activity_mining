-- Call event to assign you a mining zone
RegisterCommand("startmining", function(source, args)
  local canDoActivity = false
  local playerServerId = GetPlayerServerId(PlayerId())

  if Config.enableNopixelExports then
    canDoActivity = exports["np-activities"]:canDoActivity("activity_mining", playerServerId)
  else
    canDoActivity = true
  end

  if canDoActivity then
    TriggerServerEvent("np-mining:assignZone")
  else
    sendNotification("You cant do this actvity at this time.", playerServerId)
  end


end, false)

-- Call event to remove you from mining job
RegisterCommand("stopmining", function(source, args)
  BoxZone:Create(vector3(594.79, -2803.04, 6.06), 7.6, 22.8, {
    name="trailer_fill_zone",
    heading=59,
    -- debugPoly=true,
    minZ=4.06,
    maxZ=10.06
  })
end, false)


-- This is was here for testing to give me a pickaxe to mine (can remove this)
-- RegisterCommand("givepickaxe", function(source, args)
--   local playerServerId = GetPlayerServerId(PlayerId())
--   exports["np-activities"]:giveInventoryItem(playerServerId, Config.requiredItem, 5)
--   sendNotification("Gae item", playerServerId)
-- end, false)

-- RegisterCommand("genrock", function(source, args)
--   local playerPed = GetPlayerPed(-1)
--   TriggerServerEvent("np-mining:genRock", GetEntityCoords(playerPed))
-- end, false)


-- Make some variables for the particle dictionary and particle name.
local dict = "core"
local particleName = "ent_ray_finale_vault_sparks"


RegisterCommand("parti", function(source, args)
  -- Create a new thread.
  Citizen.CreateThread(function()
    -- Request the particle dictionary.
    RequestNamedPtfxAsset(dict)
    -- Wait for the particle dictionary to load.
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    
    -- Get the position of the player, this will be used as the
    -- starting position of the particle effects.
    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped, true))

    print("trying to show particle")
    local a = 0
    while a < 25 do
        -- Tell the game that we want to use a specific dictionary for the next particle native.
        UseParticleFxAssetNextCall(dict)
        -- Create a new non-looped particle effect, we don't need to store the particle handle because it will
        -- automatically get destroyed once the particle has finished it's animation (it's non-looped).
        StartParticleFxNonLoopedAtCoord(particleName, x, y + 5.0, z + 1.0, 0.0, 0.0, 0.0, 0.2, false, false, false)
    
        a = a + 1
        
        -- Wait 500ms before triggering the next particle.
        Citizen.Wait(500)
    end
  end)
end, false)
