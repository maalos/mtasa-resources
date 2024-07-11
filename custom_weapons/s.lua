--[[
    Author: maalos/regex
    Discord: maalos
    Disclaimer: all weapon data was sourced from https://armedassault.fandom.com/wiki/ and from the ArmA 2 section
]]

local defaultWeaponData = {
    [0]  = {"Fist", 0},
    [1]  = {"Brassknuckle", 331},
    [2]  = {"Golfclub", 333},
    [3]  = {"Nightstick", 334},
    [4]  = {"Knife", 335},
    [5]  = {"Bat", 336},
    [6]  = {"Shovel", 337},
    [7]  = {"Poolstick", 338},
    [8]  = {"Katana", 339},
    [9]  = {"Chainsaw", 341},
    [22] = {"Colt 45", 346},
    [23] = {"Silenced", 347},
    [24] = {"Deagle", 348},
    [25] = {"Shotgun", 349},
    [26] = {"Sawed-off", 350},
    [27] = {"Combat Shotgun", 351},
    [28] = {"Uzi", 352},
    [29] = {"MP5", 353},
    [32] = {"Tec-9", 372},
    [30] = {"AK-47", 355},
    [31] = {"M4", 356},
    [33] = {"Rifle", 357},
    [34] = {"Sniper", 358},
    [35] = {"Rocket Launcher", 359},
    [36] = {"Rocket Launcher HS", 360},
    [37] = {"Flamethrower", 361},
    [38] = {"Minigun", 362},
    [16] = {"Grenade", 342},
    [17] = {"Teargas", 343},
    [18] = {"Molotov", 344},
    [39] = {"Satchel", 363},
    [41] = {"Spraycan", 365},
    [42] = {"Fire Extinguisher", 366},
    [43] = {"Camera", 367},
    [10] = {"Dildo", 321},
    [11] = {"Dildo", 322},
    [12] = {"Vibrator", 323},
    [14] = {"Flower", 325},
    [15] = {"Cane", 326},
    [44] = {"Nightvision", 368},
    [45] = {"Infrared", 369},
    [46] = {"Parachute", 371},
    [40] = {"Bomb", 364}
}

function getWeaponNameFromId(weaponId)  return defaultWeaponData[weaponId][1] end
function getWeaponModelFromId(weaponId) return defaultWeaponData[weaponId][2] end

local holsterWeaponIds = {28, 22, 23, 24}
local backWeaponIds = {25, 26, 27, 29, 30, 31, 33, 34, 35, 36, 37, 38}
local allReplacableModels = {1856, 1858, 1859, 1860, 1861, 1862, 1863, 1864, 1865, 1866, 1867, 1868, 1869, 1870, 1871, 1872, 1873, 1874, 1875, 1876, 1877, 1878, 1879, 1880, 1881, 1882, 1899, 1900, 1901, 1902, 1903, 1904, 1905, 1906, 1909, 1911, 1915, 1916, 1921, 1923, 1924, 1930, 1931, 1932, 1933, 1934, 1936, 1938, 1940, 1941, 1947}

