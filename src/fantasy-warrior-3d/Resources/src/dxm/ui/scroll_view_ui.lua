-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

require("dxm/ui/base_ui")

dxm = dxm or { }
dxm.CScrollViewUI = class("dxm.CScrollViewUI", dxm.CBaseUI)
local CScrollViewUI = dxm.CScrollViewUI

CScrollViewUI.SCROLLVIEW_DIR ={
    SCROLLVIEW_DIR_NONE=0,
    SCROLLVIEW_DIR_VERTICAL=1,
    SCROLLVIEW_DIR_HORIZONTAL=2,
    SCROLLVIEW_DIR_BOTH=3
}

function CScrollViewUI:ctor()
    CScrollViewUI.super.ctor(self)
    self.scroll_view = nil
    self.last_begin_index_ = 0
    self.last_end_index_ = 0
    self.scroll_view_size = { }
    self.scroll_view_size.width = 0
    self.scroll_view_size.height = 0
    self.fix_height = 0
    self.cell_ui_list = dxm.CList.new()
end

function CScrollViewUI:Dispose()
    CScrollViewUI.super.Dispose(self)

    if self.scroll_view ~= nil then
        self.scroll_view:release()
        self.scroll_view = nil
    end

    RemoveAllCell()
end

function CScrollViewUI:RemoveAllCells()

    local itor = self.cell_ui_list:Begin()

    local node = nil
    while true do
        local node = itor()
        if node == nil then break end
        local cell = node.value
        if cell ~= nil then
            cell:RemoveFromParent()
            cell:OnRemove()
        end
        self.cell_ui_list:Erase(node)
    end
end

function CScrollViewUI:Init(scroll_view)

    if scroll_view == nil then
        return false
    end

    -- self.scroll_view = tolua.cast(scroll_view, "ScrollView")
    self.scroll_view = scroll_view
    self.scroll_view:retain()

    return CScrollViewUI.super.InitWithWidget(self, self.scroll_view)
end

function CScrollViewUI:Create(scroll_view)

    local ui = CScrollViewUI.new()
    if ui == nil or ui:Init(scroll_view) == false then
        return nil
    end
    return ui
end

function CScrollViewUI:AddCell(cell)

    if cell==nil then return end
    self.cell_ui_list:PushBack(cell)
end

function CScrollViewUI:_GetInnerHeight()
    local itor = self.cell_ui_list:Begin()
    local node = nil
    local sum_height = 0
    while true do
        local node = itor()
        if node == nil then break end
        local cell = node.value
        if cell ~= nil then
            sum_height = sum_height + cell:GetContentSize().height
        end
    end
    return sum_height
end

function CScrollViewUI:_GetInnerWidth()
    local itor = self.cell_ui_list:Begin()
    local node = nil
    local sum_width = 0
    while true do
        local node = itor()
        if node == nil then break end
        local cell = node.value
        if cell ~= nil then
            sum_width = sum_width + cell:GetContentSize().width
        end
    end
    return sum_width
end

function CScrollViewUI:InitPosition()
    local scroll_view_direction = self.scroll_view:getDirection();
    if self.scroll_view:getDirection() == CScrollViewUI.SCROLLVIEW_DIR.SCROLLVIEW_DIR_HORIZONTAL  then
      self:_InitPositionHorizontal()
    else
      self:_InitPositionVertical()
    end
end

function CScrollViewUI:_InitPositionVertical()
  
    -- 初始化cell位置;
    local height = self.fix_height
    local itor = self.cell_ui_list:End()
    while true do
        local node = itor()
        if node == nil then break end
        local cell = node.value
        if cell ~= nil then
            cell:SetPosition(0, height)
            height = height + cell:GetContentSize().height
        end
    end

    -- 初始化滚动层大小
    local inner_height = height
    if inner_height >= self.scroll_view:getContentSize().height then
        self.scroll_view:setInnerContainerSize(CCSize(self.scroll_view:getInnerContainerSize().width, inner_height))
        self.scroll_view:setSize(self.scroll_view:getSize())
    else
        local delta = self.scroll_view:getContentSize().height - inner_height;
        local itor = self.cell_ui_list:Begin()
        while true do
            local node = itor()
            if node == nil then break end
            local cell = node.value
            if cell ~= nil then
                cell:SetPosition(0, cell.position.y+delta)
            end
        end
    end

    -- 滚动到顶部
    self.scroll_view:setBounceEnabled(true)
    self.scroll_view:jumpToTop()
