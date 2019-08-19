-- 导入包
-- 响应处理，处理来自服务器的响应
local responseListener = require('ResponseListener');
-- 战斗场景控制器，现在暂时作为初始控制器
local battleController = require('BattleController');
-- 卡牌列表管理，卡牌信息都在其中进行管理
local CardListManager = require('CardListManager');

--声明变量
-- 当前控制器(作为当前的主逻辑控制，当场景变更时变更控制器即可)
local currentController = nil;

-- 初始化
function init()
    --CS.UnityEngine.Threading.Thread.Sleep(1000);
    -- 控制器设置
    currentController = battleController;
    -- 卡牌列表初始化
    CardListManager.init();
    -- 控制器初始化
    currentController:init();
end

-- 切换控制器
function switchController(controller,...)
    currentController = controller;
    currentController:init(...);
end

-- 游戏主体部分，除一些全局的事务，剩下的全部逻辑由currentController指向的Controller代理
function start()
    -- 初始化默认控制器
    init();

    if (currentController ~= nil and currentController.start ~= nil) then
        currentController:start();
    end
end

function update()
    if (currentController ~= nil and currentController.update ~= nil) then
        currentController:update();
    end
end

function fixedupdate()
    if (currentController ~= nil and currentController.fixedupdate ~= nil) then
        currentController:fixedupdate();
    end
end

function ondestroy()
    if (currentController ~= nil and currentController.ondestroy ~= nil) then
        currentController:ondestroy();
    end
end

function response()
    -- 将响应信息交由responseListener代理
    responseListener.response(messageCast);
end


