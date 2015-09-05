-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

require "app.views.message_box_retry"
require "app.views.message_box_ok_cancel"
require "app.views.message_box_ok"
require "app.views.message_box_reward"

game.CUserController = class("game.CUserController")
local CUserController = game.CUserController

function CUserController:ctor()
    
end

-- 获取用户信息;
function CUserController:getUser(token)

    -- 显示加载界面,如果获取不到则返回应用
    game.sUser:fetch(token, function (code, response_json)
        if code < 0 then           
            local ui = game.CMessageBoxRetry:Create(game.sAssetMessage:getMessage("connect_server_failed"), function() self:getUser(token) end)
            ui:Open()
        elseif code > 0 then 
            local ui = game.CMessageBoxOk:Create(game.sAssetMessage:getMessage("other_error"), function() self:getUser(token) end)
            ui:Open()
        elseif code == 0 then 
            game.CMainUI:Create():Open()
            -- local ui = game.CMessageBoxOk:Create(response_json.token, function() end)
            -- ui:Open()
        end
    end)
end

-- 摇的动作控制;
function CUserController:shake()

    if self:_isShakeEnable() then
        game.sUser:shake( function(code, response_json)
            if code < 0 then           
                local ui = game.CMessageBoxRetry:Create(game.sAssetMessage:getMessage("connect_server_failed"), function() self:shake() end)
                ui:Open()
            elseif code == 1 then 
                local ui = game.CMessageBoxOk:Create(game.sAssetMessage:getMessage("activity_not_start"), function() end)
                ui:Open()
            elseif code == 2 then 
                local ui = game.CMessageBoxOk:Create(game.sAssetMessage:getMessage("activity_finished"), function()  end)
                ui:Open()
            elseif code == 3 then 
                local ui = game.CMessageBoxOk:Create(game.sAssetMessage:getMessage("shake_times_is_not_enough"), function()  end)
                ui:Open()
            elseif code == 4 then 
                local ui = game.CMessageBoxOk:Create(game.sAssetMessage:getMessage("shake_reward_is_not_enough"), function()  end)
                ui:Open()
            elseif code == 0 then                
                local ui = game.CMessageBoxReward:Create(response_json.game_bill..game.sAssetMessage:getMessage("money_unit"), function() end)
                ui:Open()
                game.sUser.module_reward_history:addReward(response_json)
            end
        end )
    end

end

function CUserController:_isShakeEnable()
    
    if game.sUser.module_request.requesting == true then
        return false;
    end

    if self.shake_enable==false then
        return false
    end
    return game.sUser:isShakeEnable()
end

function CUserController:setShakeEnable(is_enable)
    self.shake_enable = is_enable
end
return CUserController

-- endregion
