class =require("class");
local Character = require("CharacterObject");

--------------------------------------
--更改创建方法，避免全局混用
-- 创建子类Child
local Monster =class("Monster",Character);

--------------属性表----------------------------
Monster.data={
    --怪物id
    --objId =1;

    --怪物血量
    --objBlood = 10;

    --怪物等级
    --level =1;

    --怪物名
    --objName = nil;


    --怪物attribute
    --attribute

    --怪物经验
    Experience =0,
    --怪物金钱
    Money =0
}
--怪物对象的实例话引用
--Monster.objInstantiate =nil;



--[[
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
]]--
--构造函数
function Monster:ctor(fillthing,objName,objBlood,objMaNa,objAttrubute,objExperience,objMoney,objInstantiate)
    Monster.super.ctor(self,"Monster",objName,objBlood,objMaNa,objAttrubute,objInstantiate);
    print("monster ctor run");
    self.data.Experience =objExperience or 0;
    self.data.Money =objMoney or 0;
    print("monster ctor finish");
end

--[[
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
]]--
-----------------------怪物战斗相关逻辑------------------
--掉落经验
function Monster:dropExperience()
    --  一到三只怪可以升一级
    --  后期可扩展为经验加成等
    -- 向下取整
    if self.data.Experience == 0 then
        self.data.Experience =math.floor(self.data.level/math.random(1,3));
    end

    return self.data.Experience
end
--根据等级掉落金币
function Monster:dropMoney()
    -- 根据等级掉落金币
    -- 后期可以扩展成金币加成
    if self.data.Money == 0 then
        self.data.Money = math.random(1,3)*self.data.level;
    end
    return self.data.Money
end
--------------------------------------------------------
function Monster:playerInformation()
    print("Player information is here");
    return 1
end


function Monster:clear()
    Monster.super.clear(self);
    print("Monster  drop");
end

return Monster