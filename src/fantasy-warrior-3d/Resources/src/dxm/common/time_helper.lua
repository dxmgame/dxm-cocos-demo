-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

dxm.CTimeHelper = class("dxm.CTimeHelper")

local CTimeHelper = dxm.CTimeHelper

function CTimeHelper.toTimeSpanString(time_span)
    return string.format("%02d:%02d:%02d", math.floor(time_span/(60*60)), math.floor(time_span/60%60), math.floor(time_span%60))
end

function CTimeHelper.toDateTimeString(time)
    local time_table = os.date("t", time)
    return string.format('%d-%02d-%02d %02d:%02d:%02d',time_table.year,time_table.month,time_table.day,time_table.hour,time_table.min,time_table.sec)
end

function CTimeHelper.toTimeString(time)
    local time_table = os.date("t", time)
    return string.format('%02d:%02d:%02d',time_table.hour,time_table.min,time_table.sec)
end

function CTimeHelper.toDateString(time)
    local time_table = os.date("t", time)
    return string.format('%d-%02d-%02d',time_table.year,time_table.month,time_table.day)
end

function CTimeHelper.toTime(time_string)
    -- 从日期字符串中截取出年月日时分秒
    local Y = string.sub(time_string, 1, 4)
    local M = string.sub(time_string, 6, 7)
    local D = string.sub(time_string, 9, 10)
    local H = string.sub(time_string, 12, 13)
    local MM = string.sub(time_string, 15, 16)
    local SS = string.sub(time_string, 18, 19)

    -- 把日期时间字符串转换成对应的日期时间
   return os.time { year = Y, month = M, day = D, hour = H, min = MM, sec = SS }
end

function CTimeHelper.diffTime(t1, t2)
    return os.difftime(t1, t2)
end

function CTimeHelper.nowTime()
   return os.time()
end

return CTimeHelper

-- endregion
