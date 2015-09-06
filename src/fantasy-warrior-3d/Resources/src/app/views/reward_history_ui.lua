--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require "app.views.reward_history_cell_ui"

game.CRewardHistoryUI = class("game.CRewardHistoryUI", dxm.CDialogUI)

local CRewardHistoryUI = game.CRewardHistoryUI

function CRewardHistoryUI:ctor()
    CRewardHistoryUI.super.ctor(self)
end

function CRewardHistoryUI:Init()
    
    return self:InitWithFile("HistoryRewardPop")
end

function CRewardHistoryUI:Create()

    local ui = CRewardHistoryUI.new()
    if ui == nil or ui:Init()==false then
        return nil
    end
    return ui
end

function CRewardHistoryUI:onEnter()

    self:AddReleaseEvent(function(sender)
        self:Close()
    end)

   local scroll_view = self:GetWidget("PanelBase", "ScrollView")
   self.scroll_veiw_ui = dxm.CScrollViewUI:Create(scroll_view)

   local itor = game.sUser.module_reward_history.history_list:Begin()
    while true do
        local node = itor()
        if node == nil then break end
        self.scroll_veiw_ui:AddCell(game.CRewardHistoryCellUI:Create(node.value))
    end

   self.scroll_veiw_ui:InitPosition()
   self:AddChild(self.scroll_veiw_ui)
end

function CRewardHistoryUI:onExit()
    
end

return CRewardHistoryUI

--endregion
