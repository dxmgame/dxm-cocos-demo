-- region NewFile_1.lua
-- Author : IBM
-- Date   : 2015/4/27
-- 此文件由[BabeLua]插件自动生成

require("dxm/ui/widget_cache_manager")
require("dxm/ui/widget_action_cache_manager")

dxm = dxm or { }
dxm.CBaseUI = class("CBaseUI")

local CBaseUI = dxm.CBaseUI

CBaseUI.WidgetType =
{
    invalid = 0,
    -- 无效的类型
    config = 1,
    -- 从配置中获取的widget
    custom = 2,
    -- 不含parent的widget, 该widget在被清理前需要RemoveFromParent
    part = 3,
    -- 含parent的widget, 该widget在被清理前不需要RemoveFromParent
    max = 4,
}

-- 构造函数
function CBaseUI:ctor()
    self.widget = nil
    -- widget_对象
    self.node = nil
    -- 配置节点
    self.widget_type = CBaseUI.WidgetType.invalid
    -- widget_的类型
    self.widget_config = ""
    -- widget配置名称;
    self.parent_base_ui = nil
    -- 父CBaseUI;
    self.parent_widget = nil
    -- 父widget;
    self.ui_children = { }
    -- 挂接在本UI上的其他UI; ui_children_[widget] = base_ui_list
    self.is_entered = false
    -- 是否开启
    self.position = nil
end

function CBaseUI:Root()
    local root = self.node or self.widget
    return root
end

-- 析构函数
function CBaseUI:Dispose()
    self:_ClearUI()
end

-- 初始化函数
function CBaseUI:Init()
    -- 已初始化;
    if self.widget ~= nil then
        return false
    end
    self:set_widget(ccui.Widget:create())
    return true
end

function CBaseUI:InitWithWidget(widget)
    -- 界面参数无效
    if widget == nil then
        return false
    end
    -- 已初始化;
    if self.widget ~= nil then
        return false
    end
    self:set_widget(widget)
    return true
end

function CBaseUI:InitWithFile(config)
    -- 已初始化;
    if self.widget ~= nil then
        return false;
    end
    self.widget_config = config
    self.widget_type = CBaseUI.WidgetType.config
    return true
end

-- 创建函数
function CBaseUI:Create()
    local ui = CBaseUI.new()
    ui:Init()
    return ui
end

-- 从配置中来的创建函数
function CBaseUI:CreateFromFile(name)
    local ui = CBaseUI.new()
    ui:InitWithFile(name)
    return ui
end

-- 重置widget
function CBaseUI:set_widget(widget)

    if self.widget == widget then
        return
    end

    -- 清理界面
    self:_ClearUI()

    -- 重置新界面
    self.widget = widget
    if widget == nil then
        self.widget_type = CBaseUI.WidgetType.invalid
        return
    end

    self.widget:retain()

    if self.widget:getParent() ~= nil then
        self.widget_type = CBaseUI.WidgetType.part
    else
        self.widget_type = CBaseUI.WidgetType.custom
    end
end

function CBaseUI:GetContentSize()    
    
    if self.content_size == nil then
        self.content_size = { width=0, height=0 }
        if self.widget==nil then
            if self.widget_type == CBaseUI.WidgetType.config then
                self:_InitConfigWidget()
                if self.widget~=nil then
                    self.content_size.width = self.widget:getContentSize().width
                    self.content_size.height = self.widget:getContentSize().height
                end
                self:_ClearUI()
            end
        else
            self.content_size.width = self.widget:getContentSize().width
            self.content_size.height = self.widget:getContentSize().height
        end
    end
    return self.content_size
end


function CBaseUI:_ClearUI()

    -- 清理所有的子UI;
    self:RemoveAllChildren()

    -- 清理物理widget;
    self:RemoveFromParent()

    -- 回收物理widget;
    if self.node and self.widget_type == CBaseUI.WidgetType.config then
        dxm.CWidgetCacheManager:GetInstancePtr():AddWidget(self.widget_config, self.node);
    end

    if self.action and self.widget_type == CBaseUI.WidgetType.config then
        dxm.CWidgetActionCacheManager:GetInstancePtr():AddAction(self.widget_config, self.action);
    end

    -- 析构widget;
    if self.widget ~= nil then
        self.widget:release()
        self.widget = nil
    end

    if self.node ~= nil then
        self.node:release()
        self.node = nil
    end

    if self.action ~= nil then
        self.action:release()
        self.action = nil
    end
