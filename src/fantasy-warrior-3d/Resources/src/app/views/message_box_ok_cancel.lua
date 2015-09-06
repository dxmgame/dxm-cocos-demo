--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

game.CMessageBoxOkCancel = class("game.CMessageBoxOkCancel", dxm.CDialogUI)

local CMessageBoxOkCancel = game.CMessageBoxOkCancel

function CMessageBoxOkCancel:ctor()
    CMessageBoxOkCancel.super.ctor(self)
end

function CMessageBoxOkCancel:Init(message,callback)
    
    self.callback = callback
    self.message = message
    return self:InitWithFile("Tip3")
end

function CMessageBoxOkCancel:Create(message, callback)

    local ui = CMessageBoxOkCancel.new()
    if ui == nil or ui:Init(message,callback)==false then
        return nil
    end
    return ui
end

function CMessageBoxOkCancel:onEnter()
    self:AddReleaseEvent(function() if self.callback() then self.callback(true) end self:Close() end, "ButtonDetermine")
    self:AddReleaseEvent(function() if self.callback() then self.callback(false) end self:Close() end, "ButtonCancel")
    self:SetLabelText(self.message, "TextContent");
end

function CMessageBoxOkCancel:onExit()

end

return CMessageBoxOkCancel

--endregion
