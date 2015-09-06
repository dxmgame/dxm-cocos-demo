--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require("dxm/common/singleton")
require("dxm/data_structures/list")

dxm = dxm or {}
dxm.CWidgetActionCache = class("CWidgetActionCache")

local CWidgetActionCache = dxm.CWidgetActionCache

-- 成员函数
function CWidgetActionCache:ctor(config)

    self.config = config -- 配置名称
    self.template_action = nil -- 模版界面
    self.action_list = dxm.CList.new() -- 缓存对象列表
    self.action_count = 1 -- 缓存构建数量

    -- local action = GUIReader:shareReader():actionFromJsonFile("ui/"..self.config..".json")
    local action = cc.CSLoader:createTimeline("res/"..self.config..".csb")
    if action ~= nil then

        -- 模版要被克隆，是为了兼容ActionList的设计缺陷，只有actionFromJsonFile函数产生的UIAction才可以正常使用动画;
        self.template_action = action:clone()
        self.template_action:retain()
        self:Add(action)
    else 
        print("[CWidgetActionCache] actionFromJsonFile "..self.config.." failed")
    end
end

function CWidgetActionCache:Dispose()

    if self.template_action ~= nil then
        self.template_action:release()
    end

    -- 判断是否已经存在;
    local node = self.action_list.first
    while node ~= nil do

        local action = node.value
        if action ~= nil then
            action:release()
        end
        node = node.next
    end
    self.action_list:Clear()
end

function CWidgetActionCache:Add(action)

    if action == nil then
        return
    end
    -- 由于action不可做重复利用，这里做清理处理
    action:retain()
    self.action_list:PushBack(action)
    -- self.action_count = self.action_count-1
end

function CWidgetActionCache:Cache(count)

    if self.template_action == nil then
        return
    end

    local real_count = count - self.action_list.size
    for i=1,real_count do
        
        local action = self.template_action:clone()
        if action ~= nil then
            action:retain()
            self.action_list:PushBack(action)
            self.action_count = self.action_count + 1
        end
    end
end

function CWidgetActionCache:Get()

    if self.template_action == nil then
        return nil
    end

    -- 从缓存列表中抽取一枚
    local action = self.action_list:PopFront()

    -- 缓存列表已被使用完
    if action == nil then
		action = self.template_action:clone()
        self.action_count = self.action_count + 1
        print("[CWidgetActionCache] clone ui_action "..self.config.."(ref:"..self.action_count..")")
    end

    return action
end

dxm.CWidgetActionCacheManager = class("CWidgetActionCacheManager")

local CWidgetActionCacheManager = dxm.CWidgetActionCacheManager
dxm.SINGLETON(CWidgetActionCacheManager)

-- 构造函数
function CWidgetActionCacheManager:ctor()
    self.gc_size = 10 -- gc容量
    self.gc_interval = 1 -- gc间隔
    self.gc_tick = 0 -- gc时间
    self.gc_action_cache_list = dxm.CList.new() -- GC缓存链表

    self.action_cache_map = {} -- 临时缓存表单，无用时会被GC
    self.register_action_cache_map = {} -- 注册缓存表单

    local function Update(dt)
        self:UpdateGC(dt)
    end
    cc.Director:sharedDirector():getScheduler():scheduleScriptFunc(Update, 0, false)
end

function CWidgetActionCacheManager:Dispose()
    -- TODO:
end

function CWidgetActionCacheManager:GetAction(config)

    local action_cache = self:GetActionCache(config)
    print("[CWidgetActionCache] GetCache:"..action_cache.config)
    return action_cache:Get()
end

function CWidgetActionCacheManager:CacheAction(config, count)

    local action_cache = self:GetActionCache(config)
    if action_cache == nil then
        return
    end

    print("[CWidgetActionCache] GetCache:"..action_cache.config)
    action_cache:Cache(count)

    self.register_action_cache_map[config] = action_cache
end

function CWidgetActionCacheManager:UncacheAction(config)

    local action_cache = self.register_action_cache_map[config]
    if action_cache ~= nil then
        action_cache:Dispose()
    end
    self.register_action_cache_map[config] = nil
end

function CWidgetActionCacheManager:AddAction(config, action)

    local action_cache = self:GetActionCache(config)
    if action_cache == nil then
        return
    end
    action_cache:Add(action)
end

function CWidgetActionCacheManager:GetActionCache(config)

    local action_cache = self.action_cache_map[config]
    if action_cache ~= nil then
        return action_cache
    end

    action_cache = self:PopFromGC(config)
    if action_cache ~= nil then
        return action_cache
    end

    action_cache = CWidgetActionCache.new(config)
    self.action_cache_map[config] = action_cache

    return action_cache
end

function CWidgetActionCacheManager:UpdateGC(dt)

    -- 累计时间，判断是否到达自动回收
    self.gc_tick = self.gc_tick + dt
    if self.gc_tick < self.gc_interval then
        return
    end
	self.gc_tick = 0

    -- 检测界面回收
    for config, temp_action_cache in pairs(self.action_cache_map) do

        -- 判断缓存界面是否全部被回收
        if temp_action_cache ~= nil and temp_action_cache.action_list.size == temp_action_cache.action_count then
            self:Push2GC(config, temp_action_cache);
            self.action_cache_map[config] = nil
            break
        end
    end

    -- 清理超过部分
    while self.gc_action_cache_list.size > self.gc_size do

        local action_cache = self.gc_action_cache_list:PopFront()
        if action_cache ~= nil then
            print("[CWidgetActionCache] gc action:"..action_cache.config)
            action_cache:Dispose()
        end
    end
end

function CWidgetActionCacheManager:Push2GC(config, action_cache)

    -- 添加到链表中
    self.gc_action_cache_list:PushBack(action_cache)
end

function CWidgetActionCacheManager:PopFromGC(config)

    -- 链表中搜索对应的缓存
    local node = self.gc_action_cache_list.first
    while node ~= nil do

        -- 判断名称是否一致
        local action_cache = node.value
        if action_cache.config == config then

            self.action_cache_map[config] = action_cache
            self.gc_action_cache_list:Erase(node)
            return action_cache
        end
        node = node.next
    end
    return nil
end

return CWidgetActionCacheManager

--endregion
