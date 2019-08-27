---- 导包
local class = require("class");
local Character = require("CharacterObject");

-- 继承
local PlayerObject = class("PlayerObject",Character);

----属性列表
-- 经验值
PlayerObject.experience = 0;
-- 经验最大值
PlayerObject.maxExperience = 0;

--构造函数
function PlayerObject:ctor(name,maxLife,level,maxMana,maxExp)
    PlayerObject.super.ctor(self,name,maxLife,level,maxMana);
    self.experience = 0;
    self.maxExperience = maxExp * level;
end

return PlayerObject;