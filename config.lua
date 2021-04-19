Config = {}

Config.zoneLimit = 2 -- Amount of zones a person can do in one "run"
Config.requiredRockHits = 3 -- How many times a rock needs to be hit before its "broken"
Config.rockResetTime = 600 -- Every x time check if rock is mined and reset it (set to 10 minutes atm)
Config.requiredItem = "pickaxe"

Config.miningZones = {
  {
    id = "mining_zone1",
    circleSize = 73,
    rockProp = "prop_rock_3_d", -- The rock object this zone will generate
    coords = vector3(2950.13, 2793.35, 57.64),
    maxMineAmount = 3, -- Max amount of rocks a player can mine in that specific zone
    rocks = {
      { id = "rock1", object = nil, coords = vector3(2940.188, 2823.371, 44.90134), isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock2", object = nil, coords = vector3(2929.267, 2819.22, 46.85793) , isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock3", object = nil, coords = vector3(2941.953, 2795.005, 40.58472), isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock4", object = nil, coords = vector3(2932.202, 2780.675, 39.45383), isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock5", object = nil, coords = vector3(2921.778, 2793.148, 40.58374), isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock6", object = nil, coords = vector3(2923.443, 2810.052, 43.59846), isBeingMined = false, isMined = false, beingMinedBy = nil },
    },
  },


  {
    id = "mining_zone2", 
    circleSize = 70,
    rockProp = "prop_rock_3_d", -- The rock object this zone will generate
    coords = vector3(3871.44, 4318.67, 37.88),
    maxMineAmount = 3, -- Max amount of rocks a player can mine in that specific zone
    rocks = {
      { id = "rock1", object = nil, coords = vector3(3855.605, 4309.54, 7.006189)  , isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock2", object = nil, coords = vector3(3860.192, 4327.518, 6.86809)  , isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock3", object = nil, coords = vector3(3875.133, 4336.193, 5.48465)  , isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock4", object = nil, coords = vector3(3862.983, 4339.59, 6.727458)  , isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock5", object = nil, coords = vector3(3860.838, 4333.495, 6.871947) , isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock6", object = nil, coords = vector3(3880.217, 4333.809, 4.191401) , isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock7", object = nil, coords = vector3(3884.529, 4329.157, 3.274573) , isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock8", object = nil, coords = vector3(3890.268, 4340.202, 3.356206) , isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock9", object = nil, coords = vector3(3886.747, 4348.654, 5.457541) , isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock10", object = nil, coords = vector3(3858.857, 4320.858, 7.456657), isBeingMined = false, isMined = false, beingMinedBy = nil },
      { id = "rock11", object = nil, coords = vector3(3855.625, 4314.179, 7.057076), isBeingMined = false, isMined = false, beingMinedBy = nil },
    },
  }

  


}
