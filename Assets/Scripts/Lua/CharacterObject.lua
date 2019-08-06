class =require("class");
local BaseObject = require("BaseObject");
--------------------------------------------------
--更改创建方法，避免全局混用
-- 创建子类Child
local Character =class("Character",BaseObject);


-------------------属性表-----------------------
Character.data={

    objName ="",
    objId =0,
    --角色血条
    objBlood =10,
    --角色蓝条
    objMana =10,
    level =1,
    --gameobj
    objInstantiate =nil
};
---------------------------------------


-------------属性更改接口-----------------
--[[
--character名
function  Character:setName(objName)
    self.objName=objName;
end

--character id
function Character:setId()
    --id唯一
    self.objId=Character.super.setUniqueId();
    print(self.objId);
end

--character类型
function Character:setType(objtype)
    --1表示玩家
    --2表示怪物
    self.objType=objtype;
    return self.objType
end

--character数值
function Character:setNumber()
    --血条
    self.lifeNumber=10;
end

--character对象
function Character:setInstantiate(objInstantiate)
    self.objInstantiate=objInstantiate or "error";
    print(self.objInstantiate);
end
]]--

--------------------------------------------------
--构造函数
function Character:ctor(fillthing,objName,objNumber,objMaNa,objInstantiate)
    Character.super.ctor(self,"Character",objName);
    print("character ctor run");
    print(self.data.objName)
    --属性设置
    self.data.objName =objMaNa or 10;
    self.data.objNumber=objNumber or 10;
    self.objMaNa =objMaNa or 2;
    self.objInstantiate=objInstantiate or nil;
    self.level =1;
    print("charcter ctor finish");
end
--[[
--初始化
function Character:init(objName,objType,objNumber,objInstantiate)

    if self.initStates ==1 then
        self:setName(objName);
        self:setId();
        self:setType(objType);
        self:setNumber(objNumber);
        self:setInstantiate(objInstantiate);
        self.level =1;
        self.experience =0;
        self.initStates=0;
    else
        print("不能重复赋值");
    end
end
]]--
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