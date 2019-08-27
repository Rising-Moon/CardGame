local CardListManager = require("CardListManager");
local EnemyList = require("EnemyList");
local PlayerObject = require("PlayerObject");
local DataProxy = require("DataProxy");
local UpdateUtil = require("HotUpdate");
local MusicManager = require("MusicManager");
--对应的view
local BattleView = require("BattleView");

----
--- Battle场景的控制器，对场景中的逻辑进行控制，从view获取输入，对model进行修改
----

local BattleController = {};

----
--- 初始化数据和方法
----
-- 敌人
local enemy = nil;
-- 玩家角色
local player = nil;

-- 手牌
local usingCards = {};
-- 卡池
local unUsedCards = {};
-- 弃牌池
local abandonedCards = {};

-- 按钮点击事件
local clickEvents = {};

----
--- 效果
----

-- 玩家受伤效果
local function hurtPlayerAnim(degree)
    BattleView:playPlayerAnim("injured");
    degree = degree / 40;
    local volume = 0.5 + degree;
    if (volume > 1) then
        volume = 1;
    end
    print("volume:" .. volume);
    MusicManager.afx:playClip("HitAfx2", volume);
end

-- 敌人受伤效果
local function hurtEnemyAnim(degree)
    BattleView:playEnemyAnim("injured");
    local volume = 0.5 + degree / 40;
    if (volume > 1) then
        volume = 1;
    end
    print("volume:" .. volume);
    MusicManager.afx:playClip("HitAfx", volume);
end

-- 敌人攻击
local function enemyAttackAnim()
    BattleView:playEnemyAnim("attack");
end

-- 敌人死亡
local function enemyDie()
    for k, _ in pairs(enemy.attributeList) do
        enemy.attributeList[k] = 0;
    end
    BattleView:playEnemyAnim("die");
end

----
--- 卡牌处理
----

-- 弃牌堆回到卡组
local shuffle = function()
    for _, v in pairs(abandonedCards) do
        table.insert(unUsedCards, v);
    end
    abandonedCards = {};
end

