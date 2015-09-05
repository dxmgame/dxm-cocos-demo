--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

game.CRewardHistoryCellUI = class("game.CRewardHistoryCellUI", dxm.CDialogUI)

local CRewardHistoryCellUI = game.CRewardHistoryCellUI

function CRewardHistoryCellUI:ctor()
    CRewardHistoryCellUI.super.ctor(self)
end

function CRewardHistoryCellUI:Init(reward)
    
    self.reward = reward
    return self:InitWithFile("HistoryRewardPopwords")
end

function CRewardHistoryCellUI:Create(reward)

    local ui = CRewardHistoryCellUI.new()
    if ui == nil or ui:Init(reward)==false then
        return nil
    end
    return ui
end

function CRewardHistoryCellUI:onEnter()

    local message = self.reward.reward_time .." ".. game.sAssetMessage:getMessage("get") .." ".. self.reward.game_bill .. game.sAssetMessage:getMessage("money_unit")
    self:SetLabelText(message, "TextHistoryReward")
end

function CRewardHistoryCellUI:onExit()
    
end

return CRewardHistoryCellUI

--endregion
