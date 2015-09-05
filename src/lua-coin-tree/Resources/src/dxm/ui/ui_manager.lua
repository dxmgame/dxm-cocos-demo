-- region NewFile_1.lua
-- Author : IBM
-- Date   : 2015/4/28
-- 此文件由[BabeLua]插件自动生成

require("dxm/common/singleton")
require("dxm/ui/layer_ui")
require "dxm/ui/top_touch_mask_ui"

dxm = dxm or { }
dxm.CUIManager = class("CUIManager")

dxm.UIOrder = {
	kUIOrderBackground = 1,
	kUIOrderStack = 2,
	kUIOrderShortcut = 3,
	kUIOrderGameDialog = 4,
	kUIOrderGuide = 5,
	kUIOrderSystemDialog = 6,
	kUIOrderNotice = 7,
	kUIOrderTopMask = 8,
	kUIOrderMax = 9,
};

local CUIManager = dxm.CUIManager
-- 单件申明
dxm.SINGLETON(CUIManager)

-- 构造函数
function CUIManager:ctor()
    self.layer_ui = nil
    self._shotcut_ui_list = {}
    self._short_ui_opened_list = {}
    self._notice_shotcut_ui_list = {}
    self._notice_short_ui_opened_list = {}
    -- 主界面
end

-- 成员函数
function CUIManager:InitLayerUIWithScene(scene)
    self.layer_ui = dxm.CLayerUI:Create()
    if self.layer_ui == nil then
        return nil
    end
    -- self.layer_ui:AttachParent(scene)
    return self.layer_ui
end

-- 打开界面
function CUIManager:OpenUI(ui, ui_order)
    self.layer_ui:AddChild(ui, ui_order)
end

-- 替换背景UI
function CUIManager:OpenBackgroundUI(ui)
    if self._background ~= nil then
        self._background:Close()
    end
    self._background = ui
    if ui ~= nil then
        self._background:Open()
    end
end
function CUIManager:CloseBackgroundUI()
    self:OpenBackgroundUI(self._default_background)
end
function CUIManager:SetDefaultBackgroundUI(ui)
    self._default_background = ui
end

-- 打开堆栈界面
function CUIManager:OpenStackUIWithPushTop(ui)

    if ui == nil then
        return nil
    end
            
    -- 推栈操作
    local old_stack_top_ui = self._stack_top_ui
    ui._pre_stack_ui = old_stack_top_ui
    self._stack_top_ui = ui
    self:_OpenStackUI(old_stack_top_ui)
end

function CUIManager:OpenStackUIWithPopTop()
    local old_stack_top_ui = nil
    if self._stack_top_ui then
        old_stack_top_ui = self._stack_top_ui
        self._stack_top_ui = old_stack_top_ui._pre_stack_ui
        old_stack_top_ui._pre_stack_ui = nil
    end
    
    if self._stack_top_ui == nil then
        self._stack_top_ui = self.default_stack_ui
    end
    self:_OpenStackUI(old_stack_top_ui)
end

function CUIManager:OpenStackUIWithReplaceTop(ui)
    if ui == nil then
        return nil
    end
    local old_stack_top_ui = self._stack_top_ui
    ui._pre_stack_ui = old_stack_top_ui._pre_stack_ui
    old_stack_top_ui._pre_stack_ui = nil
    self._stack_top_ui = ui
    self:_OpenStackUI(old_stack_top_ui)
end

function CUIManager:OpenStackUIWithClear(ui)
    if ui == nil then
        return nil
    end
    local old_stack_top_ui =  self._stack_top_ui
    local pop_stack_top_ui = old_stack_top_ui
    while pop_stack_top_ui ~= nil do
        self._stack_top_ui = pop_stack_top_ui._pre_stack_ui
        pop_stack_top_ui._pre_stack_ui = nil
        pop_stack_top_ui = self._stack_top_ui
    end
    self._stack_top_ui = ui
    self:_OpenStackUI(old_stack_top_ui)
end

function CUIManager:_OpenStackUI(old_top_ui)
    -- 关闭所有的快捷框;
    self:CloseAllShotcut()
    self:CloseAllNoticeShotcut()
    self:CloseBackgroundUI()

    if old_top_ui ~=nil then
        old_top_ui:RemoveFromParent()
    end
    if self._stack_top_ui ~=nil then
       self:OpenUI(self._stack_top_ui, dxm.UIOrder.kUIOrderStack)
    end
end

function CUIManager:SetDefaultStackUI(ui)
    self.default_stack_ui = ui
end

-- 打开置顶触摸界面
function CUIManager:LockTouch()
    self._top_touch_mask_ui = self._top_touch_mask_ui or dxm.CTopTouchMaskUI:Create(0)
    self._top_touch_mask_ui:Open(dxm.UIOrder.kUIOrderTopMask) 
end

function CUIManager:UnlockTouch()
    if self._top_touch_mask_ui then
        self._top_touch_mask_ui:Close()
    end
end

-- 打开对话框
function CUIManager:OpenDialogByGame(ui)
    local top_touch_mask_ui = dxm.CTopTouchMaskUI:Create(180)
    top_touch_mask_ui:Open(dxm.UIOrder.kUIOrderGameDialog)
    
    top_touch_mask_ui:AddChild(ui)
    ui.exit_callback = function()
        top_touch_mask_ui:Close()
    end
end

function CUIManager:OpenDialogBySystem(ui)
    local top_touch_mask_ui = dxm.CTopTouchMaskUI:Create(180)
    top_touch_mask_ui:Open(dxm.UIOrder.kUIOrderSystemDialog)
    
    top_touch_mask_ui:AddChild(ui)
    ui.exit_callback = function()
        top_touch_mask_ui:Close()
    end
end

-- 打开快捷栏
function CUIManager:RegisterShortcut(name, ui)
    self._shotcut_ui_list = self._shotcut_ui_list or {}
    self._shotcut_ui_list[name]=ui
end

function CUIManager:OpenShortcut(name)
    local ui = self._shotcut_ui_list[name]
    if ui~=nil then
        self:OpenUI(ui, dxm.UIOrder.kUIOrderShortcut)
        self._short_ui_opened_list[name] = ui
    end
end

function CUIManager:CloseAllShotcut(name)
    
    for _, ui in pairs(self._short_ui_opened_list) do
        ui:RemoveFromParent()
    end
end

-- 打开通知快捷栏
function CUIManager:RegisterNoticeShortcut(name, ui)
    self._notice_shotcut_ui_list[name]=ui
end

function CUIManager:OpenNoticeShortcut(name)
    local ui = self._shotcut_ui_list[name]
    if ui~=nil then
        self:OpenUI(ui, dxm.UIOrder.kUIOrderShortcut)
        self._notice_short_ui_opened_list[name] = ui
    end
end

function CUIManager:CloseAllNoticeShotcut(name)
    for _, ui in pairs(self._notice_short_ui_opened_list) do
        ui:RemoveFromParent()
    end
end


return CUIManager
-- endregion
