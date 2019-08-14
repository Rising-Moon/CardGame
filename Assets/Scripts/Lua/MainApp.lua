

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
local CardObeject =require("CardObject");
local PlayerObject = require("PlayerObject");
local MonsterObject = require("MonsterObject");
local UserObject =require("UserObject");
local CardList =require("CardList");



--引入logincontroller
local loginInController =require("loginInController");
--
local dailyController =require("dailyController");


local currentController =nil;

function start()

    --可以直接使用audio的加载也可以ResouresManager:LoadPath()
    --该音乐前面有很长一段空白
    --local music =AudioManager:LoadAudio("music/backGroundMusic");
    --local music =ResourcesManager:LoadPath("Assets/Resources/music/backGroundMusic.mp3");

    --AudioManager:PlayBacKGroundMusic(music,1);
    controllerList={
        loginInController,
        dailyController
    }
    currentController = loginInController;
    if (currentController ~= nil and currentController.start ~= nil) then
        currentController.start();
    end
    --print(ScenesManager:GetIndex());
end

function update()

    currentController=controllerList[ScenesManager:GetIndex()+1];
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

--[[
--将一些一直会存在的ui放在这里
--例如 音乐的播放
function ongui()
   AudioManager:OnGUI();

end
]]--