local customWeapons = {
--  {wID, mID,  "name",             aID,    clip,   rpm,    eR,  "fullName"} -- weapon ID, model ID, ammo ID, effectiveRange
    [0]  = {0,  1915,  "null",             36,     0,      0,      0,   "Null/Hand"},
    -- Sniper Rifles
    [1]  = {34, 1872,  "M82A3",            15,     10,     60,     150, "Barrett M82A3"},
    [2]  = {34, 1899,  "SVD",              26,     10,     300,    800, "Dragunov SVD"},
    [3]  = {34, 1931,  "L42A1",            42,     10,     60,     800, "L42A1"},
    [4]  = {34, 1909,  "M24",              34,     5,      80,     500, "M24"},
    [5]  = {34, 1900,  "AMR-2",            27,     5,      60,     800, "AMR-2"},

    -- Russian Assault Rifles
    [6]  = {30, 1863,  "RPK-47",           6,      75,     600,    400, "Kalashnikov RPK-47"},
    [7]  = {30, 1864,  "AEK-971",          7,      30,     900,    400, "AEK-971"},
    [8]  = {30, 1869,  "AK-47",            12,     30,     600,    300, "AK-47"},
    [9]  = {30, 1873,  "SKS",              16,     10,     600,    400, "SKS"},
    [10] = {30, 1874,  "AKM",              17,     30,     600,    300, "AKM"},
    [11] = {30, 1879,  "AKS-74U",          22,     30,     700,    200, "AKS-74U"},

    -- Rifles
    [12] = {33, 1861,  "M14",              4,      20,     700,    500, "M14"},
    [13] = {33, 1906,  "Kar98K",           33,     5,      50,     500, "Karabiner 98k"},
    [14] = {33, 1930,  "FG-42",            41,     20,     900,    500, "FG 42"},

    -- American/Other Assault Rifles
    [15] = {31, 1866,  "M16A4",            9,      30,     800,    400, "M16A4"},
    [16] = {31, 1870,  "Galil-ACE-21",     13,     35,     700,    300, "IWI Galil ACE 21"},
    [17] = {31, 1859,  "ACR",              2,      30,     750,    350, "Bushmaster ACR"},
    [18] = {31, 1880,  "HCAR-Extended",    23,     20,     600,    500, "FN HCAR Extended"},
    [19] = {31, 1932,  "M4A1",             43,     30,     800,    400, "M4A1"},
    [20] = {31, 1934,  "FN-FAL",           45,     20,     700,    400, "FN FAL"},

    -- Pistols
    [21] = {22, 1860,  "FN-Five-Seven",    3,      20,     600,    50,  "FN Five-Seven"},
    [22] = {22, 1875,  "Glock-18C",        18,     17,     1200,   50,  "Glock 18C"},
    [23] = {22, 1877,  "M9",               20,     15,     600,    50,  "Beretta M9"},
    [24] = {22, 1881,  "M1911",            24,     7,      500,    50,  "Colt M1911"},
    [25] = {22, 1905,  "AP",               32,     1,      0,      50,  "Automatic Pistol"},
    [26] = {22, 1911,  "Makarov",          35,     8,      600,    50,  "Makarov"},
    [27] = {23, 1865,  "GSh-18-S",         8,      17,     1200,   50,  "GSh-18 Suppressed"},
    [28] = {24, 1868,  "SaW-29",           11,     6,      240,    100, "Smith & Wesson Model 29"},

    -- Grenades
    [29] = {16, 1867,  "M67",              10,     1,      0,      50,  "M67 Grenade"},
    [30] = {16, 1933,  "RGD-5",            44,     1,      0,      50,  "RGD-5 Grenade"},
    [31] = {17, 1871,  "M18",              14,     7,      1200,   50,  "M18 Smoke Grenade"},

    -- Machine Guns
    [32] = {38, 1862,  "M60",              5,      100,    600,    800, "M60"},
    [33] = {38, 1882,  "MG-42",            25,     50,     1200,   800, "MG42"},
    [34] = {38, 1923,  "M249",             39,     100,    800,    800, "M249"},

    -- Shotguns
    [35] = {25, 1876,  "M1897",            19,     5,      70,     50,  "Winchester Model 1897"},
    [39] = {25, 1904,  "TOZ-87",           31,     2,      60,     50,  "TOZ-87"},
    [38] = {26, 1901,  "Heavy-Shotgun",    28,     5,      120,    80,  "Heavy Shotgun"},
    [36] = {27, 1878,  "SPAS-12",          21,     8,      120,    80,  "Franchi SPAS-12"}, -- to change, the model is more like a remington lol
    [37] = {27, 1936,  "M1014",            46,     7,      150,    80,  "Benelli M1014"},
    [40] = {27, 1921,  "Kel-Tec-KSG",      38,     14,     120,    50,  "Kel-Tec KSG"},

    -- Submachine Guns
    [43] = {28, 1916,  "CBJ-MS",           37,     30,     900,    200, "CBJ-MS"},
    [44] = {28, 1924,  "Micro-UZI",        40,     25,     800,    100, "Micro UZI"},
    [42] = {29, 1903,  "MP5",              30,     30,     800,    200, "MP5"},
    [41] = {32, 1902,  "M1928",            29,     50,     600,    400, "Thompson M1928"},

    -- Other
    [45] = {35, 1940,  "RPG-7",            48,      1,      0,     50, "RPG-7"},
    [69] = {31, 1941,  "Rail-Handle",       0,      0,      0,      0, "Handle for M4A1 Rail"},
    [70] = {31, 1947,  "Rail-Sight",        0,      0,      0,      0, "Aimpoint for M4A1 Rail"},
}

