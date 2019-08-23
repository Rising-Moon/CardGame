---- 导包
local class = require("class");
local Character = require("CharacterObject");
local BehaviourList = require("EnemyBehaviourList");

-- 继承
local Enemy = class("Enemy", Character);

----属性列表
-- 掉落经验
Enemy.dropExperience = 0;
-- 掉落金钱
Enemy.dropMoney = 0;
-- 行为列表
Enemy.buhaviour = {};


--构造函数
function Enemy:ctor(name, maxLife, level, maxMana, dropExp, dropMoney,behaviour)
    Enemy.super.ctor(self, name, maxLife * (1 + (level - 1) * 0.2), level, maxMana * (1 + (level - 1) * 0.2));
    self.dropExperience = dropExp * level * 0.5;
    self.dropMoney = dropMoney * level;
    self.behaviour = BehaviourList:loadBehaviour(behaviour);
end

return Enemy