

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

---引入基类
local CardObeject =require("CardObject");
local PlayerObject = require("PlayerObject");
local MonsterObject = require("MonsterObject");
local UserObject =require("UserObject");
local CardList =require("CardList");

local canvas = CS.UnityEngine.GameObject.Find("Canvas");

function start()


    --[[
    -------------scenesmanager 测试-----------
    print("here is scenesmananger test");
    print("load 1");
    print(ScenesManager:LoadScene(1));
    print("load 3,4")
    ScenesManager:AsyncLoadScene(3);
    ScenesManager:LoadScene(4);
    ScenesManager:AsyncLoadScene(5);

    ScenesManager:ReStart();
    --
    ]]--
   --[[ ]]--


    --[[
    -----------------user test----------------
    local u =UserObject:new("小明",10,{1,1,2});
    print(serialize(u.data));
    u:clear();
    ]]--
    --[[
       ------------------CardList---------------
       --CardList:RemoveIndex();
       --print(type(CardList));
       CardList:GetNewCard();
       ]]--



end

function update()

end

function fixedupdate()

end
