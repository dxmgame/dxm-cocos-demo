
require "app.models.module_reward_history"
require "app.models.module_daily_sign_in"
require "app.models.module_bag"
require "app.models.module_request"
require "app.models.module_tree_manager"

game.CUser = class("game.CUser")
local CUser = game.CUser

function CUser:ctor()
    self.module_reward_history = game.CModuleRewardHistory.new(self)
    self.module_daily_sign_in = game.CModuleDailySignIn.new(self)
    self.module_bag = game.CModuleBag.new(self)
    self.module_request = game.CModuleRequest.new(self)
    self.module_tree_manager = game.CModuleTreeManager.new(self)

    self.token = 0

    self.data = { }
    self.data.user = { }
    self.data.trees = { }
    self.data.reward_history = { }
    self.data.bag = { }
    self.data.sign_in = { }
end

function CUser:dispose()
    self.module_reward_history:dispose()
    self.module_daily_sign_in:dispose()
    self.module_bag:dispose()
    self.module_request:dispose()
end

function CUser:fetch(token, callback)
    print("CUser:fetch "..token)
    local function onCallback(code, response_json)
        callback(code, response_json)
    end
    self.module_request:request("get_user", "token=" .. token, onCallback)
    self.token = token
end

function CUser:shake(shake_callback)
    if self:isShakeEnable() then
        print("CUser:shake")
        local function responseShake(code, response_json)
            shake_callback(code, response_json)
        end
        self.module_request:request("shake", "token=" .. self.token, responseShake)
    else
        shake_callback(-997, "")
    end
end

function CUser:isShakeEnable()
    return true
end

return CUser