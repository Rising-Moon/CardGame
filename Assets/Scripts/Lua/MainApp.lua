-------------------------引用------------------
--- 响应处理，处理来自服务器的响应
local responseListener = require('ResponseListener');


---引用全局枚举表
---各个基类可以调用枚举表的值
require("GlobalEnumDir");

---引入class基类
---先引入可避免后引入的基于class方法的文件出错
local class = require("class");

---引入文件读写模块
local FileRead =require("FileRead");
---引入序列化函数
require("serialize");

---引入json处理
local json =require("json");


---引入场景管理模块
local ScenesManager =require("ScenesManager");

---引入资源管理模块
local ResourcesManager = require("ResourcesManager");

---引入音频管理模块
local AudioManager =require("AudioManager");

---引入路径管理模块
local PathManager =require("PathManager");

---引入基类



--引入logincontroller
local loginInController =require("LoginInController");

--引入gatesController
local GatesController =require("GatesController");

--引入battleController
--目前不能使用，因为battleview在创建的时候，以场景battle的canvas创建uimap，导致在倒入battlecontroller的时候会报错
--local BattleController = require('BattleController');

--引入PomkController
local PomkController = require("PomkController");

-- 卡牌列表管理，卡牌信息都在其中进行管理
local CardListManager = require('CardListManager');

local currentController =nil;

--local message =CS.MessageQueueManager.GetMessageQueue();

function start()


    controllerList={
        loginInController,
        GatesController,
        --BattleController,
        PomkController
    };

    currentController = loginInController;
    if (currentController ~= nil and currentController.start ~= nil) then
        currentController.start();
    end

end

function update()

    --切换场景
    currentController=controllerList[ScenesManager:GetIndex()+1];

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