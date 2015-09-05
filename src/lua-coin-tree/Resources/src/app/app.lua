require "app.init"
require "app.views.loading_ui"
require "app.views.main_ui"

local CApp = class("CApp", cc.load("mvc").AppBase)

function CApp:onCreate()
    math.randomseed(os.time())

    -- 注册加载UI
    local ui = game.CLoadingUI:Create()
    game.sUser.module_request:setRequestSendCallback(function()        
        ui:Open(true)
    end)   
    game.sUser.module_request:setRequestFinishCallback(function()
        ui:Close()
    end)

    -- 注册默认的栈UI
    dxm.CUIManager:GetInstancePtr():SetDefaultStackUI(game.CMainUI:Create())
end

return CApp
