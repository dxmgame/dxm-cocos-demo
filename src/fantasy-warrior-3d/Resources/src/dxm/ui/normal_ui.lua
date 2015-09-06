-- region *.lua
-- Author : IBM
-- Date   : 2015/4/28
-- 此文件由[BabeLua]插件自动生成

require "dxm/ui/ui_manager.lua"

dxm = dxm or { }
dxm.CNormalUI = class("CNormalUI", dxm.CBaseUI)

dxm.CBackgroundUI = dxm.CNormalUI
dxm.CShortcutUI = dxm.CNormalUI
dxm.CNoticeShortcutUI = dxm.CNormalUI
dxm.CGuideUI = dxm.CNormalUI

local CNormalUI = dxm.CNormalUI

function CNormalUI:ctor()
    CNormalUI.super.ctor(self)
end

function CNormalUI:Create()
    local ui = CNormalUI.new()
    if ui == nil or ui:Init() == false then
        return nil
    end
    return ui
end

function CNormalUI:Open(ui_order)
    dxm.CUIManager:GetInstancePtr():Open(self, ui_order)
end

function CNormalUI:Close()
    self:RemoveFromParent()
end

return CNormalUI

-- endregion
