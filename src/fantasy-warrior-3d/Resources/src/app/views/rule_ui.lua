--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

game.CRuleUI = class("game.CRuleUI", dxm.CDialogUI)

local CRuleUI = game.CRuleUI

function CRuleUI:ctor()
    CRuleUI.super.ctor(self)
end

function CRuleUI:Init()
    
    return self:InitWithFile("RuleLayer")
end

function CRuleUI:Create()

    local ui = CRuleUI.new()
    if ui == nil or ui:Init()==false then
        return nil
    end
    return ui
end

function CRuleUI:onEnter()

    self:AddReleaseEvent(function(sender)
        self:Close()
    end)

    self:SetLabelText(game.sAssetGlobal.rule, "TextExplain")
end

function CRuleUI:onExit()

end

return CRuleUI

--endregion
