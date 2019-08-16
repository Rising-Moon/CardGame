---- 导包
local class = require("class");
local BaseObject = require("BaseObject");
-- 继承
local Character =class("Character",BaseObject);


----属性列表
--人物名字
Character.name = "";
--人物最大生命
Character.maxLife = 0.0;
--人物生命值
Character.life = 0.0;
--人物等级
Character.level = 0;
--人物最大法力值
Character.maxMana = 0.0;
--人物法力值
Character.mana = 0;
--额外属性
Character.attributeList ={};

--构造函数
function Character:ctor(name,maxLife,level,maxMana)
    Character.super.ctor(self);
    --属性设置
    self.name = name;
    self.maxLife = maxLife;
    self.life = maxLife;
    self.level = level;
    self.maxMana = maxMana;
    self.mana = maxMana;
end

return Character