-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

require "dxm/ui/base_ui"

dxm = dxm or { }
dxm.CDialogUI = class("dxm.CDialogUI", dxm.CBaseUI)
local CDialogUI = dxm.CDialogUI

function CDialogUI:ctor(void)
    CDialogUI.super.ctor(self)
end

function CDialogUI:Init()
    return true
end

function CDialogUI:Create()
    local ui = CDialogUI.new()
    if ui == nil or ui:Init() == false then
        return nil
    end
    return ui
end

function CDialogUI:Open(dont_action)
    dxm.CUIManager:GetInstancePtr():OpenDialogByGame(self)
    if not dont_action then
        self:_DoAction()
    end
end

function CDialogUI:OpenBySystem()
    dxm.CUIManager:GetInstancePtr():OpenDialogBySystem(self)
end

function CDialogUI:Close()
    self:RemoveFromParent()
end

function CDialogUI:OnExit()
    if self.is_opening then
        dxm.CUIManager:GetInstancePtr():UnlockTouch()
    end
end

function CDialogUI:_DoAction()

    if self.widget == nil then
        return
    end
    self.widget:stopAllActions();

    -- 锚点居中;
    self.widget:setAnchorPoint(cc.p(0, 0))
    self.widget:setPosition(cc.p(0, 0))
    self.widget:setAnchorPoint(cc.p(0.5, 0.5))
    local x = self.widget:getPositionX() + self.widget:getContentSize().width / 2
    local y = self.widget:getPositionY() + self.widget:getContentSize().height / 2
    self.widget:setPosition(cc.p(x, y))

    local base_point_x = self.widget:getPositionX()
    local base_point_y = self.widget:getPositionY()

    -- 初始帧;		
    self.widget:setScale(0);
    self.widget:setPosition((cc.p(base_point_x, base_point_y)))

    local action_key_frame1 = cc.Spawn:create(cc.MoveTo:create(0.15, (cc.p(base_point_x, base_point_y))), cc.ScaleTo:create(0.15, 1.1, 1.2))
    local action_key_frame2 = cc.Spawn:create(cc.MoveTo:create(0.09, (cc.p(base_point_x, base_point_y))), cc.ScaleTo:create(0.09, 1.06, 0.93))
    local action_key_frame3 = cc.Spawn:create(cc.MoveTo:create(0.06, (cc.p(base_point_x, base_point_y))), cc.ScaleTo:create(0.06, 1, 1))

    dxm.CUIManager:GetInstancePtr():LockTouch()
    self._opening = true
    local action_key_frame4 = cc.CallFunc:create( function()
        dxm.CUIManager:GetInstancePtr():UnlockTouch()
        self._opening = false
    end )

    local popup_actions = cc.Sequence:create(action_key_frame1, action_key_frame2, action_key_frame3, action_key_frame4);

    self.widget:runAction(popup_actions);
end

-- endregion