end

function CBaseUI:_InitConfigWidget()
    -- 创建界面一枚;
    local node = dxm.CWidgetCacheManager:GetInstancePtr():GetWidget(self.widget_config)
    if node == nil then
        return
    end

    local action = dxm.CWidgetActionCacheManager:GetInstancePtr():GetAction(self.widget_config)
    if action == nil then
        return
    end

    -- local widget = node:getChildByTag(5)
    local widget = node
    widget:runAction(action)

    -- 初始化界面;
    widget:setVisible(true)
    widget:setOpacity(255)
    widget:setColor(cc.c3b(255, 255, 255))
    widget:setAnchorPoint(cc.p(0, 0))
    widget:setPosition(cc.p(0, 0))
    widget:setScale(1.0)
    widget:setRotation(0)

    -- 设置界面;
    self.widget = widget
    self.widget:retain()
    self.node = node
    self.node:retain()
    self.action = action
    self.action:retain()
end

function CBaseUI:SetPosition(x, y)
    self.position = self.position or {}
    self.position.x = x
    self.position.y = y
end

-- 打开与关闭事件
function CBaseUI:_Enter()

    if self.is_entered == true then
        return
    end

    self.is_entered = true;

    -- 设置位置
    if self.position ~=nil then
        self.widget:setPosition(ccp(self.position.x, self.position.y))
    end

    -- 执行配置回调
    self:onEnter()
    if self.enter_callback ~= nil then
        self.enter_callback()
    end
end

function CBaseUI:_Exit()

    if self.is_entered == false then
        return
    end

    -- 执行配置回调
    self:onExit()

    -- 执行子元素清理;
    for _, temp_ui_list in pairs(self.ui_children) do
        for _, temp_ui in pairs(temp_ui_list) do
            temp_ui:_Exit()
        end
    end

    -- Config类型的需要清理
    if self.widget_type == CBaseUI.WidgetType.config then
        self:_ClearUI()
    end

    self.is_entered = false;

    if self.exit_callback ~= nil then
        self.exit_callback()
    end
end

function CBaseUI:onEnter()
    -- 虚函数
end

function CBaseUI:onExit()
    -- 虚函数
end

-- 子节点托管操作
function CBaseUI:AddChild(base_ui, zorder)

    zorder = zorder or 0

    if self.widget == nil then
        return
    end
    self:AddChildWithWidget(self.widget, base_ui, zorder)
end

function CBaseUI:AddChildWithWidgetName(widget_name, base_ui, zorder)

    zorder = zorder or 0

    if self.widget == nil then
        return
    end

    -- local widget = self.widget:getChildByName(widget_name)
    local widget = ccui.Helper:seekWidgetByName(self.widget, widget_name)
    if widget == nil then
        return
    end

    self:AddChildWithWidget(widget, base_ui, zorder)
end

function CBaseUI:AddChildWithWidget(widget, base_ui, zorder)

    if self.is_entered == false or widget == nil or base_ui == nil then
        return
    end

    zorder = zorder or 0

    -- 初始化配置界面;
    if base_ui.widget_type == CBaseUI.WidgetType.config then
        base_ui:_InitConfigWidget()
    end

    -- base_ui没有子节点挂接失败
    if base_ui.widget == nil then
        return
    end

    -- 创建链表;
    local base_ui_list = self:CreateList(widget)

    -- 判断是否已经存在;
    for _, temp_ui in pairs(base_ui_list) do
        if temp_ui == base_ui then
            return
        end
    end

    -- 正式挂接, part类型的不要做添加操作;
    if base_ui.widget_type ~= CBaseUI.WidgetType.part then
        widget:addChild(base_ui:Root(), zorder)
    end

    -- 添加到管理
    base_ui_list[base_ui] = base_ui
    base_ui:SetParent(self, widget)

    -- 父节点已经进入场景，子节点则执行OnEnter
    base_ui:_Enter()
end