local customAmmo = {
--  {"name",   "caliber",  bD, iV} -- baseDamage, initialVelocity in m/s
    {"STANAG", "5.56×45",  8,  930}, -- m4, m16 families
    {"5.45mm", "5.45×39",  8,  900}, -- ak-74
}

local slots = {"current", "addon", "holster", "back", "special"}

-------------------------------- default weapon functions

function setWeaponFiringDelay(weapon, skill, value)
    if not weapon or not skill then return false end
    if not value then value = getOriginalWeaponProperty(weapon, skill, "anim_loop_stop") end
    if value < 0.23 then outputDebugString("Value passed to setWeaponFiringDelay might cause gun jamming and similar inconveniences", 2) end
    setWeaponProperty(weapon, skill, "anim_loop_stop",  value)
    setWeaponProperty(weapon, skill, "anim2_loop_stop", value)
end

-------------------------------- custom weapon data functions

function getCWData(player, slot)
    if not player or not slot then return false end
    if slot == "all" then
        return {
            {"current", getElementData(player, "client.weapon.current.data")},
            {"addon", getElementData(player, "client.weapon.addon.data")},
            {"holster", getElementData(player, "client.weapon.holster.data")},
            {"back",    getElementData(player, "client.weapon.back.data")},
            {"special", getElementData(player, "client.weapon.special.data")},
        }
    end
    return getElementData(player, "client.weapon." .. slot .. ".data")
end

function setCWData(player, slot, value)
    if not player or not slot then return false end
    return setElementData(player, "client.weapon." .. slot .. ".data", value)
end

function removeCWData(player, slot)
    if not player or not slot then return false end
    if slot == "all" then
        for _, slot in ipairs(slots) do
            removeElementData(player, "client.weapon." .. slot .. ".data")
        end
        return true
    end
    return removeElementData(player, "client.weapon." .. slot .. ".data")
end

function clearAllPlayerCWRelatedStuff(p)
    for _, v in ipairs(slots) do
        if getCWData(p, v) then removeCWData(p, v) end
        if getCWObject(p, v) then destroyCWObject(p, v) end
    end
end

-------------------------------- custom weapon object functions

function getCWObject(player, slot)
    if not player or not slot then return false end
    if slot == "all" then
        return {
            {"current", getElementData(player, "client.weapon.current.object")},
            {"addon", getElementData(player, "client.weapon.addon.object")},
            {"holster", getElementData(player, "client.weapon.holster.object")},
            {"back",    getElementData(player, "client.weapon.back.object")},
            {"special", getElementData(player, "client.weapon.special.object")},
        }
    end
    return getElementData(player, "client.weapon." .. slot .. ".object")
end

function createCWObject(player, slot, modelId)
    if not player or not slot then return false end
    if getCWObject(player, slot) then destroyCWObject(player, slot) end -- overwrite
    local weapObj = createObject(modelId, 0, 0, 0)
    if not weapObj then return outputDebugString("createCWObject failed: modelId == " .. modelId, 1) end
    if slot == "back" then
        exports.pAttach:attach(weapObj, player, "backpack", -0.3, -0.15, -0.1, 0, 0, 0)
    elseif slot == "holster" then
        exports.pAttach:attach(weapObj, player, 51, -0.1, -0.05, 0.15, -90, 0, 0) -- -0.1, -0.05, 0.07
    elseif slot == "special" then
        exports.pAttach:attach(weapObj, player, 21, 0, -0.1, 0.2, 180, 0, 0) -- 41, -0.1, -0.05, -0.12, -90, -90, 0
    elseif slot == "current" or slot == "addon" then
        exports.pAttach:attach(weapObj, player, 24, 0, 0, 0, 180, 180, 180)
    end
    setElementData(player, "client.weapon." .. slot .. ".object", weapObj)
    return weapObj
end

function destroyCWObject(player, slot)
    if not player or not slot then return false end
    local weaponObject = getCWObject(player, slot)
    if not isElement(weaponObject) then return false end
    return destroyElement(weaponObject)
    -- removeCWData(player, slot)
end

function destroyAllCWObjects(player)
    for _, slot in ipairs(slots) do
        destroyCWObject(player, slot)
    end
end

function giveCustomWeapon(player, cwId, slot, ammo)
    if not player or not slot or not cwId or not isElement(player) then return false end
    if not ammo then ammo = 90 end
    if slot == "current" then setAsCurrent = true else setAsCurrent = false end
    setCWData(player, slot, customWeapons[cwId])
    giveWeapon(player, customWeapons[cwId][1], 90, setAsCurrent)
    createCWObject(player, slot, customWeapons[cwId][2])
