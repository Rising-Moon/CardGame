

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

function start()
    -------------scenesmanager 测试-----------
    print("here is scenesmananger test");
    ScenesManager:LoadScene(1);
    print("load 1");
    ScenesManager:LoadScene();
    print("load 2");
    ScenesManager:BackScene();
    print("back 1");

    -------------resourcesmanager 测试--------
    print("here is resourcesmanager");
    ResourcesManager:instantiatePath("Prefabs/Card");

    -----------------测试结束标示-------------
    print("test is down here");
end
