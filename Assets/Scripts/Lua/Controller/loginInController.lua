local RM =require("ResourcesManager");
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

--只会运行一次
--添加一次淡入淡出
function loginInController.start()
    --local pic =RM:LoadPath("Assets/Resources/picture/ad.jpg");
    --print(pic);

end

function loginInController.update()

  LoginButtonController.listenLogin(callback);
end

return loginInController