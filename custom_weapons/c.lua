--[[
    Author: maalos/regex
    Discord: maalos
    Disclaimer: all weapon data was sourced from https://armedassault.fandom.com/wiki/ and from the ArmA 2 section
    
    All weapon model/texture/sound sources:
    1547334435_Insurgency MIC Weapons Pack.rar      https://www.gtainside.com/en/sanandreas/weapons/127779-insurgency-modern-infantry-combat-weapons-pack/
    1560243427_WEAPON PACK.rar                      https://www.gtainside.com/en/sanandreas/weapons/133647-silenced-weapon-pack/
    1560897147_Day of Infamy Machine Guns Pack.rar  https://www.gtainside.com/en/sanandreas/weapons/133920-day-of-infamy-machine-guns-pack/
    1569771611_8th Weapons Replacers Minipack.rar   https://www.gtainside.com/en/sanandreas/weapons/137476-8th-weapons-replacers-minipack/
    1577796764_11th weapons replacer minipack.rar   https://www.gtainside.com/en/sanandreas/weapons/140560-11th-weapons-replacers-minipack-russian-modern-weapons-edition/
    1582889548_CS-GO Customs Minipack V1.rar        https://www.gtainside.com/en/sanandreas/weapons/142856-cs-go-customs-weapons-minipack-v1/
    1599721313_17th weapons replacer minipack.rar   https://www.gtainside.com/en/sanandreas/weapons/152590-17th-weapons-replacers-minipack
    1615134912_22th weapons replacers minipack.rar  https://www.gtainside.com/en/sanandreas/weapons/161548-22nd-weapons-replacers-minipack-killing-floor-1-edition/
]]

local blockedTasks = {
	"TASK_SIMPLE_IN_AIR",
	"TASK_SIMPLE_JUMP",
	"TASK_SIMPLE_LAND",
	"TASK_SIMPLE_GO_TO_POINT",
	"TASK_SIMPLE_NAMED_ANIM",
	"TASK_SIMPLE_CAR_OPEN_DOOR_FROM_OUTSIDE",
	"TASK_SIMPLE_CAR_GET_IN",
	"TASK_SIMPLE_CLIMB",
	"TASK_SIMPLE_SWIM",
	"TASK_SIMPLE_HIT_HEAD",
	"TASK_SIMPLE_FALL",
	"TASK_SIMPLE_GET_UP"
}

local allReplacableModels = {1856, 1858, 1859, 1860, 1861, 1862, 1863, 1864, 1865, 1866, 1867, 1868, 1869, 1870, 1871, 1872, 1873, 1874, 1875, 1876, 1877, 1878, 1879, 1880, 1881, 1882, 1899, 1900, 1901, 1902, 1903, 1904, 1905, 1906, 1909, 1911, 1915, 1916, 1921, 1923, 1924, 1930, 1931, 1932, 1933, 1934, 1936, 1938, 1940, 1941, 1947}
local primaryWeapons = {25, 26, 27, 29, 30, 31, 33, 34, 35, 36}
local secondaryWeapons = {22, 23, 24, 28, 32}

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
    [19] = {31, 1932,  "M4A1",             43,     30,     800,    400, "M4A1", {
        [1] = {1941, "M4A1/Handle", "Handle for M4A1 Rail"},
        [2] = {1947, "M4A1/Sight",  "Aimpoint for M4A1 Rail"},
    }},
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
}

function table.contains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
end

addEvent("onClientCreateWeaponSound", true)
addEventHandler("onClientCreateWeaponSound", localPlayer, function(weaponName, noise, x, y, z)
    if not fileExists("custom/" .. weaponName .. "/sound.wav") then return outputDebugString("File not found: custom/" .. weaponName .. "/sound.wav", 2) end
	local sound = playSound3D("custom/" .. weaponName .. "/sound.wav", x, y, z, false)
	setSoundMaxDistance(sound, noise)
end)

function loadCustomWeaponModel(weaponName, modelID)
    engineImportTXD(engineLoadTXD("custom/" .. weaponName .. "/texture.txd"), modelID)
    engineReplaceModel(engineLoadDFF("custom/" .. weaponName .. "/model.dff"), modelID)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    setWorldSoundEnabled(5, false)
    for _, modelID in pairs({346, 347, 348, 349, 350, 351, 352, 353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 342, 343, 1915}) do
        loadCustomWeaponModel("null", modelID)
    end

    for _, weapon in pairs(customWeapons) do
        loadCustomWeaponModel(weapon[3], weapon[2])
        if weapon[9] then
            for _, addon in pairs(weapon[9]) do
                loadCustomWeaponModel(addon[2], addon[1])
            end
        end
    end

    triggerServerEvent("requestUpdateWeaponObjects", localPlayer)
end)

addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weapon, ammo)
	local x, y, z = getPedBonePosition(localPlayer, 26)
    -- local weapon = nil
    -- if table.contains(primaryWeapons, weapon) then
	--     weapon = getElementData(localPlayer, "client.weapon.primary.data")
    -- elseif table.contains(secondaryWeapons, weapon) then
	--     weapon = getElementData(localPlayer, "client.weapon.secondary.data")
    -- end
    if getPedAmmoInClip(localPlayer) < 10 then playSoundFrontEnd(41) end -- click if ammo low
    local weapon = getElementData(localPlayer, "client.weapon.current.data")
    triggerEvent("onClientCreateWeaponSound", localPlayer, weapon[3], 200, x, y, z)
	-- triggerServerEvent("requestCreateWeaponSound", localPlayer, v[5], getWeaponNoise(secondary), x, y, z)
	-- createExplosion(x, y, z+10, 12, false, v[3], false)
    -- local fireDelay = 60 / weapon[6]
	-- toggleControl("fire", false)
	-- toggleControl("action", false)
	-- setTimer(toggleControl, fireDelay, 1, "fire", true)
	-- setTimer(toggleControl, fireDelay, 1, "action", true)
end)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function(prev, curr)
    triggerServerEvent("requestUpdateWeaponObjects", localPlayer, prev, curr)
    -- return cancelEvent()
end)

-- addEventHandler("onClientRender", root, function()
--     if getPedControlState("fire") then
--         setGameSpeed(1.2)
--     else
--         setGameSpeed(1)
--     end
-- end)