-- 发牌一次
local function licensing()
    if (#unUsedCards == 0) then
        if (#abandonedCards ~= 0) then
            print("将弃牌堆洗回卡组");
            shuffle();
            licensing();
        else
            print("卡组已空");
        end
    else
        math.randomseed(tostring(os.time()):reverse():sub(1, 6));
        local id = math.random(1, #unUsedCards);
        table.insert(usingCards, unUsedCards[id]);
        local cardId = unUsedCards[id];
        table.remove(unUsedCards, id);
        if (cardId) then
            MusicManager.afx:playClip("Licens", 1);
            BattleView:addCardToHand(CardListManager.getCard(cardId));
        end
    end
end

-- 卡牌进入弃牌堆
local function abandonedCard(id)
    local index = 0;
    for i = 1, #usingCards do
        if (usingCards[i] == id) then
            index = i;
        end
    end
    table.insert(abandonedCards, usingCards[index]);
    table.remove(usingCards, index);
end

----
--- 逻辑
--- 游戏阶段:
---     对战:
---     start(): 对战开始
---     settle(): 对战结束，进行结算
---     回合:
---     startTurn():玩家回合开始
---     endTurn():玩家回合结束
---     enemyAct():敌人行动
---     settleTurn():回合结算 (判断游戏是否结束,处理回合间逻辑。例如：对buff进行结算)
---     行动: (敌人行动、玩家使用卡牌和回合结算都算作一次行动)
---     checkState():每次行动结束后进行结算
----

-- 回合数
local round = 0;

-- 发牌数量
local licensingNum = 3;

-- 玩家回合开始
local function startTurn()
    BattleView:startTurn();
    -- 回合数增加
    round = round + 1;
    -- 发牌(加上玩家抽牌数buff)
    for i = 1, licensingNum do
        invoke(licensing, 0.2 * (i - 1));
    end
    -- 恢复法力值到上限
    player.mana = player.maxMana;
end

-- 开始游戏
local function start()
    startTurn();
end

-- 游戏结算
-- 0:玩家胜利
-- 1:敌人胜利
local function settle(winner)
    if (winner == 0) then
        enemyDie();
        print("玩家胜利");
    else
        print("敌人胜利");
    end
end

-- 行动缓存(用于每次行动的结算)
-- 内部数据为player和enemy两张表，表中元素是对相应目标造成的效果
-- 例如：Cache = {player = {poison = 2},enemy = {attack = 1}} 意思为此次行动对玩家叠加2层中毒，对敌人造成1点伤害。
local stateCache = { player = {}, enemy = {} };
-- stateCache便捷修改
local stateModify = { player = {}, enemy = {} };

local function setModify(tab, target)
    local stateMeta = {
        __index = function(s, name)
            if (not target[name]) then
                target[name] = 0;
            end
            return target[name];
        end,
        __newindex = function(s, name, value)
            if (not target[name]) then
                target[name] = 0;
            end
            target[name] = value;
        end
    };
    setmetatable(tab, stateMeta);
end

setModify(stateModify.player, stateCache.player);
setModify(stateModify.enemy, stateCache.enemy);


-- 结算每次行动效果
local function checkState(target)
    local targetCha;
    -- 设置结算目标
    if (not target) then
        -- 如果无参调用，结算两者(先player后enemy)
        checkState(player);
        targetCha = "enemy";
        target = enemy;
    else
        -- 如果带参就只结算传入对象
        if (target == player) then
            targetCha = "player";
        else
            targetCha = "enemy";
        end
    end

    -- buff表
    local buffs = {};
    setModify(buffs, target.attributeList);

    -- 处理产生的效果
    for k, v in pairs(stateCache[targetCha]) do
        if (k == "health_value") then
            target.life = target.life + v;
            if (v < 0) then
                if (targetCha == "player") then
                    hurtPlayerAnim(-v);
                else
                    hurtEnemyAnim(-v);
                end
            end
        elseif (k == "mana_value") then
            target.mana = target.mana + v;
        elseif (k == "define") then
            buffs.Define = buffs.Define + v;
            if (v > 0) then
                MusicManager.afx:playClip("Armor", 0.5);
            elseif (v < 0) then
                MusicManager.afx:playClip("BreakArmor", 1);
            end
        elseif (k == "water") then
            buffs.Water = buffs.Water + v;
            if (v > 0) then
                MusicManager.afx:playClip("Debuff", 1);
            elseif(v < 0) then
                MusicManager.afx:playClip("ReduceBuff",1);
            end
        elseif (k == "power") then
            buffs.Power = buffs.Power + v;
            if (v > 0) then
                MusicManager.afx:playClip("Debuff", 1);
            elseif(v < 0) then
                MusicManager.afx:playClip("ReduceBuff",1);
            end
        elseif (k == "bleed") then
            buffs.Bleed = buffs.Bleed + v;
            if (v > 0) then
                MusicManager.afx:playClip("Debuff", 1);
            elseif(v < 0) then
                MusicManager.afx:playClip("ReduceBuff",1);
            end
        elseif (k == "fire") then
            buffs.Fire = buffs.Fire + v;
            if (v > 0) then
                MusicManager.afx:playClip("Debuff", 1);
            elseif(v < 0) then
                MusicManager.afx:playClip("ReduceBuff",1);
            end
        elseif (k == "poison") then
            buffs.Poison = buffs.Poison + v;
            if (v > 0) then
                MusicManager.afx:playClip("Debuff", 1);
            elseif(v < 0) then
                MusicManager.afx:playClip("ReduceBuff",1);
            end
        elseif (k == "health") then
            buffs.Health = buffs.Health + v;
            if (v > 0) then
                MusicManager.afx:playClip("Debuff", 1);
            elseif(v < 0) then
                MusicManager.afx:playClip("ReduceBuff",1);
            end
        elseif (k == "mana") then
            buffs.Mana = buffs.Mana + v;
            if (v > 0) then
                MusicManager.afx:playClip("Debuff", 1);
            elseif(v < 0) then
                MusicManager.afx:playClip("ReduceBuff",1);
            end
        end
    end

    -- 处理结束后清除缓存
    stateCache[targetCha] = {};
    setModify(stateModify[targetCha], stateCache[targetCha]);

    -- 是否有死亡
    if (player.life <= 0) then
        -- 敌人胜利结算
        settle(1);
        return ;
    end
    if (enemy.life <= 0) then
        -- 玩家胜利结算
        settle(0);
    end
end

-- 回合结算
local function settleTurn(target)
    local targetName;
    if (not target) then
        target = enemy;
    end
    if (target == enemy) then
        targetName = "enemy";
    else
        targetName = "player";
    end

    -- 遍历目标身上的buff
    for k, v in pairs(target.attributeList) do
        -- 流血
        if (k == "Bleed" and v > 0) then
            local bleedDamage = math.floor(target.maxLife * 0.05);

            if (target.attributeList.Fire > 0) then
                bleedDamage = bleedDamage + target.attributeList.Fire;
                stateModify[target].fire = -math.floor(target.attributeList.Fire / 2);
            end

            if (not target.attributeList.Define) then
                target.attributeList.Define = 0;
            end

            local damage = bleedDamage - target.attributeList.Define;
            if (damage < 0) then
                stateModify[targetName].define = -bleedDamage;
                damage = 0;
            else
                stateModify[targetName].define = -target.attributeList.Define;
            end
            stateModify[targetName].health_value = stateModify[targetName].health_value - damage;

            stateModify[targetName].health_value = -math.floor(target.maxLife * 0.05);
            stateModify[targetName].bleed = -1;
            -- 中毒
        elseif (k == "Poison" and v > 0) then
            stateModify[targetName].health_value = -v;
            stateModify[targetName].poison = -1;
            MusicManager.afx:playClip("Poison", 1);
            BattleView:playPlayerAnim("poison");
            -- 恢复生命
        elseif (k == "Health" and v > 0) then
            stateModify[targetName].health_value = v;
            -- 恢复魔力
        elseif (k == "Mana" and v > 0) then
            stateModify[targetName].mana_value = v;
        end
    end
end

-- 行为解析，计算出结果加入到行动缓存
local function analysze(tab, target, source)
    local aims = {};
    aims.player = player;
    aims.enemy = enemy;
    for k, v in pairs(tab) do
        local switch = {
            -- cost 消耗法力值
            cost = function()
                stateModify[source].mana_value = stateModify[source].mana_value - v;
            end,
            -- atk 攻击: 计算造成伤害加上力量值与燃烧数值后减去对方护盾值后的伤害值
            atk = function()
                -- 确认几个buff不为nil
                if (not aims[target].attributeList.Define) then
                    aims[target].attributeList.Define = 0;
                end
                if (not aims[source].attributeList.Power) then
                    aims[source].attributeList.Power = 0;
                end
                if (not aims[target].attributeList.Fire) then
                    aims[target].attributeList.Fire = 0;
                end

                -- 总伤害（未计算防御）
                local ori = v + aims[source].attributeList.Power;
                if (aims[target].attributeList.Fire > 0) then
                    ori = ori + aims[target].attributeList.Fire;
                    stateModify[target].fire = -math.floor(aims[target].attributeList.Fire / 2);
                end

                -- 实际造成伤害
                local damage = ori - aims[target].attributeList.Define;
                if (damage < 0) then
                    stateModify[target].define = -ori;
                    damage = 0;
                else
                    stateModify[target].define = -aims[target].attributeList.Define;
                end
                stateModify[target].health_value = stateModify[target].health_value - damage;
            end,
            -- atk_real 真实伤害
            atk_real = function()
                stateModify[target].health_value = stateModify[target].health_value - v;
            end,
            -- def 防御
            def = function()
                stateModify[source].define = stateModify[source].define + v;
            end,
            -- mul_def 防御翻倍
            mul_def = function()
                if (not aims[source].attributeList.Define) then
                    aims[source].attributeList.Define = 0;
                end
                stateModify[source].define = aims[source].attributeList.Define + stateModify[source].define * (v - 1);
            end,
            -- poi 毒
            poi = function()
                stateModify[target].poison = stateModify[target].poison + v;
            end,
            -- bleed 流血
            bleed = function()
                stateModify[target].bleed = stateModify[target].bleed + v;
            end,
            -- mana 魔力回复buff
            mana_buff = function()
                stateModify[target].mana = stateModify[target].mana + v;
            end,
            -- atk_def 造成当前防御的伤害
            atk_def = function()
                -- 确认几个buff不为nil
                if (not aims[target].attributeList.Define) then
                    aims[target].attributeList.Define = 0;
                end
                if (not aims[source].attributeList.Define) then
                    aims[source].attributeList.Define = 0;
                end
                if (not aims[source].attributeList.Power) then
                    aims[source].attributeList.Power = 0;
                end
                if (not aims[target].attributeList.Fire) then
                    aims[target].attributeList.Fire = 0;
                end

                -- 总伤害（未计算防御）
                local ori = v * aims[source].attributeList.Define + aims[source].attributeList.Power;
                if (aims[target].attributeList.Fire > 0) then
                    ori = ori + aims[target].attributeList.Fire;
                    stateModify[target].fire = -math.floor(aims[target].attributeList.Fire / 2);
                end

                -- 实际造成伤害
                local damage = ori - aims[target].attributeList.Define;
                if (damage < 0) then
                    stateModify[target].define = -ori;
                    damage = 0;
                else
                    stateModify[target].define = -aims[target].attributeList.Define;
                end
                stateModify[target].health_value = stateModify[target].health_value - damage;
            end,
            pow = function()
                -- 确认几个buff不为nil
                stateModify[target].power = stateModify[target].power + v;
            end
        }
        if (switch[k]) then
            switch[k]()
            ;
        end
    end
end

-- 辅助函数
-- 回合结算（Player）
local function settleTurnPlayer()
    settleTurn(enemy);
end
-- 回合结算（Enemy）
local function settleTurnEnemy()
    settleTurn(player);
end

-- 敌人行动
local function enemyAct()
    print("敌人行动");
    -- 播放攻击动画
    enemyAttackAnim();
    -- 敌人行动列表下标
    local index = round % #enemy.behaviour;
    if (index == 0) then
        index = #enemy.behaviour;
    end
    -- 根据回合数决定敌人行动
    -- 如果魔力值足够才进行行动
    if (enemy.behaviour[index].player.cost and enemy.mana < enemy.behaviour[index].player.cost) then
        print("敌人魔力值不足");
    else
        if (enemy.behaviour[index].player) then
            analysze(enemy.behaviour[index].player, "player", "enemy");
        end
        if (enemy.behaviour[index].enemy) then
            analysze(enemy.behaviour[index].enemy, "enemy", "player");
        end
    end

    print(enemy.attributeList.Mana);

    -- 敌人行动后行动结算一次
    invoke(checkState, 0.05);
    -- 行动结算后回合结算
    invoke(settleTurnEnemy, 1.1);
    invoke(checkState, 1.5);
    invoke(settleTurnPlayer, 1.6);
    invoke(checkState, 1.8);
    -- 开始玩家回合
    invoke(startTurn, 2.3);
end

-- 回合结束(由玩家回合时玩家点击结束按钮调用)
local function endTurn()
    BattleView:endTurn();

    -- 敌人开始行动
    enemyAct();
end



-- 使用卡牌(回调),获取卡牌信息，执行相应逻辑
local function useCard(card)
    print("使用了卡牌\"" .. card.name .. "\"");
    print(card.valueMap.cost);
    if (card.cost > player.mana) then
        return false;
    end

    -- 解析卡牌效果
    analysze(card.valueMap, "enemy", "player");
    -- 卡牌进入弃牌堆
    abandonedCard(card.cardId);

    -- 结算行动
    checkState();
    return true;
end

-- 拿起卡牌的回调
local function pickCard(card)
    MusicManager.afx:playClip("PickCard", 1);
    print("拿起卡牌:" .. card.name);
end

-- 放下卡牌的回调
local function putCard(card)
    MusicManager.afx:playClip("PutCard", 1);
    print("放下卡牌:" .. card.name);
end

----
--- 点击事件
----

-- 结束回合按钮
function clickEvents.nextTurnfunc()
    endTurn();
end

----
--- 非逻辑部分
----

function BattleController:reload()
    BattleView:reload(player, enemy, clickEvents);
    for _, v in pairs(usingCards) do
        BattleView:addCardToHand(CardListManager.getCard(v));
    end
end

----
--- 生命周期回调
----

-- 初始化(由app.lua调用，可接收参数)
-- 调试用
function BattleController:init(p, e)

    -- 调试数据，实际上应该由外部传入
    local defalutP = DataProxy.createProxy(PlayerObject.new("冒险者", 70, 1, 3, 100), {});
    local defaultE = DataProxy.createProxy(EnemyList:create("Vampire"), {});

    -- 初始化数据
    if (p) then
        player = p;
    else
        player = defalutP;
    end
    if (e) then
        enemy = e;
    else
        enemy = defaultE;
    end

    -- 初始化view
    BattleView:init(player, enemy, clickEvents);

    -- 初始化usingCards和unusedCards
    unUsedCards = CardListManager.getUserHaveCards();

    -- 设置卡牌使用的回调
    BattleView:setUseCardListener(useCard);

    -- 设置拿起卡牌的回调
    BattleView:setPickCardListener(pickCard);

    -- 设置放下卡牌的回调
    BattleView:setPutCardListener(putCard);

    -- 开始游戏
    start();
end

function BattleController:start()
    -- 播放背景音乐
    MusicManager.background:setMusic("BattleMusic");
    MusicManager.background:play();
end

function BattleController:update()
    BattleView:update()

    ----
    --- 调试
    ----
    -- 模拟抽卡
    if (CS.UnityEngine.Input.GetKeyDown("a")) then
        licensing();
    end
    -- 玩家被攻击
    if (CS.UnityEngine.Input.GetKeyDown("n")) then
    end
    -- 敌人buff
    if (CS.UnityEngine.Input.GetKeyDown("m")) then
        enemy.attributeList.Power = 3;
    end


    -- 发起热更请求
    if (CS.UnityEngine.Input.GetKeyDown("u")) then
        UpdateUtil:update();
    end

    -- 重载场景
    if (CS.UnityEngine.Input.GetKeyDown("r")) then
        BattleController:reload();
    end

    -- 卡牌调试
    if (CS.UnityEngine.Input.GetKeyDown("1")) then
        shuffle();
    end
    if (CS.UnityEngine.Input.GetKeyDown("2")) then
        print("卡组：");
        for k, v in pairs(unUsedCards) do
            print(k .. ":" .. CardListManager.getCard(v).name);
        end
        print("手牌：");
        for k, v in pairs(usingCards) do
            print(k .. ":" .. CardListManager.getCard(v).name);
        end
        print("弃牌堆：");
        for k, v in pairs(abandonedCards) do
            print(k .. ":" .. CardListManager.getCard(v).name);
        end
    end
end

return BattleController;