--[[
    COPYRIGHT NOTICE
    DATE: XX/01/2024

    AUTHOR: maalos/regex/soczek
    CONTACT: discord:maalos:339395111895040003

    THIS SCRIPT IS A PART OF OPEN-SOURCED RESOURCE ARCHIVE WRITTEN BY maalos, FREE TO USE, MODIFY
]]

config = {
    blocked_functions = {
        "setElementPosition",
        "loadstring",
        "load",
        "loadfile",
        "dofile",
        "dostring",
        "pcall",
        "setElementHealth",
        "removeDebugHook",
        "setElementDimension",
        "setElementInterior",
        "setElementModel",
        "setElementRotation",
        "setElementVelocity",
        "setPedArmor",
        "setPedDoingGangDriveby",
        "setPedOnFire",
        "setPedStat",
        "warpPedIntoVehicle",
        "createProjectile",
        "detonateSatchels",
        "call",
        "setDevelopmentMode",
        "blowVehicle",
        "fixVehicle",
        "setVehicleDamageProof",
        "setVehicleEngineState",
        "setVehicleHandling",
        "setVehicleGravity",
        "setVehicleFuelTankExplodable",
        "setVehicleLocked",
        "createWeapon",
        "fireWeapon",
        "setGravity",
        "setGameSpeed",
        "setWorldSpecialPropertyEnabled",
    }
}

local sx, sy = guiGetScreenSize()

addEventHandler("onClientRender", root, function()
    --[[ =============== SEE events.lua, line 155
    if getElementData(localPlayer, "highping") then
        dxDrawText("JesusIntegrity", sx/2 - 100, sy/2 - 100, sx/2 + 100, sy/2 + 530, 0xFFFF0000, 2, 2, "default", "center", "center")
        dxDrawText("You're lagging!\nYou have been frozen to prevent unwanted behaviour.", sx/2 - 100, sy/2 - 100, sx/2 + 100, sy/2 + 50, 0xFFFF0000, 2, 2, "default", "center", "bottom")
        dxDrawImage(sx/2 - 178 / 2, sy/2 + 100 / 2, 178, 165, "res/latency.png")
        dxDrawText(getPlayerPing(localPlayer), sx/2 - 200, sy/2 + 250, sx/2 + 200, sy/2 + 300, 0xFFFF0000, 5, 5, "default", "center", "center")
    end
    ]]

    dxDrawText("Protected by JesusIntegrity\ngithub.com/maalos", sx - 230, sy - 30, 230, 30, 0x08FFFFFF, 1.0, 1.0, "default", center)
end)

setTimer(function()
    for _, prop in ipairs({"aircars", "hovercars", "extrabunny", "extrajump"}) do
        if isWorldSpecialPropertyEnabled(prop) then setWorldSpecialPropertyEnabled(prop, false) triggerServerEvent("reportMyself", localPlayer, "LUA Executor (worldSpecialProperty modification)") end
    end
end, 1000, 0)

addDebugHook("preFunction", function(sourceResource, functionName)
    triggerServerEvent("reportMyself", localPlayer, "LUA Executor (triggering blocked clientside functions - " .. tostring(functionName) .. ").")
end, config.blocked_functions)