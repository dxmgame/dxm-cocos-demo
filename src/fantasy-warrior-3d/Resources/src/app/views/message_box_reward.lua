--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

game.CMessageBoxReward = class("game.CMessageBoxReward", dxm.CDialogUI)

local CMessageBoxReward = game.CMessageBoxReward

function CMessageBoxReward:ctor()
    CMessageBoxReward.super.ctor(self)
end

function CMessageBoxReward:Init(message, callback)
    
    self.callback = callback
    self.message = message
    return self:InitWithFile("Tip2")
end

function CMessageBoxReward:Create(message, callback)

    local ui = CMessageBoxReward.new()
    if ui == nil or ui:Init(message, callback)==false then
        return nil
    end
    return ui
end

function CMessageBoxReward:onEnter()
    self:AddReleaseEvent(function() if self.callback() then self.callback() end self:Close() end, "ButtonDetermine")
    self:SetLabelText(self.message, "TextQuantity");
    game.sUserController:setShakeEnable(false)
end

function CMessageBoxReward:onExit()
    game.sUserController:setShakeEnable(true)
end

return CMessageBoxReward

--endregion
