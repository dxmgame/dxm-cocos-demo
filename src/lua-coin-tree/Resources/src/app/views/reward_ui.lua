--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

game.CRewardUI = class("game.CRewardUI", dxm.CDialogUI)

local CRewardUI = game.CRewardUI

function CRewardUI:ctor()
    CRewardUI.super.ctor(self)
end

function CRewardUI:Init(reward_string)
    
    self.reward_string = reward_string
    return self:InitWithFile("RuleLayer")
end

function CRewardUI:Create(reward_string)

    local ui = CRewardUI.new()
    if ui == nil or ui:Init(reward_string)==false then
        return nil
    end
    return ui
end

function CRewardUI:onEnter()

    self:AddReleaseEvent(function(sender)
        self:Close()
    end)

    self:SetLabelText(self.reward_string, "TextExplain")

    game.sUserController:setShakeEnable(false)
end

function CRewardUI:onExit()
    game.sUserController:setShakeEnable(true)
end

return CRewardUI

--endregion
