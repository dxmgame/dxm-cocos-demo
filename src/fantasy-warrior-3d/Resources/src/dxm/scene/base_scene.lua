--region NewFile_1.lua
--Author : IBM
--Date   : 2015/4/28
--此文件由[BabeLua]插件自动生成

require("dxm/ui/ui_manager")

dxm = dxm or {}

dxm.CBaseScene = class("dxm.CBaseScene", function()
    return display.newScene("dxm.CBaseScene")
end )
local CBaseScene = dxm.CBaseScene

-- 构造函数
function CBaseScene:ctor()

end

-- 创建函数
function CBaseScene:Create()
    local base_scene = CBaseScene.new()
    if base_scene == nil or base_scene:Init() == false then
        return nil
    end
    return base_scene
end

-- 初始化函数
function CBaseScene:Init()
	-- UI管理器初始化;
    self._layer_ui = dxm.CUIManager:GetInstancePtr():InitLayerUIWithScene(self)
    self._layer_ui:AttachParent(self)

    -- 监听事件;
    self:registerScriptHandler( function(state)
        if state == "enter" then
            self:onEnter()
        elseif state == "exit" then
            self:onExit()
        elseif state == "enterTransitionFinish" then
            self:onEnterTransitionFinish()
        elseif state == "exitTransitionStart" then
            self:onExitTransitionStart()
        elseif state == "cleanup" then
            self:onCleanup()
        end
    end )
	return true;
end

-- 进入与离开事件
function CBaseScene:onEnter()
    
end

function CBaseScene:onExit()
    self._layer_ui:DetachParent()
end

function CBaseScene:onEnterTransitionFinish()
end

function CBaseScene:onExitTransitionStart()
end

function CBaseScene:onCleanup()
end

-- 替换界面
function CBaseScene:ReplaceScene(scene)
    cc.Director:sharedDirector():getTouchDispatcher():removeAllDelegates()
	cc.Director:sharedDirector():replaceScene(scene)
end

return CBaseScene

--endregion
