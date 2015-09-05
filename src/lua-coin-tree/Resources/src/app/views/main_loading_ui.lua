-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

require "app.views.rule_ui"
require "app.views.reward_history_ui"

game.CMainLoadingUI = class("game.CMainLoadingUI", dxm.CStackUI)

local CMainLoadingUI = game.CMainLoadingUI

function CMainLoadingUI:ctor()
    CMainLoadingUI.super.ctor(self)
end

function CMainLoadingUI:Init()

    return self:InitWithFile("SceneLoading")
end

function CMainLoadingUI:Create()

    local ui = CMainLoadingUI.new()
    if ui == nil or ui:Init() == false then
        return nil
    end
    return ui
end

function CMainLoadingUI:onEnter()

    -- 播放动画
    self:Play("animation0", true)

    -- 规则按钮
    self:AddReleaseEvent( function(sender)
        local ui = game.CRuleUI:Create()
        -- local ui = game.CMainLoadingUI:Create()
        ui:Open()
    end , "PanelBottonRuleNormal")

    -- 返回按钮
    self:AddReleaseEvent( function(sender)
        ReturnApp()
        -- self:Close()
    end , "PanelBottonReturnNormal")
end

function CMainLoadingUI:onExit()
end

return CMainLoadingUI

-- endregion
