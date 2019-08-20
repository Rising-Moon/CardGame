local ScenesManager=require("ScenesManager");
local RM=require("ResourcesManager");

--抽卡后使用
local CardList =require("CardList");
local CardListManager = require("CardListManager");

--获取一个c#脚本调用startCoroutine
--local myClass =UE.GameObject.Find("mainApp"):GetComponent("LuaBehaviour");

local PomkEventController ={};


PomkEventController.callback ={};
local callback =PomkEventController.callback;


local CardFlag =0;
local flag= 0;
local uiRoot=nil;

local backButton =nil;
local btn;

local pomkButton =nil;
local bun;

local initState =1;

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


--先将相关内容写在Pomk中，避免影响到cardcontroller
--只能处理单张card
local function getCard()
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

            -- 卡牌点击会消失
            if(moveUtil) then
                moveUtil:SmoothMoveBack(20,1);
                RM:dropResoureces(card);
                --卡牌消失后继续抽卡
                CardFlag =0;
            end
            card = nil;
            offset = nil;
            originPosition = nil;
            selectCard =nil;

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

function PomkEventController.listenEvent(callback)

    if callback and initState then

        uiRoot =CS.UnityEngine.GameObject.Find("Canvas");
        backButton =uiRoot.transform:Find("back");
        pomkButton =uiRoot.transform:Find("pomk");


        assert(backButton,"dont get button");


        btn = backButton:GetComponent("Button");
        bun = pomkButton:GetComponent("Button");
        btn.onClick:AddListener(function()
            --验证成功后为按钮设置防抖
                btn.interactable = false;
                flag =1;
        end);
        bun.onClick:AddListener(function ()
            bun.interactable =false;
            CardFlag =1;
            --num需要为卡牌的id，通过卡牌id来处理实例化
            local num=math.random(1,1);
            print("Card number is:"..num);
            RM:instantiatePath(CardPrefabsPathDir[num].ResourcesPath,CardPrefabsPathDir[num].name,uiRoot,CS.UnityEngine.Vector3(0,0,0));
            --cardListmananger???没有实例话出卡牌信息
            print(CardList.user_have[1]);
            --暂时先使用cardlistmanager的接口
            CardListManager:userGet(num);
        end);

        initState =callback.initListener(initState);

    end

    if flag ==1 then
        --button:GetComponent("Button").onClick:RemoveAllListeners();
        --先别使用协程
        --ScenesManager:AsyncLoadScene(1);
        ScenesManager:LoadScene(1);
        initState =1;
        flag=0;
    end
    if CardFlag ==1 then
        getCard();
    end
    if CardFlag ==0 then
        bun.interactable =true;
    end



end



return PomkEventController