end

function CScrollViewUI:_InitPositionHorizontal()
    -- 初始化cell位置;
    local width = 0
    local itor = self.cell_ui_list:Begin()
    while true do
        local node = itor()
        if node == nil then break end
        local cell = node.value
        if cell ~= nil then
            cell:SetPosition(width, 0)
            width = width + cell:GetContentSize().width
        end
    end

    -- 初始化滚动层大小
    local inner_width = width
    if inner_width >= self.scroll_view:getContentSize().width then
        self.scroll_view:setInnerContainerSize(CCSize(inner_width, self.scroll_view:getInnerContainerSize().height))
        self.scroll_view:setSize(self.scroll_view:getSize())
--    else
--        local delta = self.scroll_view:getcontentsize().width - inner_width;
--        itor = self.cell_ui_list:begin()
--        while true do
--            local node = itor()
--            if node == nil then break end
--            local cell = node.value
--            if cell ~= nil then
--                cell:setposition(cell.position.x+delta, 0)
--            end
--        end
    end

    -- 滚动到左边
    self.scroll_view:setBounceEnabled(true)
    self.scroll_view:jumpToLeft()
end

function CScrollViewUI:Update(dt)
    if self.scroll_view==nil or self.cell_ui_list.size==0 then return end

    if self.scroll_view:getDirection() == CScrollViewUI.SCROLLVIEW_DIR.SCROLLVIEW_DIR_HORIZONTAL  then
      self:_UpdateHorizontal()
    else
      self:_UpdateVertical()
    end
end

function CScrollViewUI:_UpdateVertical( )

    -- 获取显示区域;
    local display_bottom_y = - self.scroll_view:getInnerContainer():getPositionY()
    local display_top_y = display_bottom_y + self.scroll_view:getContentSize().height
    
    -- 更新显示;
    local itor = self.cell_ui_list:Begin()
    while true do
        local node = itor()
        if node == nil then break end

        local cell = node.value
        local cell_bottom_y = cell.position.y;
        local cell_top_y = cell_bottom_y + cell:GetContentSize().height
        local cell_bottom_in_display = cell_bottom_y>=display_bottom_y and display_bottom_y<=display_top_y
        local cell_top_in_display = cell_top_y>=display_bottom_y and cell_top_y<=display_top_y

        if  cell_bottom_in_display or cell_top_in_display then
            if cell.is_entered==false then
                self:AddChild(cell)
            end
        else
             if cell.is_entered==true then
                self:RemoveChild(cell)
            end
        end
    end
end

function CScrollViewUI:_UpdateHorizontal( )
    -- 获取显示区域;
    local display_left_x = -self.scroll_view:getInnerContainer():getPositionX()
    local display_right_x = display_left_x + self.scroll_view:getContentSize().width
    
    -- 更新显示;
    local itor = self.cell_ui_list:Begin()
    while true do
        local node = itor()
        if node == nil then break end

        local cell = node.value
        local cell_left_x = cell.position.x;
        local cell_right_x = cell_left_x + cell:GetContentSize().width
        local cell_left_in_display = cell_left_x>=display_left_x and cell_left_x<=display_right_x
        local cell_right_in_display = cell_right_x>=display_left_x and cell_right_x<=display_right_x

        if  cell_left_in_display or cell_right_in_display then
            if cell.is_entered==false then
                self:AddChild(cell)
            end
        else
             if cell.is_entered==true then
                self:RemoveChild(cell)
            end
        end
    end
end

function CScrollViewUI:onEnter( )
	CScrollViewUI.super.onEnter(self)

    self.update_entry = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt) self:Update(dt) end, 0, false)
end

function CScrollViewUI:onExit( )
	CScrollViewUI.super.onExit(self)
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.update_entry)
end

return CScrollViewUI

--endregion