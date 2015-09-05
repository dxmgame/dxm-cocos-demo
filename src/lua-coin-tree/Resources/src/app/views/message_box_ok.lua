--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

game.CMessageBoxOk = class("game.CMessageBoxOk", dxm.CDialogUI)

local CMessageBoxOk = game.CMessageBoxOk

function CMessageBoxOk:ctor()
    CMessageBoxOk.super.ctor(self)
end

function CMessageBoxOk:Init(message,callback)
    
    self.callback = callback
    self.message = message
    return self:InitWithFile("Tip4")
end

function CMessageBoxOk:Create(message, callback)

    local ui = CMessageBoxOk.new()
    if ui == nil or ui:Init(message,callback)==false then
        return nil
    end
    return ui
end

function CMessageBoxOk:onEnter()
    self:AddReleaseEvent(function() if self.callback() then self.callback() end self:Close() end, "ButtonDetermine")
    self:SetLabelText(self.message, "TextContent");
end

function CMessageBoxOk:onExit()

end

return CMessageBoxOk

--endregion
