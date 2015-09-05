--region NewFile_1.lua
--Author : IBM
--Date   : 2015/4/27
--此文件由[BabeLua]插件自动生成

require("dxm/ui/base_ui")

dxm = dxm or {}
dxm.CLayerUI = class("CLayerUI", dxm.CBaseUI)

local CLayerUI = dxm.CLayerUI

function CLayerUI:ctor()
    CLayerUI.super.ctor(self)
end

function CLayerUI:Dispose()
    self:_ClearUI()
end

function CLayerUI:Init()
    return CLayerUI.super.Init(self)
end

-- 成员函数
function CLayerUI:Create()
    local layer_ui = CLayerUI.new()
    layer_ui:Init()
    return layer_ui
end

function CLayerUI:AttachParent(parent)
    parent:addChild(self.widget)
	self:_Enter()
end

function CLayerUI:DetachParent()
    self:_Exit()
    self.widget:removeFromParent()
end

return CLayerUI

--endregion