function CBaseUI:RemoveAllChildren()

    if self.widget == nil then
        return
    end

    -- 判断是否已经存在;
    for temp_widget, temp_ui_list in pairs(self.ui_children) do

        -- 清空链表;
        for _, temp_ui in pairs(temp_ui_list) do

            temp_widget:removeChild(temp_ui.widget)
            temp_ui:SetParent(nil, nil)

            -- 触发事件
            if self.is_entered then
                temp_ui:_Exit()
            end

            temp_ui:_ClearUI()
        end
    end
    self.ui_children = { }
end

function CBaseUI:RemoveAllChildrenWithWidgetName(widget_name)

    if self.widget == nil then
        return
    end

    -- local widget = self.widget:getChildByName(widget_name)
    local widget = ccui.Helper:seekWidgetByName(self.widget, widget_name)
    if widget == nil then
        return;
    end
    self:RemoveAllChildrenWithWidget(widget, base_ui)
end

function CBaseUI:RemoveAllChildrenWithWidget(widget)

    if widget == nil then
        return
    end

    -- 获取链表;
    local base_ui_list = self:GetList(widget)
    if base_ui_list == nil then
        return
    end

    -- 判断是否已经存在;
    for _, temp_ui in pairs(base_ui_list) do
        base_ui_list[temp_ui] = nil
        if temp_ui.wiget_type ~= CBaseUI.WidgetType.part then
            widget:removeChild(temp_ui.widget)
        end
        temp_ui:SetParent(nil, nil);
        if self.is_entered == true then
            temp_ui:_Exit()
        end

        temp_ui:Dispose()
        break
    end
    base_ui_list = {}
end

function CBaseUI:RemoveChild(base_ui)

    if self.widget == nil then
        return
    end
    self:RemoveChildWithWidget(self.widget, base_ui)
end

function CBaseUI:RemoveChildWithWidgetName(widget_name, base_ui)

    if self.widget == nil then
        return
    end

    -- local widget = self.widget:getChildByName(widget_name)
    local widget = ccui.Helper:seekWidgetByName(self.widget, widget_name)
    if widget == nil then
        return;
    end
    self:RemoveChildWithWidget(widget, base_ui)
end

function CBaseUI:RemoveChildWithWidget(widget, base_ui)

    if widget == nil then
        return
    end

    -- 获取链表;
    local base_ui_list = self:GetList(widget)
    if base_ui_list == nil then
        return
    end

    -- 判断是否已经存在;
    for _, temp_ui in pairs(base_ui_list) do
        if temp_ui == base_ui then

            base_ui_list[temp_ui] = nil
            if temp_ui.wiget_type ~= CBaseUI.WidgetType.part then
                widget:removeChild(temp_ui:Root())
            end
            temp_ui:SetParent(nil, nil);
            if self.is_entered == true then
                temp_ui:_Exit()
            end

            temp_ui:Dispose()
            break
        end
    end
end

function CBaseUI:RemoveFromParent()

    if self.parent_base_ui ~= nil and self.parent_widget ~= nil then
        self.parent_base_ui:RemoveChildWithWidget(self.parent_widget, self)
    end
end

function CBaseUI:CreateList(widget)

    local list = self.ui_children[widget]
    if list == nil then
        list = { }
        self.ui_children[widget] = list
    end
    return list
end

function CBaseUI:GetList(widget)
    return self.ui_children[widget]
end

function CBaseUI:SetParent(base_ui, widget)
    self.parent_base_ui = base_ui
    self.parent_widget = widget
end

function CBaseUI:GetWidget(...)
    return self:GetWidgetFromWidget(self.widget, ...)
end

function CBaseUI:GetWidgetFromWidget(widget, ...)
    if widget == nil then
        return nil
    end

    local arg = {...}
    local temp_widget = widget
    for _, v in ipairs(arg) do
        -- temp_widget = temp_widget:getChildByName(v)
        temp_widget = ccui.Helper:seekWidgetByName(temp_widget, v)
        if temp_widget == nil then
            return nil
        end
    end
    return temp_widget
end

-- 设置显示性
function CBaseUI:SetWidgetVisible(is_visible, ...)
    self:SetWidgetVisibleFromWidget(is_visible, self.widget, ...)
