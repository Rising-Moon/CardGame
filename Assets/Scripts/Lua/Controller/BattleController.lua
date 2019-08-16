local CardListManager = require("CardListManager");
local cardView = require("CardView");
local EnemyObject = require("EnemyObject");
local DataProxy = require("DataProxy");

----
--- 初始化数据和方法
----
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

--使用卡牌
function useCard(card)
    print("使用了卡牌" .. card.cardId);
    return true;
end

-- 初始化(由app.lua调用，可接收参数)
function BattleController:init()
    BattleView:init();
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
    if (CS.UnityEngine.Input.GetKeyDown("r")) then
        CardListManager.getCard(1).name = "no name";
    end
    if (CS.UnityEngine.Input.GetKeyDown("a")) then
        local cardid = licensing();
        if (cardid) then
            print("创建卡牌" .. cardid);
            BattleView:addCardToHand(CardListManager.getCard(cardid));
        end
    end
    local enemy = EnemyObject.new("123",20,20,20,20,2,2);
    enemy = DataProxy.createProxy(enemy,{});
    if (CS.UnityEngine.Input.GetKeyDown("m")) then
        BattleView:createEnemy(enemy);
    end
    if (CS.UnityEngine.Input.GetKeyDown("n")) then
        enemy.life = enemy.life - 2;
    end
end

return BattleController;