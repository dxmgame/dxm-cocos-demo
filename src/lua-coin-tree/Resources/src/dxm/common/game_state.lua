

dxm = dxm or { }
dxm.GameState = { }

local GameState = dxm.GameState

GameState.ERROR_INVALID_FILE_CONTENTS = -1
GameState.ERROR_HASH_MISS_MATCH = -2
GameState.ERROR_STATE_FILE_NOT_FOUND = -3


local stateFilename = "state.txt"
local eventListener = nil
local secretKey = nil

----------------------------------------
function GameState.init(stateFilename_)
    if type(stateFilename_) == "string" then
        stateFilename = stateFilename_
    end
    return true
end

function GameState.load()
    local filename = GameState.getGameStatePath()

    dxm.save_data = {}
    if not io.exists(filename) then
        printInfo("GameState.load() - file \"%s\" not found", filename)
        return
    end

    local contents = io.readfile(filename)
    printInfo("GameState.load() - get values from \"%s\"", filename)

    local values = json.decode(contents)
    if type(values) ~= "table" then
        printError("GameState.load() - invalid data")
        return
    end

    dxm.save_data = values
end

function GameState.save()
    local values = dxm.save_data
    if type(values) ~= "table" then
        printError("GameState.save() - listener return invalid data")
        return false
    end

    local filename = GameState.getGameStatePath()
    local ret = false

    local s = json.encode(values)
    if type(s) == "string" then
        ret = io.writefile(filename, s)
    end

    printInfo("GameState.save() - update file \"%s\"", filename)
    return ret
end

function GameState.getGameStatePath()
    return string.gsub(device.writablePath, "[\\\\/]+$", "") .. device.directorySeparator .. stateFilename
end

return GameState
