--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

game.CMessageBoxRetry = class("game.CMessageBoxRetry", dxm.CDialogUI)

local CMessageBoxRetry = game.CMessageBoxRetry

function CMessageBoxRetry:ctor()
    CMessageBoxRetry.super.ctor(self)
end

function CMessageBoxRetry:Init(message, callback)
    
    self.callback = callback
    self.message = message
    return self:InitWithFile("Tip")
end

function CMessageBoxRetry:Create(message, callback)

    local ui = CMessageBoxRetry.new()
    if ui == nil or ui:Init(message, callback)==false then
        return nil
    end
    return ui
end

function CMessageBoxRetry:onEnter()
    self:AddReleaseEvent(function() if self.callback() then self.callback() end self:Close() end, "ButtonConnect")
    self:SetLabelText(self.message, "TextContent");
end

function CMessageBoxRetry:onExit()
    
end

return CMessageBoxRetry

--endregion
