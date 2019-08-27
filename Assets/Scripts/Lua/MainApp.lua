-------------------------引用------------------
--- 响应处理，处理来自服务器的响应
local responseListener = require('ResponseListener');
---登陆控制器，现在暂时作为初始控制器
local loginInController = require('loginInController');
---场景管理
local ScenesManager =require("ScenesManager");
---xlua协程
local util = require 'xlua.util';
---全局响应表
require("GlobalEnumDir");

--获取一个c#脚本调用
local myClass =CS.UnityEngine.GameObject.Find("mainApp"):GetComponent("LuaBehaviour");

-- 延时调用列表
local delayFunc = {};

-- 延时调用函数(全局)
function global.invoke(func,delay)
    table.insert(delayFunc,{delay,func});
end

--声明变量
-- 当前控制器(作为当前的主逻辑控制，当场景变更时变更控制器即可)
local currentController = nil;

-- 初始化
local function init()
    -- 控制器设置
    currentController = loginInController;
    -- 控制器初始化
    currentController.init();
end

-- 切换控制器(全局)
function global.switchController(controller)
    currentController = controller;
    local switch_FUC = util.cs_generator(function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
        --coroutine.yield(CS.UnityEngine.WaitForEndOfFrame);
         --协程
        currentController.init();
    end);
    myClass:StartCoroutine(switch_FUC);
end

function start()
    init();
    if (currentController ~= nil and currentController.start ~= nil) then
        currentController.start();
    end

end

function update()

    -- 遍历延时函数
    for i = #delayFunc,1,-1 do
        delayFunc[i][1] = delayFunc[i][1] - CS.UnityEngine.Time.deltaTime;
        if(delayFunc[i][1] < 0) then
            delayFunc[i][2]();
            table.remove(delayFunc,i);
        end
    end

    if (currentController ~= nil and currentController.update ~= nil) then
        currentController.update();
    else
        print("error to load in a scene without controller");
    end

end

function fixedupdate()
    if (currentController ~= nil and currentController.fixedupdate ~= nil) then
        currentController.fixedupdate();
    end
end

function ondestroy()
    if (currentController ~= nil and currentController.ondestroy ~= nil) then
        currentController.ondestroy();
    end
end

function response()
    -- 将响应信息交由responseListener代理
    responseListener.response(messageCast);
end