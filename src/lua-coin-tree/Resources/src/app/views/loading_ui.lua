--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

game.CLoadingUI = class("game.CLoadingUI", dxm.CDialogUI)

local CLoadingUI = game.CLoadingUI

function CLoadingUI:ctor()
    CLoadingUI.super.ctor(self)
end

function CLoadingUI:Init()
    
    return self:InitWithFile("LoadingLayer")
end

function CLoadingUI:Create()

    local ui = CLoadingUI.new()
    if ui == nil or ui:Init()==false then
        return nil
    end
    return ui
end

function CLoadingUI:onEnter()
    
end

function CLoadingUI:onExit()

end

return CLoadingUI

--endregion
