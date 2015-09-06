
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

    -- ����ϲ�;
    if self.value_map == nil then
        return self.string
    end

    -- �ַ���ת��;
    for k, v in pairs(self.value_map) do
        local source = "%%" .. k .. "%%" -- ����%��string.gsub�еĶ�%��ת��
        self.string = string.gsub(self.string, source, v)
    end

    -- ת�����;
    self.value_map = nil

    return self.string
end
