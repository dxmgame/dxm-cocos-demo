

game.CModuleBag = class("game.CModuleBag")
local CModuleBag = game.CModuleBag

function CModuleBag:ctor(user)
    self.user = user
end


function CModuleBag:dispose()
    self.user = nil
end

return CUser