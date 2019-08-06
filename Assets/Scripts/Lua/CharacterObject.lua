class =require("class");
local Object = require("BaseObject");
--------------------------------------------------
--更改创建方法，避免全局混用
-- 创建子类Child
local Character =class("Character",Object);

Character.__index =Character;

-------------------属性表-----------------------
--初始化状态
Character.initStates =1;
--角色名
Character.objName =nil;
--角色id
Character.objId = nil;
--角色类型
Character.objType =1;
--角色血条
Character.lifeNumber = 10;
--角色对象引用
Character.objInstantiate = nil;
--角色等级
Character.lifeNumber =1;
---------------------------------------


-------------属性更改接口-----------------
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


--------------------------------------------------
--构造函数
function Character:ctor()
    Character.super.ctor(self,"Character");
end

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
--------------------------------------------------------

function Character:characterInformation()
    print("character information is here");
end

function Character:useCharacter()

end

function Character:drop()
    Character.super.drop(self);
    print("character drop");
end

return Character;