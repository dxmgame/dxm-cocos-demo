
local AppBase = class("AppBase")

function AppBase:ctor(configs)
    self.configs_ = {}
    for k, v in pairs(configs or {}) do
        self.configs_[k] = v
    end

    if DEBUG > 1 then
        dump(self.configs_, "AppBase configs")
    end

    if CC_SHOW_FPS then
        cc.Director:getInstance():setDisplayStats(true)
    end

    -- event
    self:onCreate()
end

function AppBase:run(scene)
    self:enterScene(scene)
end

function AppBase:enterScene(scene, transition, time, more)
    display.runScene(scene, transition, time, more)
end

function AppBase:onCreate()
end

return AppBase
