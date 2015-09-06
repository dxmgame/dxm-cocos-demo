--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

game.CAssetMessage = class("game.CAssetMessage")
local CAssetMessage = game.CAssetMessage

function CAssetMessage:ctor()
    local config_json = cc.FileUtils:getInstance():getStringFromFile("res/config/message.json")
    self.config = json.decode(config_json, 1)
end

function CAssetMessage:getMessage(key)
    return self.config[key] or "no message "..key.." defined"
end

return CAssetMessage

--endregion
