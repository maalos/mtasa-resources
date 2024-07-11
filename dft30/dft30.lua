function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function getVehicleInColshape(colshape)
    local elementy = getElementsWithinColShape(colshape)
    for _, el in ipairs(elementy) do
        if getElementType(el) == "vehicle" then return el end
    end
    return false
end

for _, p in ipairs(getElementsByType("player")) do
    bindKey(p, "k", "down", function()
        local v = getPedOccupiedVehicle(p)
        if not v then return end
        if getElementVelocity(p) ~= 0 then return end
        setElementFrozen(v, not isElementFrozen(v))
    end)
end

for _, v in ipairs(getElementsByType("vehicle")) do
    if getElementModel(v) == 578 then
        local ramp = createObject(1922, 0, 0, 0, 82, 0, 0)
        attachElements(ramp, v, 0, -4.5, -0.44, 82, 0, 0)

        local winch = createObject(1919, 0, 0, 0)
        attachElements(winch, v, 0, 2.1, 0.04, 90, 0, 180)

        local hook = createObject(1920, 0, 0, 0)
        attachElements(hook, v, -0.2, 1.8, -0.13, -90)

        setElementData(v, "dft.winch", winch)
        setElementData(v, "dft.hook", hook)
        setElementData(v, "dft.ramp", ramp)
        setElementData(v, "dft.ramp.in", true)
    end
end

function zaladujPojazd(dft, vehicleToLoad)
    local vtlx, vtly, vtlz = getElementPosition(vehicleToLoad)
    local vtlrx, vtlry, vtlrz = getElementRotation(vehicleToLoad)
    local drx, dry, drz = getElementRotation(dft)
    local vtlObj = createObject(3000, vtlx, vtly, vtlz)
    setVehicleDamageProof(vehicleToLoad, true)
    attachElements(vehicleToLoad, vtlObj, 0, 0, 0, vtlrx, vtlry, vtlrz)

    local fpx, fpy, fpz = getPositionFromElementOffset(dft, 0, -10, -0.5) -- in front of ramp
    local spx, spy, spz = getPositionFromElementOffset(dft, 0, -7, 0.2) -- on ramp, should also rotate
    local tpx, tpy, tpz = getPositionFromElementOffset(dft, 0, -2, 0.6) -- on dft
    moveObject(vtlObj, 2000, fpx, fpy, fpz, -10, 0, drz - vtlrz, InOutQuad)

    setTimer(function()
        setElementRotation(vtlObj, 0, 0, drz - vtlrz)
        moveObject(vtlObj, 2000, spx, spy, spz, 0, 0, 0, InOutQuad)
        setTimer(function()
            moveObject(vtlObj, 2000, tpx, tpy, tpz, 5, 0, 0, InOutQuad)
            setTimer(function()
                detachElements(vehicleToLoad, vtlObj)
                destroyElement(vtlObj)
                attachElements(vehicleToLoad, dft, 0, -2, 0.6, 5)
                setElementData(dft, "dft.load", vehicleToLoad)
            end, 2000, 1)
        end, 2000, 1)
    end, 2000, 1)
end

function rozladujPojazd(dft, vehicleToUnload)
    local vtlx, vtly, vtlz = getElementPosition(vehicleToUnload)
    local vtlrx, vtlry, vtlrz = getElementRotation(vehicleToUnload)
    local drx, dry, drz = getElementRotation(dft)
    local vtlObj = createObject(3000, vtlx, vtly, vtlz, 0, 0, vtlrz)
    detachElements(vehicleToUnload, dft)
    attachElements(vehicleToUnload, vtlObj, 0, 0, 0, 0, 0, 0)

    local spx, spy, spz = getPositionFromElementOffset(dft, 0, -12, -0.5) -- in front of ramp
    local fpx, fpy, fpz = getPositionFromElementOffset(dft, 0, -7, 0.2) -- on ramp, should also rotate
    moveObject(vtlObj, 2000, fpx, fpy, fpz, 5, 0, 0, InOutQuad)

    setTimer(function()
        moveObject(vtlObj, 2000, spx, spy, spz, 0, 0, 0, InOutQuad)
        setTimer(function()
            detachElements(vehicleToUnload, vtlObj)
            destroyElement(vtlObj)
            setElementData(dft, "dft.load", nil)
            setVehicleDamageProof(vehicleToLoad, false)
            end, 2000, 1)
    end, 2000, 1)
end

