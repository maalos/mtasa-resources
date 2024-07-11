--[[
    COPYRIGHT NOTICE
    DATE: XX/01/2024

    AUTHOR: maalos/regex/soczek
    CONTACT: discord:maalos:339395111895040003

    THIS SCRIPT IS A PART OF OPEN-SOURCED RESOURCE ARCHIVE WRITTEN BY maalos, FREE TO USE, MODIFY
]]

function reportMyselfHandler(reason)
    if config.whitelistedSerials[getPlayerSerial(client)] then return end
    --iprint("reported", client) -- even though the source is localPlayer as in triggerServerEvent("reportMyself", localPlayer) it may get misused, so let's use the trusted global client variable
    logEvent(MISC_CHEATING, "reportMyself " .. reason, client)
    punish(client, config.events.action, reason)
    cancelEvent()
end
addEvent("reportMyself", true)
addEventHandler("reportMyself", root, reportMyselfHandler)

local clickTimes = {}

addEventHandler("onPlayerClick", root, function(mouse, state)
    if state == "down" then
        local now = getTickCount()
        clickTimes[source] = {now, unpack(clickTimes[source] or {})}
        while #clickTimes[source] > 0 and clickTimes[source][#clickTimes[source]] + 1000 < now do
            table.remove(clickTimes[source], #clickTimes[source])
        end
        if #clickTimes[source] > config.auto_clicker.max_cps then
            logEvent(GENERAL, "onPlayerClick autoclicking/GUIspam by client (cps: " .. (#clickTimes[source] or "unknown") .. ")", source)
            punish(source, config.auto_clicker.action, "Autoclicking/GUI event spam.")
            cancelEvent()
        end
    end
end)

addEventHandler("onWeaponFire", root, function()
    if not source then return end

    logEvent(EVENT_HACKING, "onWeaponFire unjustified weapon fire by client", source)
    punish(source, config.events.action, "Firing a custom weapon.")
    cancelEvent()
end)

addEventHandler("onSettingChange", root, function(setting, oldValue, newValue)
    logEvent(GENERAL, "onSettingChange " .. setting .. ": " .. oldValue .. " -> " .. newValue, nil)
end)

addEventHandler("onExplosion", root, function(_, _, _, expType)
    -- i think we can leave this as is since we have projectile handling either way
end)

addEventHandler("onPlayerWeaponFire", root, function(weapon)
    if getPedWeapon(source) == weapon then
        if getPedAmmoInClip(source) < 1 then
            logEvent(EVENT_HACKING, "onPlayerWeaponFire unjustified weapon ammunition glitching (weapon: " .. (weapon or "unknown") .. ", ammo: " .. (getPedAmmoInClip(source) or "unknown") .. ")", source)
            punish(source, config.events.action, "Weapon clip ammunition glitching.")
            cancelEvent()
        end
    else
        logEvent(EVENT_HACKING, "onPlayerWeaponFire unjustified weapon fire without the fired weapon (weapon: " .. (weapon or "unknown") .. ")", source)
        punish(source, config.events.action, "Weapon fire without the fired weapon.")
        cancelEvent()
    end
end)

addEventHandler("onPlayerWeaponSwitch", root, function(prevId, currId)
    if config.weapons.check_for_flag == DISABLED then return end
    local hadCurrentWeapon = false
    
    local weapons = getPedWeapons(source)
    table.insert(weapons, 0)
    
    for _, weapon in ipairs(weapons) do
        if weapon == currId then
            hadCurrentWeapon = true
            break
        end
    end

    if not hadCurrentWeapon then
        if getElementData(source, "ji.flag.allowWeaponUpdate") then
            setElementData(source, "ji.flag.allowWeaponUpdate", false) -- lucky once
            return -- don't do anything if we had permission to do so from the server
        end

        logEvent(EVENT_HACKING, "onPlayerWeaponSwitch unjustified weapon give (prevId: " .. (prevId or "unknown") .. ", currId: " .. (currId or "unknown") .. ")", source)
        punish(source, config.events.action, "Unjustified weapon give action.")
        cancelEvent()
    end
end)

local projectiles = {
    [16] = 'Grenade',
    [17] = 'Tear Gas Grenade',
    [18] = 'Molotov',
    [19] = 'Rocket (simple)',
    [20] = 'Rocket (heat seeking)',
    [21] = 'Air Bomb',
    [39] = 'Satchel Charge',
    [58] = 'Hydra flare'
}

local weaponProjectiles = {
    [35] = {19},
    [36] = {19, 20},
}

local modelsWithWeapons = {
    [432] = true,
    [520] = true,
    [425] = true,
}

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

function doesPlayerHaveTheProjectileSource(player, projectileType)
    for _, weapon in ipairs(getPedWeapons(player)) do
        if weapon == projectileType or (weaponProjectiles[weapon] and (projectileType == weaponProjectiles[weapon][1] or projectileType == weaponProjectiles[weapon][2])) then return true end
    end

    return false
end

addEventHandler("onPlayerProjectileCreation", root, function(weaponType)
    if not config.events.explosions.check_projectile_creators then return end

    local vehicle = getPedOccupiedVehicle(source)
    
    if vehicle then
        if modelsWithWeapons[getElementModel(vehicle)] then return end
    end

    if doesPlayerHaveTheProjectileSource(source, weaponType) then return end

    logEvent(EVENT_HACKING, "onPlayerProjectileCreation unjustified creation (" .. (weaponType or "unknown") .. ")", source)
    punish(source, config.events.explosions.action, "Created a projectile without the use of a parent weapon.")
    cancelEvent()
end)

--[[ ===================== THIS MIGHT BE A LITTLE ANNOYING ON AN RP SERVER, BUT MIGHT DEAL WITH SOME LAG BASED INTERACTION BUGS, LIKE IN DayZ
addEventHandler("onPlayerNetworkStatus", root, function(status, ticks)
    if status == 0 and ticks > 100 then
        setElementFrozen(player, true)
        toggleAllControls(player, false)
        setElementData(player, "highping", true)
    else
        setElementFrozen(player, false)
        toggleAllControls(player, true)
        setElementData(player, "highping", false)
    end
end)
]]

addEventHandler("onPlayerDetonateSatchels", root, function()
    if getPedWeapon(source) ~= 40 and config.events.explosions.check_satchel_detonator_ownage then
        cancelEvent()
    end
end)

local weapons = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 22, 23, 24, 25, 26, 27, 28, 29, 32, 30, 31, 33, 34, 35, 36, 37, 38, 16, 17, 18, 39, 41, 42, 43, 10, 11, 12, 14, 15, 44, 45, 46, 40}

function isDamageJustified(victim, attacker, damage_cause)
    if not config.events.damage.check_damage_justification then return true end

    if not attacker or not isElement(damage_cause) then return true end

    if damage_cause == 51 or projectiles[damage_cause] then return true end -- vehicle explosion or projectile

    if getSlotFromWeapon(damage_cause) == 8 and (getPedWeaponSlot(attacker) == 0 or getPedWeaponSlot(attacker) == 12) then return true end -- exploded satchel with a detonator, switched to hand or still has the detonator if he blew himself up

    if getPedAmmoInClip(attacker) < 1 then return false end

    if getPedWeaponSlot(attacker) ~= getSlotFromWeapon(damage_cause) then return false end

    return true
end

addEventHandler("onPlayerDamage", root, function(attacker, damage_cause)
    if not isDamageJustified(source, attacker, damage_cause) then
        if not isElement(attacker) then cancelEvent() end
        logEvent(EVENT_HACKING, "onPlayerDamage unjustified damage (" .. (damage_cause or "unknown") .. ") dealt to " .. getPlayerName(source), attacker)
        punish(attacker, config.events.damage.action, "Dealt unjustified damage.")
        cancelEvent()
    end
end)

addEventHandler("onPlayerWasted", root, function(_, attacker, damage_cause, bodypart)
    if not isDamageJustified(source, attacker, damage_cause) then
        if not isElement(attacker) then cancelEvent() end
        logEvent(EVENT_HACKING, "onPlayerWasted unjustified death (" .. (damage_cause or "unknown") .. ") dealt to " .. getPlayerName(source) .. "(" .. bodypart .. ")", attacker)
        punish(attacker, config.events.damage.action, "Dealt unjustified damage.")
        cancelEvent()
    end
end)

function isStealthKillJustified(player, attacker)
    if not config.events.damage.check_stealth_kills then return true end

    local px, py, pz = getElementPosition(player)
    local ax, ay, az = getElementPosition(attacker)
    if getDistanceBetweenPoints3D(px, py, pz, ax, ay, az) < 5 and getPedWeaponSlot(attacker) == 1 then
        return true
    end

    return false
end
addEventHandler("onPlayerStealthKill", root, isStealthKillJustified)

local executions = setmetatable({}, { --// Metatable for non-existing indexes
    __index = function(t, player)
        return getTickCount() - config.chat_commands.execution_interval
    end
})

function isCommandBlocked(command)
    for _, cmd in ipairs(config.chat_commands.blocked_commands) do
        if command == cmd then return true end
    end
    return false
end

function isCommandProhibited(command)
    for _, cmd in ipairs(config.chat_commands.prohibited_commands) do
        if command == cmd then return true end
    end
    return false
end

function checkIfPlayerIsSpamming(player)
    if (getTickCount() - executions[player] <= config.chat_commands.execution_interval) then
        if (getTickCount() - executions[player] <= config.chat_commands.max_commands_per_second_before_action) then
            logEvent(GENERAL, "spam", player)
            punish(player, config.chat_commands.command_spam_action, "Don't spam chat/commands.")
        end
        cancelEvent()
    end
    executions[player] = getTickCount()
end

addEventHandler("onElementDestroy", root, function()
    if source == root or source == resourceRoot then cancelEvent() end
end)

addEventHandler("onPlayerCommand", root, function(command)
    if config.whitelistedSerials[getPlayerSerial(source)] then return end

    if isCommandBlocked(command) then
        cancelEvent()
    end

    if isCommandProhibited(command) then
        cancelEvent()
        -- this message might be a tiny bit annoying, it is probably going to be a good idea to set the action to LOG
        punish(source, config.chat_commands.prohibited_commands_action, "Don't try to use such commands.")
    end

    checkIfPlayerIsSpamming(source)
end)