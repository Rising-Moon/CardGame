-- 导包
local EnemyObject = require("EnemyObject");

local EnemyList = {};

-- 敌人属性列表
-- item内容：{名字，最大生命值，等级，最大魔力值，掉落经验，掉落金钱，行为名}
local objectList = {
    TreeMan = {"TreeMan", 40, 1, 3, 20, 2, "Treeman"},
    Magician = {"Magician",30,1,20,20,2,"Magician"},
    Vampire = {"Vampire",20,1,0,10,10,"Vampire"}
}

-- 创建敌人
function EnemyList:create(name)
    if(not objectList[name]) then
        print("列表中不存在此类敌人");
        return nil;
    end

    local enemyAtt = objectList[name];
    return EnemyObject.new(enemyAtt[1],enemyAtt[2],enemyAtt[3],enemyAtt[4],enemyAtt[5],enemyAtt[6],enemyAtt[7]);
end

return EnemyList;