--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require "dxm/ui/base_ui"

dxm = dxm or {}
dxm.CTopTouchMaskUI = class("dxm.CTopTouchMaskUI", dxm.CBaseUI)
local CTopTouchMaskUI = dxm.CTopTouchMaskUI

function CTopTouchMaskUI:ctor( void )
    CTopTouchMaskUI.super.ctor(self)
	self._open_ref = 0
end

function CTopTouchMaskUI:Init( opacity )
	local panel = ccui.Layout:create()
	if panel == nil then
		return false
	end
	panel:setContentSize(cc.size(720, 1160));
	panel:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid);
	panel:setBackGroundColorOpacity(opacity);
	panel:setBackGroundColor(cc.c3b(0,0,0));
	if dxm.CBaseUI.InitWithWidget(self, panel) == false then
    	return false
	end

	panel:setTouchEnabled(true);
	return true
end

function CTopTouchMaskUI:Create( opacity )
	local ui = CTopTouchMaskUI.new()
	if ui==nil or ui:Init(opacity)==false then	
		return nil
    end
	return ui
end

function CTopTouchMaskUI:Open(ui_order)
    if self._open_ref==0 then
        dxm.CUIManager:GetInstancePtr():OpenUI(self, ui_order)
    end
	self._open_ref = self._open_ref+1
end

function CTopTouchMaskUI:Close()
	self._open_ref = self._open_ref - 1;
	if self._open_ref==0 then
		self:RemoveFromParent()
    end
end

--endregion
