
local LoginButtonController =require("LoginButtonController");

local loginInController = {};




-- 回调函数表
loginInController.Callback = {};
local callback = loginInController.Callback;



-- 初始化
function loginInController:init()
    --[[
    function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
    end
    ]]--
end

function callback.initListener(num)
    num =nil
    return num
end


function loginInController.start()

end

function loginInController.update()
    print("login run");
    LoginButtonController.listenLogin(callback);
    print("LoginButton run");
end

return loginInController