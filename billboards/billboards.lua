local billboardTextures = {
    "SunBillB03",
    "ads003 copy",
    -- "billbd1_LAe", https://files.prineside.com/gtasa_samp_game_texture//png/lae2billboards.billbd1_LAe.png -- split in half, needs a new uv map or custom images
    "semi3Dirty",
    "CJ_SPRUNK_FRONT2",
    "bobobillboard1",
    "cokopops_1",
    "eris_3",
    "prolaps02",
    "SunBillB01",
    "SunBillB02",
    "diderSachs01",
    "heat_01",
    "prolaps01",
    "base5_1",
    "bobo_3",
    "cokopops_2",
    "eris_4",
    "eris_5",
    "homies_1",
    "Victim_bboard",
    "homies_1_128",
    "diderSachs01LOD",
    "eris_2LOD",
    "heat_02LOD",
    "homies_2LOD",
    "semi1Dirty",
    "semi2Dirty",
    "bobo_2",
    "eris_1",
    "hardon_1",
    "homies_2",
    "eris_2",
    "heat_02",
    "Sprunk_postersign1",
}

local amountOfAdvertisements = 6 -- specified in the meta.xml
local cycleTime = 15000 -- time in ms between ad switching

addEventHandler("onClientResourceStart", resourceRoot, function()
    local shader = dxCreateShader("replace.fx")

    for _, texture in ipairs(billboardTextures) do
        engineApplyShaderToWorldTexture(shader, texture)
        dxSetShaderValue(shader, "gTexture", dxCreateTexture("img/0.jpg"))
    end

    local counter = 1

    setTimer(function() -- simple cycling between images
        if not shader then return end
        if counter > amountOfAdvertisements then counter = 1 end
        dxSetShaderValue(shader, "gTexture", dxCreateTexture("img/" .. counter .. ".jpg"))
        counter = counter + 1
    end, cycleTime, 0)
end)