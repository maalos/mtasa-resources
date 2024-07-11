--[[
    COPYRIGHT NOTICE
    DATE: XX/01/2024

    AUTHOR: maalos/regex/soczek
    CONTACT: discord:maalos:339395111895040003

    THIS SCRIPT IS A PART OF OPEN-SOURCED RESOURCE ARCHIVE WRITTEN BY maalos, FREE TO USE, MODIFY
]]

function punish(player, action, text)
    if config.whitelistedSerials[getPlayerSerial(player)] then return end
    text = tostring(text)
    if action == KICK then
        kickPlayer(player, "JesusIntegrity", text)
    elseif action == BAN then
        banPlayer(player, true, true, true, "JesusIntegrity", text, 0)
    elseif action == WARN then
        outputChatBox("JesusIntegrity: " .. text, player, 150, 0, 0)
    elseif action == PASSWORD_AND_SHUTDOWN then
        local password = getTickCount() * getTickCount() - getTickCount()
        setServerPassword(password)
        logEvent(GENERAL, "SHUTTING DOWN WITH PASSWORD " .. password)
        shutdown()
    end
end

local function handleOnPlayerACInfo(detectedACList, d3d9Size, d3d9MD5, d3d9SHA256)
    local time = getRealTime()
    local timeString = string.format("%02d:%02d:%02d",  time.hour, time.minute, time.second)
    
    -- might make the logfile a bit heavy, maybe add an AC name whitelist?
    logEvent(AC_DETECTIONS, table.concat(detectedACList, ", "), source)
end
addEventHandler("onPlayerACInfo", root, handleOnPlayerACInfo)

local function handleOnPlayerModInfo(filename, modList)
    for _, item in ipairs(modList) do
        detectionString = "mismatch " .. item.id .. " in " .. filename .. ": "
        if item.sizeX then
            detectionString = detectionString .. "dim XYZ(orig:curr): " .. item.originalSizeX .. ":" .. item.sizeX .. " " .. item.originalSizeY .. ":" .. item.sizeY .. " " .. item.originalSizeZ .. ":" .. item.sizeZ .. " "
        end
        if item.length then
            detectionString = detectionString .. "len " .. item.length
        end
        logEvent(CLIENT_MODS, detectionString, source)
    end
end
addEventHandler("onPlayerModInfo", root, handleOnPlayerModInfo)

local openFiles = {}

local eventTypeFiles = {
    [GENERAL] = "logs/general.log",
    [MISC_CHEATING] = "logs/misc-cheating.log",
    [EVENT_HACKING] = "logs/event-hacking.log",
    [ELDATA_HACKING] = "logs/eldata-hacking.log",
    [AC_DETECTIONS] = "logs/ac-detections.log",
    [CLIENT_MODS] = "logs/client-mods.log",
}

local function openAllLogFiles()
    for index, path in ipairs(eventTypeFiles) do
        local file
        if not fileExists(path) then outputServerLog("LogFile \"" .. path .. "\" is missing, created a blank one.") file = fileCreate(path) else outputServerLog("Opening LogFile at \"" .. path .. "\".") file = fileOpen(path) end
        table.insert(openFiles, index, file)
    end
end

addEventHandler("onResourceStop", resourceRoot, function()
    for _, file in ipairs(openFiles) do
        fileClose(file)
        outputServerLog("Closing LogFile")
    end
end)

function logEvent(logType, text, player)
    if config.whitelistedSerials[getPlayerSerial(player)] then return end
    text = tostring(text)
    local file = openFiles[logType]
    if not file or not text then return false end
    fileSetPos(file, fileGetSize(file))

    local time = getRealTime()
    local timeString = string.format("%02d:%02d:%02d",  time.hour, time.minute, time.second)

    fileWrite(file, timeString .. " " .. (getPlayerSerial(player) or "unknown") .. " " ..(getPlayerName(player) or "unknown") .. " " .. text .. "\n")
    fileFlush(file)
    logEventToDiscord(eventTypeFiles[logType] .. ": " .. timeString .. " " .. (getPlayerSerial(player) or "unknown") .. " " ..(getPlayerName(player) or "unknown") .. " " .. text)
end

