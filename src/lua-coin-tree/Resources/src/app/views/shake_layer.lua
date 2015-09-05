--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require "app.views.reward_ui"

game.CShakeLayer = class("game.CShakeLayer", function()
    return display.newLayer()
end)

local CShakeLayer = game.CShakeLayer;

function CShakeLayer:ctor()

end

function CShakeLayer:init()

    self:onAccelerate( function(x, y, z, timestamp)
        local nowGX = x * 9.81;
        local nowGY = y * 9.81;
        if (nowGX < -10.0 or nowGX > 10.0) and(nowGY < -10.0 or nowGY > 10.0) then
            game.sUserController:shake()
        end
    end )

    return true
end

function CShakeLayer:create()

    local layer = CShakeLayer.new()
    if layer==nil or layer:init()==false then
        return nil
    end
    return layer
end

function CShakeLayer:onEnter()

end

return CShakeLayer

--endregion
