--[[
    COPYRIGHT NOTICE
    DATE: XX/01/2024

    AUTHOR: maalos/regex/soczek
    CONTACT: discord:maalos:339395111895040003

    THIS SCRIPT IS A PART OF OPEN-SOURCED RESOURCE ARCHIVE WRITTEN BY maalos, FREE TO USE, MODIFY
]]

local function isKeyProtected(key)
    for _, keyName in ipairs(config.elementdata.protected_keys) do
        if keyName == key then return true end
    end
    return false
end

local function isKeyWhitelisted(key)
    for _, keyName in ipairs(config.elementdata.whitelisted_keys) do
        if keyName == key then return true end
    end
    return false
end

local function onElementDataChange(key, oldValue, newValue)
    if config.elementdata.policy == DISABLED then return end
    if sourceResource then return end -- serverside thingy

    -- too braindead right now to finish the policy and state stuff

    if isKeyWhitelisted(key) then return end

    if isKeyProtected(key) then
        if config.elementdata.protected_keys_action ~= DISABLED then
            logEvent(ELDATA_HACKING, tostring(key) .. " " .. tostring(oldValue) .. " -/> " .. tostring(newValue), client)
            setElementData(source, key, oldValue)
            punish(client, config.events.action, "Element data modification.")
        end
    end
end
addEventHandler("onElementDataChange", root, onElementDataChange)