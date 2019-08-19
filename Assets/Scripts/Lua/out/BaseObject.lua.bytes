class = require("class");
-- 定义基类
local BaseObject = class("BaseObject");

--------------属性表------------------
--object ID
BaseObject.objId = 0;

-- 构造函数
function BaseObject:ctor()
    if (BaseObject.objId) then
        self.objId = BaseObject.objId + 1;
    else
        self.objId = 0;
    end
    BaseObject.objId = self.objId;
end

--清除函数
function BaseObject:clear()
    for k,_ in pairs(self) do
        self[k] = nil;
    end
    collectgarbage("collect");
end

--比较函数
function BaseObject:compare(obj)
    return self.objId == obj.objId;
end

return BaseObject