

game.CModuleTreeManager = class("game.CModuleTreeManager")
local CModuleTreeManager = game.CModuleTreeManager

function CModuleTreeManager:ctor(user)
    self.user = user
end

function CModuleTreeManager:dispose()
    self.user = nil
end

function CModuleTreeManager:getTimes()    
   
    self.user.data.user.max_times =  self.user.data.user.max_times or 0
    self.user.data.user.shake_times = self.user.data.user.shake_times or 0
    return self.user.data.user.max_times - self.user.data.user.shake_times
end

function CModuleTreeManager:getBeginTime()    
   
    self.user.data.user.activity_begin_time =  self.user.data.user.activity_begin_time or "2012-01-01 00:00:00"
    return self.user.data.user.activity_begin_time
end

function CModuleTreeManager:getEndTime()    
   
    self.user.data.user.activity_end_time =  self.user.data.user.activity_end_time or "2012-01-01 00:00:00"
    return self.user.data.user.activity_end_time
end

function CModuleTreeManager:getMaxTimes()    
   
     self.user.data.user.max_times =  self.user.data.user.max_times or 0
     return self.user.data.user.max_times
end

function CModuleTreeManager:getLimitReward()

     self.user.data.user.limit_reward =  self.user.data.user.limit_reward or 0
     return self.user.data.user.limit_reward
end 

function CModuleTreeManager:isInActivityTime()
    local begin_time = dxm.CTimeHelper.toTime(self:getBeginTime())
    local end_time = dxm.CTimeHelper.toTime(self:getEndTime())
    local now = dxm.CTimeHelper.nowTime()
    if now<begin_time or now>end_time then
        return false
    end
    return true
end

function CModuleTreeManager:getLastTimeSpan()   
   return "00:00:00"
--   local now = dxm.CTimeHelper.nowTime()
--   local next_tick = dxm.CTimeHelper.toTime(self.user.data.user.last_shake_time) + self.user.data.user.shake_cd
--   local delta = dxm.CTimeHelper.diffTime(next_tick, now)
--   if delta<0 then
--        delta = 0
--   end
--   local time_span_string = dxm.CTimeHelper.toTimeSpanString(delta)
--   return time_span_string
end

return CModuleTreeManager