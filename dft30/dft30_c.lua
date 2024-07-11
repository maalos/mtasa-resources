addEventHandler("onClientResourceStart", resourceRoot, function()
    engineImportTXD(engineLoadTXD("models/dft30tools.txd"), 1919)
    engineReplaceModel(engineLoadDFF("models/winch.dff"), 1919)
    --engineReplaceCOL(engineLoadCOL("models/winch.col"), 1919)

    engineImportTXD(engineLoadTXD("models/dft30tools.txd"), 1920)
    engineReplaceModel(engineLoadDFF("models/hook.dff"), 1920)
    --engineReplaceCOL(engineLoadCOL("models/hook.col"), 1920)

    engineImportTXD(engineLoadTXD("models/dft30tools.txd"), 1922)
    engineReplaceModel(engineLoadDFF("models/ramp.dff"), 1922)
    engineReplaceCOL(engineLoadCOL("models/ramp.col"), 1922)

    engineImportTXD(engineLoadTXD("models/dft30.txd"), 578)
    engineReplaceModel(engineLoadDFF("models/dft30.dff"), 578)

    setFarClipDistance(100000)

    local objectsTable = getElementsByType("object")
    for i = 1, #objectsTable do
	    local objectElement = objectsTable[i]
	    local objectModel = getElementModel(objectElement)
	    engineSetModelLODDistance(objectModel, 300)
    end

    setDevelopmentMode(true)
end)