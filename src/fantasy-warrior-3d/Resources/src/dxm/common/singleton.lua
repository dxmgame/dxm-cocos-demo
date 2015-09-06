--region NewFile_1.lua
--Author : IBM
--Date   : 2015/4/28
--此文件由[BabeLua]插件自动生成

dxm = dxm or {}

function dxm.SINGLETON(class_name)

    -- 成员变量
    class_name._instance = nil

    -- 单件获取函数
    function class_name:GetInstancePtr()
        if self._instance == nil then
            self._instance = class_name.new()
        end
        return self._instance
    end
end

--endregion
