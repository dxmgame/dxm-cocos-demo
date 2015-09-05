--region *.lua
--Author : IBM
--Date   : 2015/4/28
--此文件由[BabeLua]插件自动生成

require "dxm/ui/ui_manager.lua"

dxm = dxm or {}
dxm.CStackUI = class("CStackUI", dxm.CBaseUI)

local CStackUI = dxm.CStackUI

function CStackUI:ctor()
    CStackUI.super.ctor(self)
end

function CStackUI:Create()
    local ui = CStackUI.new()
    if ui == nil or ui:Init() == false then
        return nil
    end
    return ui
end

function CStackUI:OpenWithReplaceTop()
    -- 关闭老的，打开新的
    dxm.CUIManager:GetInstancePtr():OpenStackUIWithReplaceTop(self)
end

function CStackUI:Open()
    -- 关闭老的，打开新的
    dxm.CUIManager:GetInstancePtr():OpenStackUIWithPushTop(self)
end

function CStackUI:OpenWithClearStack()
    -- 关闭老的，打开新的
    dxm.CUIManager:GetInstancePtr():OpenStackUIWithClear(self)
end

function CStackUI:Close()
    -- 关闭新的，打开老的
    dxm.CUIManager:GetInstancePtr():OpenStackUIWithPopTop()
end

return CStackUI

--endregion
