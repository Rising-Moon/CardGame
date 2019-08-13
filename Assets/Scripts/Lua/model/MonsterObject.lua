--class =require("class");
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


--构造函数
function Monster:ctor(objName,objBlood,objMaNa,objAttrubute,objExperience,objMoney,objInstantiate)
    Monster.super.ctor(self,objName,objBlood,objMaNa,objAttrubute,objInstantiate);
    print("monster ctor run");
    self.data.Experience =objExperience or 0;
    self.data.Money =objMoney or 0;
    print("monster ctor finish");
end


-----------------------怪物战斗相关逻辑------------------
--掉落经验
function Monster:dropExperience()
    --  一到三只怪可以升一级
    --  后期可扩展为经验加成等
    -- 向上取整
    if self.data.Experience == 0 then
        self.data.Experience =math.ceil(self.data.level/math.random(1,3));
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