
local LoginButtonController =require("LoginButtonEvent");

local loginInController = {};




-- 回调函数表
loginInController.Callback = {};
local callback = loginInController.Callback;



-- 初始化
function loginInController:init()

end

function callback.initListener(num)
    num =nil;
    return num
end


function loginInController.start()

end

function loginInController.update()
    LoginButtonController.listenLogin(callback);
end

return loginInController