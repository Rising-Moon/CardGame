local EnemyBehaviours = {}

local behaviours = {
    Treeman = {
        { player = { poi = 3 } },
        { player = { atk = 7 } },
        { player = { atk = 3, poi = 2 } }
    },
    Magician = {
        { player = { atk = 10, cost = 10 } },
        { player = { atk = 1 }, enemy = { mana_buff = 2 } }
    },
    Vampire = {
        { player = { atk = 1}, enemy = { pow = 3 } }
    }
}

-- 加载行为
function EnemyBehaviours:loadBehaviour(name)
    if (not behaviours[name]) then
        error("该行为集不存在");
        return nil;
    end
    return behaviours[name];
end

return EnemyBehaviours;