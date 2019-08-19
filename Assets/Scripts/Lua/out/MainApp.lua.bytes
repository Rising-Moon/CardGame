-------------------------引用------------------
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
local BaseObject = require("BaseObject");
local CardObeject =require("CardObject");
local PlayerObject = require("PlayerObject");
local MonsterObject = require("MonsterObject");
local UserObject =require("UserObject");
local CardList =require("CardList");

--引入logincontroller
local loginInController =require("LoginInController");
--
local dailyController =require("GatesController");
--
local BattleController = require("BattleController");
--
local PomkController = require("PomkController");

local currentController =nil;



function start()

    --可以直接使用audio的加载也可以ResouresManager:LoadPath()
    --该音乐前面有很长一段空白
    --local music =AudioManager:LoadAudio("music/backGroundMusic");
    --local music =ResourcesManager:LoadPath("Assets/Resources/music/backGroundMusic.mp3");
    --[[
    local function callback()
        print("nil");
    end

    ScenesManager:AsyncLoadSceneCallBack(1,callback);
    ]]--
    --AudioManager:PlayBacKGroundMusic(music,1);
    --local d=ResourcesManager:instantiatePath("Assets/StreamingAssets/AssetBundles/picture.pic","daily",ScenesManager:initRoot(),CS.UnityEngine.Vector3(0,0,0));
    --local a =ResourcesManager:instantiatePath("Assets/Resources/Prefabs/healthBar.prefab","healthBar",ScenesManager:initRoot(),CS.UnityEngine.Vector3(0,0,0));
    --local d=ResourcesManager:instantiatePath("Assets/StreamingAssets/AssetBundles/human.pre","healthbar",ScenesManager:initRoot(),CS.UnityEngine.Vector3(0,0,0));
     print("this is test area");
    tTest=CS.Timer(1);
    tTest:Start();

    print("test area is down");

    controllerList={
        loginInController,
        dailyController,
        BattleController,
        PomkController
    };

    currentController = loginInController;
    if (currentController ~= nil and currentController.start ~= nil) then
        currentController.start();
    end
    --print(ScenesManager:GetIndex());
end

function update()


    if tTest and tTest.IsTimeUp then
        print("down");
        tTest =nil;
        --coroutine.waitforframes(1);
        --print("bagin");
    end
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

