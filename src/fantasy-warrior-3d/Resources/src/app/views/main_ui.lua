-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

require "app.views.rule_ui"
require "app.views.reward_history_ui"

game.CMainUI = class("game.CMainUI", dxm.CStackUI)

local CMainUI = game.CMainUI

function CMainUI:ctor()
    CMainUI.super.ctor(self)
end

function CMainUI:Init()

    return self:InitWithFile("MainSceneV1")
end

function CMainUI:Create()

    local ui = CMainUI.new()
    if ui == nil or ui:Init() == false then
        return nil
    end
    return ui
end

function CMainUI:onEnter()

    print("print")
    release_print("release_print")
    -- 播放动画
    self:Play("animation0", true)

    -- 规则按钮
    self:AddReleaseEvent( function(sender)
        local ui = game.CRuleUI:Create()
        -- local ui = game.CMainUI:Create()
        ui:Open()
    end , "PanelBottonRuleNormal")

    -- 返回按钮
    self:AddReleaseEvent( function(sender)
        ReturnApp()
        -- self:Close()
    end , "PanelBottonReturnNormal")

    -- 历史按钮
    self:AddReleaseEvent( function(sender)
        local ui = game.CRewardHistoryUI:Create()
        ui:Open()
    end , "ButtonHistoryReward")

    -- 摇的按钮
--    self:AddReleaseEvent( function(sender)
--        game.sUserController:shake()
--    end , "ButtonHistoryReward")

    -- 设置次数
    self:SetLabelText(game.sUser.module_tree_manager:getTimes() .. "次", "TextNextStageQuantityName", "TextNextStageQuantity")
    self:SetLabelText(game.sUser.module_tree_manager:getTimes() .. "次", "TextNowStageQuantityName", "TextNowStageQuantity")

    -- 设置时间
    self:SetLabelText(game.sUser.module_tree_manager:getBeginTime(), "TextNextStageTimeName", "TextNextStageTime")
    self:SetLabelText(game.sUser.module_tree_manager:getEndTime(), "TextNowStageTimeName", "TextNowStageTime")

    -- 设置文本显示
    local in_activity_time = game.sUser.module_tree_manager:isInActivityTime()
    self:SetWidgetVisible(in_activity_time==true, "TextNowStageTimeName")
    self:SetWidgetVisible(in_activity_time==true, "TextNowStageQuantityName")
    self:SetWidgetVisible(in_activity_time==false, "TextNextStageTimeName")
    self:SetWidgetVisible(in_activity_time==false, "TextNextStageQuantityName")

    self.update_entry = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt) self:Update(dt) end, 0, false)
end

function CMainUI:onExit()
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.update_entry)
end

function CMainUI:Update(dt)

    -- 设置次数
    self:SetLabelText(game.sUser.module_tree_manager:getTimes() .. "次", "TextNextStageQuantityName", "TextNextStageQuantity")
    self:SetLabelText(game.sUser.module_tree_manager:getTimes() .. "次", "TextNowStageQuantityName", "TextNowStageQuantity")

    -- 设置时间
    self:SetLabelText(game.sUser.module_tree_manager:getBeginTime(), "TextNextStageTimeName", "TextNextStageTime")
    self:SetLabelText(game.sUser.module_tree_manager:getEndTime(), "TextNowStageTimeName", "TextNowStageTime")

    -- 设置文本显示
    local in_activity_time = game.sUser.module_tree_manager:isInActivityTime()
    self:SetWidgetVisible(in_activity_time==true, "TextNowStageTimeName")
    self:SetWidgetVisible(in_activity_time==true, "TextNowStageQuantityName")
    self:SetWidgetVisible(in_activity_time==false, "TextNextStageTimeName")
    self:SetWidgetVisible(in_activity_time==false, "TextNextStageQuantityName")
end

return CMainUI

-- endregion
