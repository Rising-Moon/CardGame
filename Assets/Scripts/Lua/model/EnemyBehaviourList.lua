local EnemyBehaviours = {}

local behaviours = {
    Treeman = {
        {player = {poison = 2}},
        {player = {attack = 10}},
        {player = {attack = 5,poison = 1}}
    }
}

-- 加载行为
function EnemyBehaviours:loadBehaviour(name)
    if(not behaviours[name]) then
        error("该行为集不存在");
        return nil;
    end
    local beh = {};
    setmetatable(beh,{__index = behaviours[name]});
    return beh;
end

return EnemyBehaviours;