--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("dxm/common/singleton")
require("dxm/data_structures/list")

dxm = dxm or {}
dxm.CWidgetCache = class("CWidgetCache")

local CWidgetCache = dxm.CWidgetCache

-- 成员函数
function CWidgetCache:ctor(config)

    self.config = config -- 配置名称
    self.template_widget = nil -- 模版界面
    self.widget_list = dxm.CList.new() -- 缓存对象列表
    self.widget_count = 1 -- 缓存构建数量

    -- local widget = GUIReader:shareReader():widgetFromJsonFile("ui/"..self.config..".json")
    local widget = self:LoadWidget()
    if widget ~= nil then
         widget:removeFromParent()
        -- 模版要被克隆，是为了兼容ActionList的设计缺陷，只有widgetFromJsonFile函数产生的UIWidget才可以正常使用动画;
        self.template_widget = widget:clone()
        self.template_widget:retain()

        self:Add(widget)
    else 
        print("[CWidgetCache] widgetFromJsonFile ",self.config," failed, there isnt child tag 5")
    end
end

function CWidgetCache:LoadWidget()
    local node = cc.CSLoader:createNode("res/"..self.config..".csb")
    if node ==nil then
        print("[CWidgetCache] widgetFromJsonFile ", self.config, " failed")
        return
    end

     -- 自适应代码
    node:setContentSize(cc.size(display.width,display.height))
    ccui.Helper:doLayout(node)

    local widget = node:getChildByTag(5)
    return widget
end

function CWidgetCache:CloneWidget()
    -- return self.template_widget:clone()
    return self:LoadWidget()
end

function CWidgetCache:Dispose()

    if self.template_widget ~= nil then
        self.template_widget:release()
    end

    -- 判断是否已经存在;
    local node = self.widget_list.first
    while node ~= nil do

        local widget = node.value
        if widget ~= nil then
            widget:release()
        end
        node = node.next
    end
    self.widget_list:Clear()
end

function CWidgetCache:Add(widget)

    if widget == nil then
        return
    end
    widget:retain()
    self.widget_list:PushBack(widget)
end

function CWidgetCache:Cache(count)

    if self.template_widget == nil then
        return
    end

    local real_count = count - self.widget_list.size
    for i=1,real_count do
        
        local widget = self:CloneWidget()
        if widget ~= nil then
            widget:retain()
            self.widget_list:PushBack(widget)
            self.widget_count = self.widget_count + 1
        end
    end
end

function CWidgetCache:Get()

    if self.template_widget == nil then
        return nil
    end

    -- 从缓存列表中抽取一枚
    local widget = self.widget_list:PopFront()

    -- 缓存列表已被使用完
    if widget == nil then
		widget = self:CloneWidget()
        self.widget_count = self.widget_count + 1
        print("[CWidgetCache] clone ui_widget "..self.config.."(ref:"..self.widget_count..")")
    end

    return widget
end

dxm.CWidgetCacheManager = class("CWidgetCacheManager")

local CWidgetCacheManager = dxm.CWidgetCacheManager
dxm.SINGLETON(CWidgetCacheManager)

-- 构造函数
function CWidgetCacheManager:ctor()
    self.gc_size = 10 -- gc容量
    self.gc_interval = 1 -- gc间隔
    self.gc_tick = 0 -- gc时间
    self.gc_widget_cache_list = dxm.CList.new() -- GC缓存链表

    self.widget_cache_map = {} -- 临时缓存表单，无用时会被GC
    self.register_widget_cache_map = {} -- 注册缓存表单

    local function Update(dt)
        self:UpdateGC(dt)
    end
    cc.Director:sharedDirector():getScheduler():scheduleScriptFunc(Update, 0, false)
end

function CWidgetCacheManager:Dispose()
    -- TODO:
end

function CWidgetCacheManager:GetWidget(config)

    local widget_cache = self:GetWidgetCache(config)
    print("[CWidgetCache] GetCache"..widget_cache.config)
    return widget_cache:Get()
end

function CWidgetCacheManager:CacheWidget(config, count)

    local widget_cache = self:GetWidgetCache(config)
    if widget_cache == nil then
        return
    end

    print("[CWidgetCache] GetCache:"..widget_cache.config)
    widget_cache:Cache(count)

    self.register_widget_cache_map[config] = widget_cache
end

function CWidgetCacheManager:UncacheWidget(config)

    local widget_cache = self.register_widget_cache_map[config]
    if widget_cache ~= nil then
        widget_cache:Dispose()
    end
    self.register_widget_cache_map[config] = nil
end

function CWidgetCacheManager:AddWidget(config, widget)

    local widget_cache = self:GetWidgetCache(config)
    if widget_cache == nil then
        return
    end
    widget_cache:Add(widget)
end

function CWidgetCacheManager:GetWidgetCache(config)

    local widget_cache = self.widget_cache_map[config]
    if widget_cache ~= nil then
        return widget_cache
    end

    widget_cache = self:PopFromGC(config)
    if widget_cache ~= nil then
        return widget_cache
    end

    widget_cache = CWidgetCache.new(config)
    self.widget_cache_map[config] = widget_cache

    return widget_cache
end

function CWidgetCacheManager:UpdateGC(dt)

    -- 累计时间，判断是否到达自动回收
    self.gc_tick = self.gc_tick + dt
    if self.gc_tick < self.gc_interval then
        return
    end
	self.gc_tick = 0

    -- 检测界面回收
    for config, temp_widget_cache in pairs(self.widget_cache_map) do

        -- 判断缓存界面是否全部被回收
        if temp_widget_cache ~= nil and temp_widget_cache.widget_list.size == temp_widget_cache.widget_count then
            self:Push2GC(config, temp_widget_cache);
            self.widget_cache_map[config] = nil
            break
        end
    end

    -- 清理超过部分
    while self.gc_widget_cache_list.size > self.gc_size do

        local widget_cache = self.gc_widget_cache_list:PopFront()
        if widget_cache ~= nil then
            print("[CWidgetCache] gc widget:"..widget_cache.config)
            widget_cache:Dispose()
        end
    end
end

function CWidgetCacheManager:Push2GC(config, widget_cache)
    -- 添加到链表中
    self.gc_widget_cache_list:PushBack(widget_cache)
end

function CWidgetCacheManager:PopFromGC(config)

    -- 链表中搜索对应的缓存
    local node = self.gc_widget_cache_list.first
    while node ~= nil do

        -- 判断名称是否一致
        local widget_cache = node.value
        if widget_cache.config == config then

            self.widget_cache_map[config] = widget_cache
            self.gc_widget_cache_list:Erase(node)
            return widget_cache
        end
        node = node.next
    end
    return nil
end

return CWidgetCacheManager

--endregion