end

function CBaseUI:SetWidgetVisibleFromWidget(is_visible, widget, ...)
    local widget = self:GetWidgetFromWidget(widget, ...)
    if widget ~= nil then
        widget:setVisible(is_visible)
    end
end

-- 设置有效性
function CBaseUI:SetWidgetEnable(is_enable, ...)
    self:SetWidgetEnableFromWidget(is_enable, self.widget, ...)
end

function CBaseUI:SetWidgetEnableFromWidget(is_enable, widget, ...)
    local widget = self:GetWidgetFromWidget(widget, ...)
    if widget ~= nil then
        widget:setEnabled(is_enable)
    end
end

-- 设置有效性与显示性
function CBaseUI:SetWidgetEnableAndVisible(is_enable, ...)
    self:SetWidgetEnableAndVisibleFromWidget(is_enable, self.widget, ...)
end

function CBaseUI:SetWidgetEnableAndVisibleFromWidget(is_enable, widget, ...)
    local widget = self:GetWidgetFromWidget(widget, ...)
    if widget ~= nil then
        widget:setEnabled(is_enable)
        widget:setVisible(is_enable)
    end
end

-- 设置图片
function CBaseUI:SetImageViewPicture(path, ...)
    self:SetImageViewPictureFromWidget(path, self.widget, ...)
end

function CBaseUI:SetImageViewPictureFromWidget(path, widget, ...)
    -- local image_view = tolua.cast(self:GetWidgetFromWidget(widget, ...), "ImageView")
    if image_view ~= nil then
        image_view:loadTexture(path)
    end
end

-- 设置文字
function CBaseUI:SetLabelText(text, ...)
    self:SetLabelTextFromWidget(text, self.widget, ...)
end

function CBaseUI:SetLabelTextFromWidget(text, widget, ...)
    local label =self:GetWidgetFromWidget(widget, ...)
    if label ~= nil then
        label:setString(text)
    end
end

-- 设置Atlas文字
function CBaseUI:SetAtlasLabelText(text, ...)
    self:SetAtlasLabelTextFromWidget(text, self.widget, ...)
end

function CBaseUI:SetAtlasLabelTextFromWidget(text, widget, ...)
    local label_atlas = self:GetWidgetFromWidget(widget, ...)
    if label_atlas ~= nil then
        label_atlas:setStringValue(text)
    end
end

-- 设置进度条
function CBaseUI:SetLoadingbarPercent(percent, ...)
    self:SetLoadingbarPercentFromWidget(percent, self.widget, ...)
end

function CBaseUI:SetLoadingbarPercentFromWidget(percent, widget, ...)
    local loading_bar = self:GetWidgetFromWidget(widget, ...)
    if label_atlas ~= nil then
        label_atlas:setPercent(text)
    end
end

-- 设置触摸事件;
function CBaseUI:AddReleaseEvent(event_func, ...)
    self:AddReleaseEventFromWidget(event_func, self.widget, ...)
end

function CBaseUI:AddReleaseEventFromWidget(event_func, widget, ...)
    local widget = self:GetWidgetFromWidget(widget, ...)
    if widget ~= nil then
        widget:addClickEventListener(event_func)
        widget:setTouchEnabled(true)
    end
end

-- 取消触摸事件;
function CBaseUI:RemoveReleaseEvent(...)
    self:RemoveReleaseEventFromWidget(self.widget, ...)
end

function CBaseUI:RemoveReleaseEventFromWidget(widget, ...)
    local widget = self:GetWidgetFromWidget(widget, ...)
    if widget ~= nil then
        widget:setTouchEnabled(false)
    end
end

-- 设置输入框及关联的触摸区域
function CBaseUI:SetTextFieldTouchWidget(text_field, ...)
    -- local text_field = tolua.cast(text_field, "TextField")
    if text_field ~= nil then
        local function ReleaseCallback(sender)
            text_field:attachWithIME()
        end
        self:AddReleaseEvent(ReleaseCallback, ...)
    end
end

-- 播放动画
function CBaseUI:Play(animation_name, loop)
    self.action:play(animation_name, loop)
end

return CBaseUI

-- endregion
