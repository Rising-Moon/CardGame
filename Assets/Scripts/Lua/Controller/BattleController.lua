local CardListManager = require("CardListManager");
local EnemyObject = require("EnemyObject");
local PlayerObject = require("PlayerObject");
local DataProxy = require("DataProxy");

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
-- 随机获取卡牌
local licensing = function()
    if (#unUsedCards == 0) then
        print("卡池已空");
    else
        math.randomseed(tostring(os.time()):reverse():sub(1, 6));
        local id = math.random(1, #unUsedCards);
        table.insert(usingCards, unUsedCards[id]);
        local cardId = unUsedCards[id];
        table.remove(unUsedCards, id);
        return cardId;
    end
    return nil;
end

----
--- Battle场景的控制器，对场景中的逻辑进行控制，从view获取输入，对model进行修改
----

--对应的view
local BattleView = require("BattleView");

BattleController = {};

-- 检查当前场景的状态
function checkState()

end

-- 使用卡牌(回调)
function useCard(card)
    print("使用了卡牌\"" .. card.name .. "\"");
    for k, v in pairs(card.valueMap) do
        local switch = {
            -- atk 攻击
            atk = function()
                enemy.life = enemy.life - v;
            end,
            -- def 防御
            def = function()

            end
        }
        if (switch[k]) then
            switch[k]();
        end
    end
    return true;
end

-- 初始化(由app.lua调用，可接收参数)
-- 调试用
function BattleController:init(ene)
    -- 初始化view
    player = DataProxy.createProxy(PlayerObject.new("Knight",100,1,20,100),{});
    BattleView:init(player);

    if (ene) then
        enemy = ene;
    end
    -- 初始化usingCards和unusedCards
    unUsedCards = CardListManager.getUserHaveCards();

    -- 设置卡牌使用的回调
    BattleView:setUseCardListener(useCard);
end

function BattleController:start()

end

function BattleController:update()

    BattleView:update()

    -- 调试
    -- 修改卡牌数据
    if (CS.UnityEngine.Input.GetKeyDown("r")) then
        CardListManager.getCard(1).name = "no name";
    end
    -- 模拟抽卡
    if (CS.UnityEngine.Input.GetKeyDown("a")) then
        local cardid = licensing();
        if (cardid) then
            print("创建卡牌" .. cardid);
            BattleView:addCardToHand(CardListManager.getCard(cardid));
        end
    end

    -- 模拟初始化怪物
    if (CS.UnityEngine.Input.GetKeyDown("m")) then
        if (not enemy) then
            enemy = DataProxy.createProxy(EnemyObject.new("树人", 100, 20, 76, 20, 2, 2), {});
            BattleView:createEnemy(enemy);
        end
    end
    -- 修改怪物数据
    if (CS.UnityEngine.Input.GetKeyDown("n")) then
        enemy.life = enemy.life - 2;
        enemy.mana = enemy.mana - 2;
    end
end

return BattleController;