

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
local BaseObject =require("BaseObject");
local CardObeject =require("CardObject");
local Character = require("CharacterObject");
local PlayerObject = require("PlayerObject");
local MonsterObject = require("MonsterObject");
local UserObject =require("UserObject");
local CardList =require("CardList");

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
    -----------------user test----------------
    local u =UserObject:new("小明",10,{1,1,2});
    print(serialize(u.data));
    u:clear();
    ]]--

    ------------------CardList---------------
    --CardList:RemoveIndex();
    print(type(CardList));
    --local dir = CS.System.Collections.Generic["Dictionary`1[System.Int32]`2[table]"]();
    --print(dir);
    --[[ ]]--

    --[[
           -------------resourcesmanager 测试--------
           print("here is resourcesmanager");
           --资源加载只需要路径即可
           --完整为 instantiatePath(path,parent,position,rotation)
           --resources 资源测试完成
           --ResourcesManager:instantiatePath("Prefabs/Card",canvas);
           -- assetbundle 资源测试完毕
           --ResourcesManager:instantiatePath("Assets/StreamingAssets/AssetBundles/human.pre",canvas);
           --obj =ResourcesManager:instantiatePath("Assets/StreamingAssets/AssetBundles/human.pre",canvas);
           --ResourcesManager:clear();
           --local b =BaseObject:new("fire");
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

    --[[
               if CS.UnityEngine.Input.GetMouseButtonDown(1) then
                   local ray =CS.UnityEngine.Camera.main:ScreenPointToRay(CS.UnityEngine.Input.mousePosition);
                   --在C#中 直接用个RaycastHit接收检测到的物体，但是在lua中没法用out关键字
                   --xlua中对于out的解决办法是通过作为第二返回值（如果函数原本就有返回值的话）的方式
                   --而Physics.Raycast(ray)恰好又是另一个重载函数，所以 Physics.Raycast(ray, out hit)就没法用了。
                   print("ray vector is:\t");
                   print(ray);
                   if CS.UnityEngine.Physics.RaycastAll(ray)==false then
                       print("null object");
                   else
                       --函数返回true，但是没有获取到想要的物体
                       --CS.UnityEngine.Debug:DrawLine(ray,-ray,CS.UnityEngine.Color.red,10);
                       print("drow");
                       local hit=CS.UnityEngine.Physics.RaycastAll(ray);
                       print(hit.Length);
                       print(hit.collider.gameObject.name);
                   end
               end
               ]]--
    if CS.UnityEngine.Input.GetMouseButtonDown(0) then
        local obj =CS.UnityEngine.GameObject();
        local Hor =CS.UnityEngine.Input.GetAxis("Mouse X");
        local Ver =CS.UnityEngine.Input.GetAxis("Mouse Y");
        --gameObject应当通过射线来获取
        MoveObjectByMouse(obj,Hor,Ver);
    end

end

function fixedupdate()

end



--先设置为该文件中的全局变量，便于在文件中引用
--通过鼠标点击选择物体进行移动
--需要添加射线检测旋转需要移动的物体
function MoveObjectByMouse(obj,Hor,Ver)
    obj.transform.position =obj.transform.position+CS.UnityEngine.Vector3(Hor*100,Ver*100,0);
end
