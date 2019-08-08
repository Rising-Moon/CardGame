BattleController = {};

local CardController = {};
--选中的卡牌
CardController.card = nil;
--待选卡牌
CardController.selectCard = nil;
--卡牌的移动工具
CardController.moveUtil = nil;
--鼠标位置与卡牌的相对位置
CardController.offset = nil;
--卡牌的初始位置
CardController.originPosition = nil;
--卡牌的初始大小
CardController.originSize = nil;
--卡牌的初始层级
CardController.originSibling = nil;
--卡牌移动方法d
function CardController.CardMove()
    --鼠标所在位置
    local mousePosition = CS.UnityEngine.Camera.main:ScreenToWorldPoint(CS.UnityEngine.Input.mousePosition);
    if (CardController.card) then
        --已选中卡牌跟随鼠标
        if (CS.UnityEngine.Input.GetMouseButton(0)) then
            if(CardController.moveUtil)then
                CardController.moveUtil:SmoothMove(mousePosition + CardController.offset,50);
            end
        end
        --放开卡牌
        if (CS.UnityEngine.Input.GetMouseButtonUp(0)) then
            if(CardController.moveUtil) then
                CardController.moveUtil:SmoothMoveBack(20,1);
            end
            CardController.card = nil;
            CardController.offset = nil;
            CardController.originPosition = nil;
        end

    else
        local mouseRay = CS.UnityEngine.Camera.main:ScreenPointToRay(CS.UnityEngine.Input.mousePosition);
        local hitObject = CS.RayCastUtil.RayCastObject2D(mouseRay);

        --鼠标移动到卡牌上时
        if (CardController.selectCard ~= hitObject) then
            if (CardController.selectCard) then
                CardController.selectCard.transform.localScale = CardController.originSize;
                CardController.selectCard.transform:SetSiblingIndex(CardController.originSibling);
            end
            if (hitObject) then
                CardController.originSize = hitObject.transform.localScale;
                CardController.originSibling = hitObject.transform:GetSiblingIndex();
                CardController.selectCard = hitObject;
                CardController.selectCard.transform.localScale = CardController.originSize * 1.2;
                CardController.selectCard.transform:SetAsLastSibling();
                --print('size: x' .. CardController.originSize.x .. 'y' .. CardController.originSize.y .. 'z' .. CardController.originSize.z .. 'oriSibling:' .. CardController.originSibling);
            else
                CardController.originSize = nil;
                CardController.originSibling = nil;
                CardController.selectCard = nil;
            end
        end
        --抓住卡牌
        if (CS.UnityEngine.Input.GetMouseButtonDown(0)) then
            if (hitObject ~= nil and hitObject.tag == 'Card') then
                CardController.card = hitObject;
                CardController.offset = hitObject.transform.position - mousePosition;
                CardController.originPosition = hitObject.transform.position;
                CardController.moveUtil = CardController.card:GetComponent("MoveUtil");
            end
        end
    end
end

function BattleController:init()
end

function BattleController.update()
    CardController.CardMove();
end

return BattleController;