--[[
    COPYRIGHT NOTICE
    DATE: XX/01/2024

    AUTHOR: maalos/regex/soczek
    CONTACT: discord:maalos:339395111895040003

    THIS SCRIPT IS A PART OF OPEN-SOURCED RESOURCE ARCHIVE WRITTEN BY maalos, FREE TO USE, MODIFY
]]

function resendACStuff()
    for _, player in ipairs(getElementsByType("player")) do
        resendPlayerACInfo(player)
        resendPlayerModInfo(player)
    end
end

function scanForHighPing()
    for _, player in ipairs(getElementsByType("player")) do
		if getPlayerPing(player) > config.high_ping_threshold then
            if not isElementFrozen(player) then
                setElementFrozen(player, true)
                toggleAllControls(player, false)
                setElementData(player, "highping", true)
            end
        else
            if isElementFrozen(player) then
                setElementFrozen(player, false)
                toggleAllControls(player, true)
                setElementData(player, "highping", false)
            end
        end
	end
end

function isElementInAir(element)
    assert(type(element) == 'userdata',('Expected element at argument 1, got %s!'):format(type(element)))
    assert(getElementType(element) == 'ped' or getElementType(element) == 'player' or getElementType(element) == 'vehicle',
        ('Expected element at argument 1, got %s!'):format(getElementType(element))
    )
    if getElementType(element) == 'ped' or getElementType(element) == 'player' then
        return not (isPedOnGround(element) or getPedContactElement(element))
    elseif getElementType(element) == 'vehicle' then
        return not isVehicleOnGround(element)
    end
end

function isPedFlying(player)
    if not isElement(player) then return end
    if isPedOnGround(player) then return false end
    if getPedOccupiedVehicle(player) then return false end
    if isPedWearingJetpack(player) then return false end
    if not isElementInAir(player) then return false end

    local vx, vy, vz = getElementVelocity(player)
    if math.abs(vx) + math.abs(vy) > 0.3 then return true end
    return false
end

function isPedSpeedhacking(player)
    if getPedOccupiedVehicle(player) then return false end
    local vx, vy, vz = getElementVelocity(player)
    if math.abs(vx) + math.abs(vy) > 0.3 and isPedOnGround(player) then return true end
    return false
end

function checkCheats()
    for _, player in ipairs(getElementsByType("player")) do
        if not config.whitelistedSerials[getPlayerSerial(player)] then
            if isPedFlying(player) then
                logEvent(MISC_CHEATING, "fly", player)
            end

            if isPedSpeedhacking(player) then
                logEvent(MISC_CHEATING, "speedhack", player)
            end
        end
    end
end

resendACStuff()
setTimer(resendACStuff, config.ac_stuff.resend_time, 0)
setTimer(scanForHighPing, config.scan_for_high_ping_delay, 0)
setTimer(checkCheats, config.movement_cheats.check_time, 0)