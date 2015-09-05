--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

dxm = dxm or {}

-- 链表节点
dxm.CNode = class("CNode")
local CNode = dxm.CNode

function CNode:ctor()
    self.prev = nil
    self.next = nil
    self.value = nil
end

-- 链表
dxm.CList = class("CList")
local CList = dxm.CList

function CList:ctor()
    self.first = nil -- 头
    self.last = nil -- 尾
    self.size = 0 -- 容量
end

-- 成员函数
function CList:Clear()

    local node = self.first
    while node ~= nil do

        local next_node = node.next

        node.prev = nil
        node.value = nil
        node.next = nil

        node = next_node
    end
    self.first = nil
    self.last = nil
end

function CList:Erase(node)

    if node == nil then
        return
    end

    local node_prev = node.prev
    local node_next = node.next

    if node_prev ~= nil then
        node_prev.next = node_next
    end
    if node_next ~= nil then
        node_next.prev = node_prev
    end

    if node == self.first then
        self.first = node.next
    end
    if node == self.last then
        self.last = node.prev
    end
    self.size = self.size - 1
    node.prev = nil
    node.next = nil
    node.value = nil
end

function CList:PushBack(value)

    local node = { prev = self.last, value = value }
    if self.last ~= nil then 
        self.last.next = node
    end
    self.last = node
    if self.first == nil then
        self.first = node
    end
    self.size = self.size + 1
end

function CList:PopFront()

    local node = self.first
    if node == nil then
        return nil
    end

    self.first = node.next
    if self.last == node then
        self.last = nil
    end
    self.size = self.size - 1
    node.next = nil
    node.prev = nil
    return node.value
end

function CList:Begin()
    local node = self.first
    return function ()  
            if not node then return nil end
            local ret = node
            node = node.next
        return ret  
    end  
end

function CList:End()
    local node = self.last
    return function ()  
            if not node then return nil end
            local ret = node
            node = node.prev
        return ret  
    end  
end

return CList

--endregion
