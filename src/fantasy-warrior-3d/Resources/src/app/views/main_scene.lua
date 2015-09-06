-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

require "app.views.main_loading_ui"
require "app.views.shake_layer"

cc.exports.game = cc.exports.game or { }
game.CMainScene = class("game.CMainScene", dxm.CBaseScene)

local CMainScene = game.CMainScene

function CMainScene:ctor()
    CMainScene.super.ctor(self)
    print("CMainScene ctor")
end

function CMainScene:Init()
    return CMainScene.super.Init(self)
end

function CMainScene:Create()
    local scene = CMainScene.new()
    if scene == nil or scene:Init() == false then
        return nil
    end
    return scene
end

function CMainScene:onEnter()
    CMainScene.super.onEnter(self)
    print("onEnter")

    -- 打开主界面
    local ui = game.CMainLoadingUI:Create()
    ui:Open()
    game.CUserController:getUser(GetToken())

    -- 添加shake层
    local layer = game.CShakeLayer:create()
    self:addChild(layer)

    -- 循环播放动画
    -- self.root_node_ = cc.CSLoader:createNode("res/MainSceneV1.csb")
    -- self:addChild(self.root_node_)
    -- self.root_action_ = cc.CSLoader:createTimeline("res/MainSceneV1.csb")
    -- self.root_node_:runAction(self.root_action_)
    -- self.root_action_:play("animation1", false)
end

function CMainScene:onExit()
    CMainScene.super.onExit(self)
    print("onExit")
end
return CMainScene

-- endregion
