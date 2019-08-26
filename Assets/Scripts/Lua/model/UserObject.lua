--导包
local class = require("class");
local BaseObject =require("BaseObject");
local UserObject =class("UseObject",BaseObject);

UserObject.name =nil;
UserObject.money =nil;

--构造函数
--调用new被自动调动
function UserObject:ctor(objName,objMoney)
    UserObject.super.ctor(self);
    self.name =objName or CS.UnityEngine.PlayerPrefs.GetString("username","demo");
    self.money =objMoney;
end

return UserObject