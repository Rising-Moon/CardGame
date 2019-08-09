CardController = {};
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
--卡牌移动方法d
function CardController.CardMove(callback)
    --鼠标所在位置
    local mousePosition = CS.UnityEngine.Camera.main:ScreenToWorldPoint(CS.UnityEngine.Input.mousePosition);
    if (card) then
        --已选中卡牌跟随鼠标
        if (CS.UnityEngine.Input.GetMouseButton(0)) then
            if(moveUtil)then
                moveUtil:SmoothMove(mousePosition + offset,50);
            end
        end
        --放开卡牌
        if (CS.UnityEngine.Input.GetMouseButtonUp(0)) then
            local threshold = CS.UnityEngine.Screen.height/5*2;
            local cardScreenPoint = CS.UnityEngine.Camera.main:WorldToScreenPoint(card.transform.position);
            -- 如果卡牌拖动位置高于屏幕2/5的高度，则判定使用了卡牌
            if(cardScreenPoint.y > threshold)then
                if(callback.UseCard) then
                    callback.UseCard(card.name);
                end
            end
            -- 卡牌移动会原位
            if(moveUtil) then
                moveUtil:SmoothMoveBack(20,1);
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
            if (hitObject) then
                originSize = hitObject.transform.localScale;
                originSibling = hitObject.transform:GetSiblingIndex();
                selectCard = hitObject;
                selectCard.transform.localScale = originSize * 1.5;
                selectCard.transform:SetAsLastSibling();
            else
                originSize = nil;
                originSibling = nil;
                selectCard = nil;
            end
        end
        --抓住卡牌
        if (CS.UnityEngine.Input.GetMouseButtonDown(0)) then
            if (hitObject ~= nil and hitObject.tag == 'Card') then
                card = hitObject;
                offset = hitObject.transform.position - mousePosition;
                originPosition = hitObject.transform.position;
                moveUtil = card:GetComponent("MoveUtil");
            end
        end
    end
end

return CardController;