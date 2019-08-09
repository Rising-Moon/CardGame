-- 导入包
local responseListener = require('ResponseListener');
local battleController = require('BattleController');
local BaseObject = require('BaseObject');
local CardObject = require('CardObject');

----全局控制器


----声明变量
-- 当前控制器
local currentController = nil;

function start()
    currentController = battleController;
    if (currentController ~= nil and currentController.start ~= nil) then
        currentController.start();
    end
end

function update()
    if (currentController ~= nil and currentController.update ~= nil) then
        currentController.update();
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
    responseListener.response(messageCast);
end


