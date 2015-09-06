
dxm.CMessageHelper = class("dxm.CMessageHelper")

local CMessageHelper = dxm.CMessageHelper

function CMessageHelper:ctor()

end

function CMessageHelper:Init(string)
    self.string = string
    self.value_map = nil
    return true;
end

function CMessageHelper:SetValue(name, value)
    self.value_map = self.value_map or {}
    self.value_map[name] = value;
end

function CMessageHelper:Combine()

    -- 无需合并;
    if self.value_map == nil then
        return self.string
    end

    -- 字符串转化;
    for k, v in pairs(self.value_map) do
        local source = "%%" .. k .. "%%" -- 两个%是string.gsub中的对%的转义
        self.string = string.gsub(self.string, source, v)
    end

    -- 转换完毕;
    self.value_map = nil

    return self.string
end
