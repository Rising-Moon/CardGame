local CardListManager = require("CardListManager");
local EnemyObject = require("EnemyObject");
local PlayerObject = require("PlayerObject");
local DataProxy = require("DataProxy");
local UpdateUtil = require("HotUpdate");
local MusicManager = require("MusicManager");
--对应的view
local BattleView = require("BattleView");

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

----
--- Battle场景的控制器，对场景中的逻辑进行控制，从view获取输入，对model进行修改
----

BattleController = {};

----
--- 卡牌处理
----

-- 随机获取卡牌(发牌)
local licensing = function()
    if (#unUsedCards == 0) then
        print("卡池已空");
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
local abandonedCard = function(id)
    local index = 0;
    for i = 1, #usingCards do
        if (usingCards[i] == id) then
            index = i;
        end
    end
    table.insert(abandonedCards, usingCards[index]);
    table.remove(usingCards, index);
end

-- 弃牌堆回到卡组
local shuffle = function()
    for _, v in pairs(abandonedCards) do
        table.insert(unUsedCards, v);
    end
    abandonedCards = {};
end

----
--- 逻辑
----

-- 检查当前场景的状态
function checkState()

end

-- 使用卡牌(回调),获取卡牌信息，执行相应逻辑
function useCard(card)
    print("使用了卡牌\"" .. card.name .. "\"");
    for k, v in pairs(card.valueMap) do
        local switch = {
            -- atk 攻击
            atk = function()
                enemy.life = enemy.life - v;
                BattleView:playEnemyAnim("injured");
                MusicManager.afx:playClip("HitAfx", 0.5);
                abandonedCard(card.cardId);
            end,
            -- def 防御
            def = function()
                if (not player.attributeList.def) then
                    player.attributeList.def = 0;
                end
                player.attributeList.def = player.attributeList.def + v;
                MusicManager.afx:playClip("Armor", 0.5);
                abandonedCard(card.cardId);
            end,
            -- 防御翻倍
            mul_def = function()
                if (not player.attributeList.def) then
                    player.attributeList.def = 0;
                end
                player.attributeList.def = player.attributeList.def * v;
                MusicManager.afx:playClip("Armor", 0.5);
                abandonedCard(card.cardId);
            end,
        }
        if (switch[k]) then
            switch[k]();
        end
    end
    return true;
end

-- 拿起卡牌的回调
function pickCard(card)
    MusicManager.afx:playClip("PickCard",1);
    print("拿起卡牌:"..card.name);
end

-- 放下卡牌的回调
function putCard(card)

end

----
--- 非逻辑部分
----

function BattleController:reload()
    BattleView:reload(player, enemy);
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
    defalutP = DataProxy.createProxy(PlayerObject.new("骑士", 100, 1, 20, 100), {});
    defaultE = DataProxy.createProxy(EnemyObject.new("树人", 100, 20, 76, 20, 2, 2), {});

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
    BattleView:init(player, enemy);

    -- 初始化usingCards和unusedCards
    unUsedCards = CardListManager.getUserHaveCards();

    -- 设置卡牌使用的回调
    BattleView:setUseCardListener(useCard);

    -- 设置拿起卡牌的回调
    BattleView:setPickCardListener(pickCard);

    -- 设置放下卡牌的回调
    BattleView:setPutCardListener(putCard);
end

function BattleController:start()
    -- 播放背景音乐
    MusicManager.background:setMusic("BattleMusic");
    --MusicManager.background:play();
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
    -- 怪物数据(减少两点生命，两点法力)
    if (CS.UnityEngine.Input.GetKeyDown("n")) then
        enemy.life = enemy.life - 2;
        enemy.mana = enemy.mana - 2;
    end

    -- 发起热更请求
    if (CS.UnityEngine.Input.GetKeyDown("u")) then
        UpdateUtil:update();
    end

    -- 重载场景
    if (CS.UnityEngine.Input.GetKeyDown("t")) then
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