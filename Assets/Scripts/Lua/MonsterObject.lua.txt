class =require("class");
local Character = require("CharacterObject");

--------------------------------------
--更改创建方法，避免全局混用
-- 创建子类Child
local Monster =class("Monster",Character);
Monster.__index =Monster;

--------------属性表----------------------------
--初始化状态
Monster.initStates =1;
--怪物id
Monster.objId =1;
--怪物类型
Monster.objType = 2;
--怪物血量
Monster.lifNumber = 10;
--怪物等级
Monster.level =1;
--怪物经验
Monster.experience =0;
--怪物金钱
Monster.money =0;
---------------------------------------------
--Monster名
function  Monster:setName(objName)
    self.objName=objName;
end

--Monster id
--通过读取文件修改
function Monster:setId()
    --id唯一
    Monster.super.setId(self);
end

--Monster类型
function Monster:setType()
    --2表示怪物
    self.objType=2;
end
--Monster数值
function Monster:setNumber()
    --血条
    self.lifNumber=10+self.level*2+math.random(1,5);
end
--Monster对象
function Monster:setInstantiate(objInstantiate)
    self.objInstantiate=objInstantiate or "error";
    print(self.objInstantiate);
end
-------------------------------------------------------
--构造函数
function Monster:ctor()
    Monster.super.ctor(self,"player");
end

--初始化
function Monster:init(objName,objId,objInstantiate)

    if self.initStates ==1 then
        self:setName(objName);
        self:setId(objId);
        self:setType();
        self:setNumber();
        self:setInstantiate(objInstantiate);
        self.level =1;
        self.experience =0;
        self.initStates=0;
    else
        print("不能重复赋值");
    end

end

-----------------------怪物战斗相关逻辑------------------
--掉落经验
function Monster:dropExperience()
    --  一到三只怪可以升一级
    --  后期可扩展为经验加成等
    -- 向下取整
    self.experience =math.floor(self.level/math.random(1,3));
    return self.experience
end
--根据等级掉落金币
function Monster:dropMoney()
    -- 根据等级掉落金币
    -- 后期可以扩展成金币加成
    self.money = math.random(1,3)*self.level;
    return self.money
end
--------------------------------------------------------
function Monster:playerInformation()
    print("Player information is here");
    return 1
end


function Monster:drop()
    Monster.super.drop(self);
    print("Monster  drop");
end

return Monster