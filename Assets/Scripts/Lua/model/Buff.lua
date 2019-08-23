local Buff = {}

local buffs = {
    Attack = {name = "Attack",value = 0,IconName = "Attack"},
    Bleed = {name = "Bleed",value = 0,IconName = "Bleed"},
    Define = {name = "Define",value = 0,IconName = "Define"},
    Fire = {name = "Fire",value = 0,IconName = "Fire"},
    Poison = {name = "Poison",value = 0,IconName = "Poison"},
    Health = {name = "Health",value = 0,IconName = "Health"},
    Mana = {name = "Mana",value = 0,IconName = "Mana"},
    Water = {name = "Water",value = 0,IconName = "Water"},
}

-- 创建一个buff
function Buff:newBuff(name)
    if(not buffs[name]) then
        error("不存在这个buff");
        return nil;
    end
    local instance = {};
    setmetatable(instance,{__index = buffs[name]});
    return instance;
end

return Buff;