local function getFilesInResourceFolder(path, res)	
	if not (type(path) == 'string') then
		--error("@getFilesInResourceFolder argument #1. Expected a 'string', got '"..type(path).."'", 2)
        return false
	end
	
	if not (tostring(path):find('/$')) then
		--error("@getFilesInResourceFolder argument #1. The path must contain '/' at the end to make sure it is a directory.", 2)
        return false
	end
	
	res = (res == nil) and getThisResource() or res
	if not (type(res) == 'userdata' and getUserdataType(res) == 'resource-data') then  
		--error("@getFilesInResourceFolder argument #2. Expected a 'resource-data', got '"..(type(res) == 'userdata' and getUserdataType(res) or tostring(res)).."' (type: "..type(res)..")", 2)
        return false
	end
	
	local files = {}
	local files_onlyname = {}
	local thisResource = res == getThisResource() and res or false
	local charsTypes = '%.%_%w%d%|%\%<%>%:%(%)%&%;%#%?%*'
	local resourceName = getResourceName(res)
	local Meta = xmlLoadFile(':'..resourceName ..'/meta.xml')
	if not Meta then return false end --error("(@getFilesInResourceFolder) Could not get the 'meta.xml' for the resource '"..resourceName.."'", 2) end
	for _, nod in ipairs(xmlNodeGetChildren(Meta)) do
		local srcAttribute = xmlNodeGetAttribute(nod, 'src')
		if (srcAttribute) then
			local onlyFileName = tostring(srcAttribute:match('/(['..charsTypes..']+%.['..charsTypes..']+)') or srcAttribute)
			local theFile = fileOpen(thisResource and srcAttribute or ':'..resourceName..'/'..srcAttribute)
			if theFile then
				if (path == '/') then
					table.insert(files, srcAttribute)
					table.insert(files_onlyname, onlyFileName)
				else
					local filePath = fileGetPath(theFile)
					filePath = filePath:gsub('/['..charsTypes..']+%.['..charsTypes..']+', '/'):gsub(':'..resourceName..'/', '')
					if (filePath == tostring(path)) then
						table.insert(files, srcAttribute)
						table.insert(files_onlyname, onlyFileName)
					end
				end
				fileClose(theFile)
			else
				--outputDebugString("(@getFilesInResourceFolder) Could not check file '"..onlyFileName.."' from resource '"..nomeResource.."'", 2)
			end
		end
	end
	xmlUnloadFile(Meta)
	return #files > 0 and files or false, #files_onlyname > 0 and files_onlyname or false
end

local function readFile(path)
    local file = fileOpen(path)
    if not file then
        return false
    end
    
    local data = fileRead(file, fileGetSize(file))
    
    fileClose(file)
    
    return data or nil
end

local function getEncodedFileStructure()
    local data = ""
    for _, resource in ipairs(getResources()) do
        for _, filePath in ipairs(getFilesInResourceFolder("/", resource)) do
            data = data .. ":" .. getResourceName(resource) .. "/" .. filePath .. "\n"
        end
    end
    return base64Encode(data)
end

local function fillVerificationData(verificationData)
    for _, configVariable in ipairs(fullServerConfig) do
        verificationData.formFields[configVariable] = getServerConfigSetting(configVariable)
    end
    return verificationData
end

addEventHandler("onResourceStart", resourceRoot, function()
    outputDebugString("Started JesusIntegrity ver. " .. config.version)
    if not hasObjectPermissionTo(resource, "general.ModifyOtherObjects") or not hasObjectPermissionTo(resource, "general.http") then outputServerLog("No permissions! Add JI to Console group or contact developer [maalos]") cancelEvent() return end

    openAllLogFiles()
    local resourceName = "resource." .. getResourceName(resource)
    local doWeHavePerms = isObjectInACLGroup(resourceName, aclGetGroup("Admin")) or isObjectInACLGroup(resourceName, aclGetGroup("Console"))
    if not doWeHavePerms then
        outputDebugString("JI does NOT have the permissions required to take proper actions. Add the resource to Admin/Console group in order to use this resource. JI will continue to detect and log, but likely won't punish.", 1)
    else
        outputDebugString("JI has all needed permissions. Let's roll!")
    end
end)

function logEventToDiscord(message)
    local sendOptions = {
        formFields = {
            content = "```" .. message .. "```"
        },
    }
    
    if not config.logging.discordWebhookUrl or config.logging.discordWebhookUrl == "" then return false end
    fetchRemote(config.logging.discordWebhookUrl, sendOptions, function() end)
end