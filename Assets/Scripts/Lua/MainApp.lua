

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


    -------------scenesmanager 测试-----------
    --print("here is scenesmananger test");
    --print("load 1");
    --print(ScenesManager:LoadScene(1));
    --print("load 2")
    --ScenesManager:LoadScene(2);
    --print("back 1");
    --ScenesManager:BackScene();
    --ScenesManager:AsyncLoadScene1(3);
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


           -------------resourcesmanager 测试--------
           print("here is resourcesmanager");
           --资源加载只需要路径即可
           --完整为 instantiatePath(path,parent,position,rotation)
           --resources 资源测试完成
           local c=ResourcesManager:instantiatePath("Prefabs/Card",canvas);
           -- assetbundle 资源测试完毕
           local a=ResourcesManager:instantiatePath("Assets/StreamingAssets/AssetBundles/human.pre",canvas);
           --obj =ResourcesManager:instantiatePath("Assets/StreamingAssets/AssetBundles/human.pre",canvas);
           --ResourcesManager:clear();
           --local b =BaseObject:new("fire");
           --    print(b.data.objId);
           --    print(b.data.objName);
           --    --o:clear();
           --    print(b.data.objId);
           --    print(b.data.objName);
         --[[      ]]--


end

function update()

end

function fixedupdate()

end
