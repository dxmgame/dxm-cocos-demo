--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

game.CAssetGlobal = class("game.CAssetGlobal")
local CAssetGlobal = game.CAssetGlobal

function CAssetGlobal:ctor()
    local config_json = cc.FileUtils:getInstance():getStringFromFile("res/config/global.json")
    local config = json.decode(config_json, 1)
    self.url = config.url or "http://192.168.1.90/cointree/cointree/"
    self.rule = config.rule or "rule"
end

return CAssetGlobal

--endregion
