local ScenesManager = require("ScenesManager");
local UIUtil = require("UIUtil");
local CardView = require("CardView");
local EnemyView = require("EnemyView");
local PlayerView = require("PlayerView");
local ResourcesManager = require("ResourcesManager");

BattleView = {};

----
--- 初始化变量和函数
----
-- 画布
local canvas = ScenesManager:initRoot();

-- 按ui节点名存储的map
local uiMap = UIUtil.genAllChildNameMap(canvas);

-- 世界坐标转换到屏幕坐标
local world2screen = function(pos)
    return CS.UnityEngine.Camera.main:WorldToScreenPoint(pos);
end

-- 屏幕坐标转换到世界坐标
local screen2world = function(pos)
    return CS.UnityEngine.Camera.main:ScreenToWorldPoint(pos);
end

----
--- 玩家
----
--  玩家实例
local playerObject = nil;

-- 玩家位置
local playerInfoPos = uiMap["PlayerInfoPos"];

-- 加载玩家信息
function createPlayerInfo(player)
    playerObject = PlayerView:createView(player, playerInfoPos);
    playerObject.transform.position = playerInfoPos.transform.position;
end


----
--- 怪物
----
-- 怪物实例
local enemyObject = nil;

-- 怪物位置
local enemyPos = uiMap["EnemyPos"];

-- 怪物动画
local enemyAnim = nil;

-- 加载怪物（提供给controller使用）
function createEnemy(enemy)
    enemyObject = EnemyView:createView(enemy, enemyPos, "Enemy");
    enemyObject.transform.position = enemyPos.transform.position;
    enemyAnim = enemyObject:GetComponent("Animator");
end

-- 播发怪物动画
function BattleView:playEnemyAnim(name)
    local anims = {
        injured = function()
            enemyAnim:SetTrigger("injured");
        end
    }
    anims[name]();
end

----
--- 设置手牌布局 界面中的所有用到卡牌的都在这部分中
----

-- 手牌位置
local handPosition = world2screen(uiMap["Hand"].position);
-- 手牌最左最右位置的偏移值
local cardBoundOffset = CS.UnityEngine.Screen.width * 1 / 3;
-- 最左和最右的位置
local left = CS.UnityEngine.Vector3(handPosition.x - cardBoundOffset, handPosition.y, handPosition.z);
--local right = CS.UnityEngine.Vector3(handPosition.x + offset, handPosition.y, handPosition.z);

-- 手牌最大间隔
local maxInterval = 60;

-- 手牌列表
-- 列表中item的属性: card代表CardObject实例，object代表匹配的GameObject实例，moveUtil代表其上的C#脚本MoveUtil
local handCards = {}
-- 手牌数量
local handCardCount = 0;
-- 牌堆
local cardPile = uiMap["CardPile"];
-- 弃牌堆
local discardPile = uiMap["DiscardPile"];

-- 调整手牌位置
function adjustHandsCard()
    -- 卡牌位置调整速度
    local moveSpeed = 15;
    -- 排序一次手牌
    table.sort(handCards, function(a, b)
        print(a.card.objId);
        return (a.card.cardId < b.card.cardId);
    end)
    -- 调整卡牌位置
    if (handCardCount == 1) then
        for _, v in pairs(handCards) do
            v.moveUtil:SmoothMove(screen2world(handPosition), moveSpeed, 1);
            v.moveUtil:SetOriginPoint(screen2world(handPosition));
        end
    elseif ((handCardCount - 1) * maxInterval < cardBoundOffset * 2) then
        local off = -handCardCount / 2;
        for _, v in pairs(handCards) do
            local pos = screen2world(handPosition + CS.UnityEngine.Vector3(maxInterval * off, 0, 0));
            v.moveUtil:SmoothMove(pos, moveSpeed, 1);
            v.object.transform:SetAsLastSibling();
            v.moveUtil:SetOriginPoint(pos);
            off = off + 1;
        end
    else
        local pos = {};
        local index = 1;
        for i = 1, handCardCount do
            table.insert(pos, left + CS.UnityEngine.Vector3(cardBoundOffset * 2 / (handCardCount - 1), 0, 0) * (i - 1));
        end
        for _, v in pairs(handCards) do
            v.moveUtil:SmoothMove(screen2world(pos[index]), moveSpeed, 1);
            v.object.transform:SetAsLastSibling();
            v.moveUtil:SetOriginPoint(screen2world(pos[index]));
            index = index + 1;
        end
    end
end

-- 新建卡牌到手牌（提供给controller使用）
function BattleView:addCardToHand(card)
    local cardObject = CardView:createView(card, uiMap["Hand"]);
    cardObject.transform.position = cardPile.transform.position;
    handCards[cardObject:GetHashCode()] = { card = card, object = cardObject, moveUtil = cardObject:GetComponent("MoveUtil") };
    handCardCount = handCardCount + 1;
    adjustHandsCard();
end

-- 进入弃牌堆
function putToDiscard(card)
    if (handCards[card.object:GetHashCode()]) then
        removeFromHand(card);
    end
    -- 消除标签，使其不会再被选中
    card.object.tag = 'Untagged';
    card.moveUtil:Discard(discardPile.transform.position, 15, 0, function()
        destroyCard(card);
    end);
end

-- 销毁卡牌（彻底删除卡牌）
function destroyCard(card)
    if (handCards[card.object:GetHashCode()]) then
        handCards[card.object:GetHashCode()] = nil;
    end
    CardView:destroy(card.card, card.object);
    card.card = nil;
    card.cardObject = nil;
    moveUtil = nil;
end