function wsunRampe(dft)
    if not dft then return false end
    local rampa = getElementData(dft, "dft.ramp")
    if not rampa then return false end
    if getElementData(dft, "dft.ramp.in") then outputChatBox("rampa jest juz wsunieta") return false end
    local cx, cy, cz = getElementPosition(rampa)
    local crx, cry = getElementRotation(rampa)
    local _, _, crz = getElementRotation(dft)
    detachElements(rampa, dft)
    setElementRotation(rampa, crx - 24, cry, crz)
    setElementPosition(rampa, cx, cy, cz - 0.23)

    moveObject(rampa, 2000, cx, cy, cz + 0.13, -12, 0, 0, InOutQuad)
    setTimer(function()
        local nx, ny, nz = getPositionFromElementOffset(dft, 0, -4.5, -0.44)
        moveObject(rampa, 2000, nx, ny, nz, 0, 0, 0, InOutQuad)
        setTimer(function()
            attachElements(rampa, dft, 0, -4.5, -0.44, 82, 0, 0)
            setElementData(dft, "dft.ramp.in", true)
        end, 2000, 1)
    end, 2000, 1)
end

function wysunRampe(dft)
    if not dft then return false end
    local rampa = getElementData(dft, "dft.ramp")
    if not rampa then return false end
    if getElementData(dft, "dft.ramp.in") == false then outputChatBox("rampa jest juz wysunieta") return false end
    local cx, cy, cz = getElementPosition(rampa)
    detachElements(rampa, dft)
    local crx, cry = getElementRotation(rampa)
    local _, _, crz = getElementRotation(dft)
    setElementRotation(rampa, crx, cry, crz)
    setElementPosition(rampa, cx, cy, cz - 0.15)

    local nx, ny, nz = getPositionFromElementOffset(dft, 0, -7, -0.76)
    moveObject(rampa, 2000, nx, ny, nz, 0, 0, 0, InOutQuad)

    setTimer(function()
        local nx, ny, nz = getPositionFromElementOffset(dft, 0, -7, -0.95)
        moveObject(rampa, 2000, nx, ny, nz, 8, 0, 0, InOutQuad)
        setTimer(function()
            attachElements(rampa, dft, 0, -7, -0.95, 90)
            setElementData(dft, "dft.ramp.in", false)
        end, 2000, 1)
    end, 2000, 1)
end

addCommandHandler("zaladuj", function(p)
    local v = getPedOccupiedVehicle(p)
    if not v then return end
    if getElementModel(v) ~= 578 then return end
    if not isElementFrozen(v) then outputChatBox("zaciagnij reczny", p) return end
    local zaladowanyPojazd = getElementData(v, "dft.load")
    if zaladowanyPojazd then outputChatBox("masz juz pojazd na pace", p) return end
    if getElementData(v, "dft.ramp.in") then outputChatBox("rozsun rampe", p) return end
    local colshape = createColSphere(0, 0, 0, 4)
    attachElements(colshape, getElementData(v, "dft.ramp"), 0, 0, 3)
    local pojazd = getVehicleInColshape(colshape)
    destroyElement(colshape)
    if not pojazd then outputChatBox("nie ma za toba pojazdu", p) return end
    zaladujPojazd(v, pojazd)
end)

addCommandHandler("rozladuj", function(p)
    v = getPedOccupiedVehicle(p)
    if not v then return end
    if getElementModel(v) ~= 578 then return end
    if not isElementFrozen(v) then outputChatBox("zaciagnij reczny", p) return end
    local zaladowanyPojazd = getElementData(v, "dft.load")
    if not zaladowanyPojazd then outputChatBox("nie masz pojazdu na pace", p) return end
    if getElementData(v, "dft.ramp.in") then outputChatBox("rozsun rampe", p) return end
    rozladujPojazd(v, zaladowanyPojazd)
end)

addCommandHandler("wsun", function(p)
    local v = getPedOccupiedVehicle(p)
    if not v then return end
    if getElementModel(v) ~= 578 then return end
    if not isElementFrozen(v) then outputChatBox("zaciagnij reczny", p) return end
    wsunRampe(v)
end)

addCommandHandler("wysun", function(p)
    local v = getPedOccupiedVehicle(p)
    if not v then return end
    if getElementModel(v) ~= 578 then return end
    if not isElementFrozen(v) then outputChatBox("zaciagnij reczny", p) return end
    wysunRampe(v)
end)