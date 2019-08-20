---- 导包
local class = require("class");
local Character = require("CharacterObject");

-- 继承
local Enemy = class("Enemy",Character);

----属性列表
-- 掉落经验
Enemy.dropExperience = 0;
-- 掉落金钱
Enemy.dropMoney = 0;

--构造函数
function Enemy:ctor(name,maxLife,level,maxMana,dropExp,dropMoney)
    Enemy.super.ctor(self,name,maxLife,level,maxMana);
    self.dropExperience = dropExp;
    self.dropMoney = dropMoney;
end

return Enemy