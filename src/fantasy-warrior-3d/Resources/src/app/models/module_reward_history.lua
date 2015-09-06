

game.CModuleRewardHistory = class("game.CModuleRewardHistory")
local CModuleRewardHistory = game.CModuleRewardHistory

function CModuleRewardHistory:ctor(user)
    self.user = user

    self.history_list = self.history_list or dxm.CList.new()

    dxm.GameState.load()
    if dxm.save_data.history~=nil then 
        for _, v in pairs(dxm.save_data.history) do
            self.history_list:PushBack(v)
        end
    end
end

function CModuleRewardHistory:dispose()
    self.user = nil
end

function CModuleRewardHistory:addReward(reward)
    
    self.history_list:PushBack(reward)
    if self.history_list.size > 30 then
        self.history_list:PopFront()
    end
    dxm.save_data.history = {}

    local itor = self.history_list:Begin()
    while true do
        local node = itor()
        if node == nil then break end
        local index = #dxm.save_data.history+1; 
        dxm.save_data.history[index] = node.value
    end
    dxm.GameState.save()
end

return CModuleRewardHistory