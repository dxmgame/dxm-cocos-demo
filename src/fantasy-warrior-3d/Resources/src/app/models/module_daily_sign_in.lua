

game.CModuleDailySignIn = class("game.CModuleDailySignIn")
local CModuleDailySignIn = game.CModuleDailySignIn

function CModuleDailySignIn:ctor(user)
    self.user = user
end


function CModuleDailySignIn:dispose()
    self.user = nil
end


return CModuleDailySignIn