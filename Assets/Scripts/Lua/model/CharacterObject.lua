class =require("class");
local BaseObject = require("BaseObject");
--------------------------------------------------
--更改创建方法，避免全局混用
-- 创建子类Child
local Character =class("Character",BaseObject);


-------------------属性表-----------------------
Character.data={
    objName ="",
    --objId =0,

    --角色血条
    objBlood =10,

    --角色蓝条
    objMana =2,
    --角色等级
    level =1,
    --角色attribute
    attribute ={}
};
--角色实例话对象
Character.objInstantiate =nil;
---------------------------------------


--------------------------------------------------
--构造函数
function Character:ctor(objName,objNumber,objMaNa,objAttrubute,objInstantiate)
    Character.super.ctor(self,"Character");
    print("character ctor run");
    --print(self.data.objName)
    --属性设置
    self.data.objName =objName or "Character";
    self.data.objBlood=objNumber or 10;
    self.data.objMana =objMaNa or 2;
    self.objInstantiate=objInstantiate or nil;
    self.data.attribute =objAttrubute or {effect = "fight"};
    self.data.level =1;
    print("charcter ctor finish");
end

--------------------------------------------------------

function Character:characterInformation()
    print("character information is here");
end

function Character:useCharacter()

end

function Character:clear()
    Character.super.clear(self);
    print("character clear");
end

return Character