-- 从手牌列表中移除（即不参与手牌的排列）
function removeFromHand(object)
    local card = handCards[object:GetHashCode()];
    handCards[object:GetHashCode()] = nil;
    handCardCount = handCardCount - 1;
    adjustHandsCard();
    return card;
end

-- 加入到手牌列表（参与手牌排列）
function putToHand(card)
    handCards[card.object:GetHashCode()] = card;
    handCardCount = handCardCount + 1;
    adjustHandsCard();
end



----
--- 处理鼠标与卡牌的交互，鼠标移动到卡牌上时放大并置顶卡牌，左键按下时卡牌开始跟随鼠标，
--- 放开鼠标时判断卡牌位置是否触发使用卡牌，触发则使用使用回调函数让BattleController
--- 处理，不触发则将卡牌还原到初始位置。
----

--选中的卡牌
local card = nil;
--待选卡牌
local selectCard = nil;
--卡牌的移动工具
local moveUtil = nil;
--鼠标位置与卡牌的相对位置
local offset = nil;
--卡牌的初始位置
local originPosition = nil;
--卡牌的初始大小
local originSize = nil;
--卡牌的初始层级
local originSibling = nil;
--卡牌使用回调
local useCardCallBack = nil;
--拿起卡牌回调
local pickCardCallBack = nil;
--放下卡牌回调
local putCardCallBack = nil;

--设置卡牌使用回调
function BattleView:setUseCardListener(func)
    useCardCallBack = func;
end

--设置拿起卡牌回调
function BattleView:setPickCardListener(func)
    pickCardCallBack = func;
end

--设置放下卡牌回调
function BattleView:setPutCardListener(func)
    putCardCallBack = func;
end

--卡牌与鼠标的交互
function cardInteraction()
    --鼠标所在位置
    local mousePosition = screen2world(CS.UnityEngine.Input.mousePosition);
    if (card) then
        --已选中卡牌跟随鼠标
        if (CS.UnityEngine.Input.GetMouseButton(0)) then
            if (moveUtil) then
                moveUtil:SmoothMove(mousePosition + offset, 50);
            end
        end
        --放开卡牌
        if (CS.UnityEngine.Input.GetMouseButtonUp(0)) then
            local threshold = CS.UnityEngine.Screen.height / 5 * 2;
            local cardScreenPoint = world2screen(card.object.transform.position);
            local useSuccess = false;
            -- 如果卡牌拖动位置高于屏幕2/5的高度，则判定使用了卡牌
            if (cardScreenPoint.y > threshold) then
                -- 回调给Controller处理，并接收返回值，true为成功被使用，回调结束后销毁卡牌，false为无法使用。
                if (useCardCallBack) then
                    useSuccess = useCardCallBack(card.card);
                end
            end
            -- 卡牌移动回原位
            if (moveUtil and not useSuccess) then
                putToHand(card);
                moveUtil:SmoothMoveBack(20, 1);
                -- 使用卡牌失败时，卡牌回到原位并触发回调
                if (putCard) then
                    putCard(card.card);
                end
            elseif (moveUtil and useSuccess) then
                -- destroyCard(card);
                putToDiscard(card);
                selectCard = nil;
            end
            card = nil;
            offset = nil;
            originPosition = nil;
        end

    else
        local hitObject = CS.SelectUtil.ObjectOnMouse();

        --鼠标移动到卡牌上时
        if (selectCard ~= hitObject) then
            if (selectCard) then
                selectCard.transform.localScale = originSize;
                selectCard.transform:SetSiblingIndex(originSibling);
            end
            if (hitObject and hitObject.tag == 'Card') then
                originSize = hitObject.transform.localScale;
                originSibling = hitObject.transform:GetSiblingIndex();
                selectCard = hitObject;
                selectCard.transform.localScale = originSize * 1.5;
                selectCard.transform:SetAsLastSibling();
            elseif (hitObject == nil) then
                originSize = nil;
                originSibling = nil;
                selectCard = nil;
            end
        end
        --抓住卡牌
        if (CS.UnityEngine.Input.GetMouseButtonDown(0)) then
            if (hitObject and hitObject.tag == 'Card') then
                card = removeFromHand(hitObject);
                selectCard.transform:SetAsLastSibling();
                offset = hitObject.transform.position - mousePosition;
                originPosition = hitObject.transform.position;
                moveUtil = card.moveUtil;
                --抓起卡牌时使用回调
                if (pickCardCallBack) then
                    pickCardCallBack(card.card);
                end
            end
        end
    end
end

-- view 初始化
function BattleView:init(player, enemy)
    -- 创建玩家信息界面
    createPlayerInfo(player);
    -- 加载怪物
    createEnemy(enemy);
end

-- 重载界面
function BattleView:reload(player, enemy, hand)
    -- 卸载场景中的界面
    for k, v in pairs(handCards) do
        CardView:destroy(v.card, v.object);
    end
    handCards = {};
    handCardCount = 0;
    if (playerObject) then
        PlayerView:destroy(player, playerObject);
    end
    if (enemyObject) then
        EnemyView:destroy(enemy, enemyObject);
    end
    -- 重载界面
    package.loaded["PlayerView"] = nil;
    package.loaded["EnemyView"] = nil;
    package.loaded["CardView"] = nil;
    CardView = require("CardView");
    EnemyView = require("EnemyView");
    PlayerView = require("PlayerView");
    ResourcesManager:clear();

    -- 初始化场景
    BattleView:init(player, enemy);

end

function BattleView:update()
    -- 卡牌交互
    cardInteraction();
end

return BattleView;