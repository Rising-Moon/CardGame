

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

---引入场景管理模块
local ScenesManager =require("ScenesManager");

---引入资源管理模块
local ResourcesManager = require("ResourcesManager");

---引入基类
local BaseObject =require("BaseObject");
local CardObeject =require("CardObject");
local Character = require("CharacterObject");
local PlayerObject = require("PlayerObject");
local MonsterObject = require("MonsterObject");

local canvas =CS.UnityEngine.GameObject.Find("Canvas");

function start()

    --[[
    -------------scenesmanager 测试-----------
    print("here is scenesmananger test");
    print("load 1");
    print(ScenesManager:LoadScene(1));
    print("load 2")
    ScenesManager:LoadScene(2);
    print("back 1");
    ScenesManager:BackScene();
    ScenesManager:AsyncLoadScene(3);
    ]]--
    --[[
    -------------BaseObject 测试----------------
    local o =BaseObject:new("fire");
    print(o.data.objId);
    print(o.data.objName);
    o:clear();
    --print(o.data。objId);
    print(o.data.objId);
    local b =BaseObject:new("water");
    print(b.data.objId);
    --local b =BaseObject:new("water");
    --print(b.data.objId);
    ]]--
    --[[
        -------------card 测试----------------
        print("card test");
        local c =CardObeject:new("fire",{fire ="hit by fire",effect ="kill ememy"},10);
        c:writeFile();
     -c:clear();
        --[[
        for i,v in pairs(c.data) do
            print(i.."\tis");
            print(v);
        end
        ]]--
    --[[
        ---------------character test----------
        print("character test");
        local ch =Character:new("小米",10,1,{fire ="hit with fire"});
        ch:writeFile();
          for i,v in pairs(ch.data) do
               print(i.."\tis");
               print(v);
           end
              ]]--
    --[[
    --------------player test------------
    local r =ResourcesManager:instantiatePath("Prefabs/Card",canvas);
    p =PlayerObject:new("小米",10,1,{fire ="hit with fire"},0,{card = 10},r);
    for i,v in pairs(p.data) do
        print(i.."\tis");
        print(v);
    end
    print(serialize(p.data));
    p:clear();
    --p:deleteAll();
    ]]--
    --[[
    ---------------monster test-----------
    local r =ResourcesManager:instantiatePath("Prefabs/Card",canvas);
    m =MonsterObject:new("小米",10,1,{fire ="hit with fire"},0,0,r);
    print(serialize(m.data));
    print(m:dropExperience());
    print(m:dropMoney());
    m:clear();
    ]]--
    --[[
    -------------resourcesmanager 测试--------
    print("here is resourcesmanager");
    --资源加载只需要路径即可
    --完整为 instantiatePath(path,parent,position,rotation)
    --resources 资源测试完成
    --ResourcesManager:instantiatePath("Prefabs/Card",canvas);
    -- assetbundle 资源测试完毕
    --ResourcesManager:instantiatePath("Assets/StreamingAssets/AssetBundles/human.pre",canvas);
    --ResourcesManager:clear();
    local b =BaseObject:new("fire");
    --    print(b.data.objId);
    --    print(b.data.objName);
    --    --o:clear();
    --    print(b.data.objId);
    --    print(b.data.objName);
    ]]--
    -----------------测试结束标示-------------
    print("test is down here");
end

function update()

end

function fixedupdate()

end