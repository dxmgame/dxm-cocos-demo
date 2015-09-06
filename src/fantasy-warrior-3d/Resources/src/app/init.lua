--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

cc.exports.game = cc.exports.game or { }
require "app.views.main_scene"
require "app.models.user"
require "app.controllers.user_controller"

require "app.asset.asset_user"
require "app.asset.asset_daily_sign_in"
require "app.asset.asset_item"
require "app.asset.asset_global"
require "app.asset.asset_message"
require "app.asset.asset_tree_state"

-- 配置
game.sAssetGlobal = game.CAssetGlobal.new()
game.sAssetMessage = game.CAssetMessage.new()

-- 本地数据
dxm.GameState.init("game_state")
dxm.GameState.load()

-- 用户数据
game.sUser = game.CUser.new()
game.sUserController = game.CUserController.new()

--endregion