end

function getCWFromPlayerWeapon(player, slot)
    for _, customWeaponSlot in ipairs(getCWData(player, "all")) do
        if customWeaponSlot[2] then
            if customWeaponSlot[2][1] == getPedWeapon(player, slot) then return customWeaponSlot[2] end
        end
    end
    return {0, 1915, false}
end

-------------------------------- utils

function table.contains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
end

function table.subtract(t1, t2)
    local t = {}
    for i = 1, #t1 do
      t[t1[i]] = true;
    end
    for i = #t2, 1, -1 do
      if t[t2[i]] then
        table.remove(t2, i);
      end
    end
  end
  

function getPedWeapons(ped)
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=2,9 do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end

function getWeaponFromModelId(modelId)
    for _, v in ipairs(customWeapons) do
        if v[2] == modelId then return v end
    end
    return false
end

function getWeaponModelFromId(id)
    if customWeapons[id] then return customWeapons[id][2] end
    return false
end

function getFreeCustomModelIds()
    local takenCustomModelIds = {}
    local allCustomModelIds = allReplacableModels
    for _, v in ipairs(customWeapons) do
        table.insert(takenCustomModelIds, v[2])
    end
    table.sort(takenCustomModelIds)
    table.sort(allCustomModelIds)
    table.subtract(takenCustomModelIds, allCustomModelIds)
    return allCustomModelIds
end

-------------------------------- mechanics

local customWeaponCount = 0
for i, weapon in pairs(customWeapons) do
    createObject(weapon[2], -1339, -168 + (i / 2), 15)
    customWeaponCount = customWeaponCount + 1
end
outputDebugString("custom_weapons: Loaded " .. customWeaponCount .. " custom weapons!")

addEventHandler("onPlayerWasted", root, function()
    destroyAllCWObjects(source)
    removeCWData(source, "all")
    for _, slot in ipairs(slots) do
        local customWeaponData = getCWData(source, slot)
        if not customWeaponData then customWeaponData = {0, 1915} end -- null weapon
        createCWObject(source, slot, customWeaponData[2])
    end
end)

addEvent("requestUpdateWeaponObjects", true)
addEventHandler("requestUpdateWeaponObjects", root, function(prev, curr)
    for _, slot in ipairs(slots) do
        if not getCWData(source, slot) then setCWData(source, slot, {0, 1915, false}) end
    end

    destroyAllCWObjects(source)

    local currentWeaponData = getCWFromPlayerWeapon(source, curr)
    local previousWeaponData = getCWFromPlayerWeapon(source, prev)

    if previousWeaponData ~= 0 and previousWeaponData[3] ~= false then
        if table.contains(holsterWeaponIds, previousWeaponData[1]) then
            setCWData(source, "holster", previousWeaponData)
        elseif table.contains(backWeaponIds, previousWeaponData[1]) then
            setCWData(source, "back", previousWeaponData)
        else
            setCWData(source, "special", previousWeaponData)
        end
    end
    setCWData(source, "current", currentWeaponData)
    local currentWeaponModel = getCWData(source, "current")[2]
    if currentWeaponModel == getCWData(source, "holster")[2] then
        removeCWData(source, "holster")
    end
    if currentWeaponModel == getCWData(source, "back")[2] then
        removeCWData(source, "back")
    end
    if currentWeaponModel == getCWData(source, "special")[2] then
        removeCWData(source, "special")
    end

    for _, slot in ipairs(slots) do
        local customWeaponData = getCWData(source, slot)
        if not customWeaponData then customWeaponData = {0, 1915} end -- null weapon
        createCWObject(source, slot, customWeaponData[2])
    end
 
    if currentWeaponModel == getWeaponModelFromId(19) then -- m4
        createCWObject(source, "addon", 1947) -- 1941 - handle, 1947 - sight
    end
end)

-- anim_loop_stop @ 0.314 == 6s 300ms
-- minimal value without "jamming" is 0.23
-- anim_loop_stop @ 0.23 == 2s 320ms

addCommandHandler("loadout", function(p)
    clearAllPlayerCWRelatedStuff(p)

    takeAllWeapons(p)
    destroyAllCWObjects(p)

    giveCustomWeapon(p, 19, "current", 90)
    giveCustomWeapon(p, 23, "holster", 34)
    giveCustomWeapon(p, 30, "special", 2)
end)