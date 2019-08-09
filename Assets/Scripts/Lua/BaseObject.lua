class = require("class");
-- 定义基类
local BaseObject = class("BaseObject");

--------------属性表------------------
--object ID
BaseObject.id = nil;

-- 构造函数
--调用new会自动执行
function BaseObject:ctor()
    --gameobject的名字
    --从palyerfref获取固定ID
    self.data.objId =CS.UnityEngine.PlayerPrefs.GetInt("objId",0);
    self:updateId();
end


function BaseObject:updateId()
    CS.UnityEngine.PlayerPrefs.SetInt("objId",self.data.objId+1);
end

--清除函数
--只需要对类变量进行清除即可
function BaseObject:clear()

    --print("clear now");
    for i,v in pairs(self.data) do
        --交给gc回收
        --print(self.data[i]);
        self.data[i]=nil;
        --print(self.data[i]);
        --self.remove(self,i);
    end
    for i,v in pairs(self.data) do
       print(i..v);
        --self.remove(self,i);
    end
    collectgarbage("collect");
    --print("object drop");
end

return BaseObject