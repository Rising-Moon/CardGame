local ScenesManager=require("ScenesManager");
local RM =require("ResourcesManager");
local AM =require("AudioManager");

--抽卡后使用
local CardList =require("CardList");
local CardListManager = require("CardListManager");
--初始化卡牌管理并从文件中获得卡牌信息
--没有在manager里面init，每次加载文件都要init？
CardListManager.init();

--[[
local cardTable =CardListManager.getUserHaveCards();
--返回的值和拥有的值之间有差别
--直接使用insert进行插入后会导致我理解的出错
for i,v in pairs(cardTable) do
    print("Card user have id is:"..i);
    print("Card id is:"..v);
end

for id,info in pairs(CardList.user_have) do
    print("Card user have id is:"..id);
end
]]--

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

        --点击卡牌
        if (CS.UnityEngine.Input.GetMouseButton(0)) then
            -- 卡牌点击会消失
            --RM:dropResoureces(card);
            RM:pushInPool("Assets/StreamingAssets/AssetBundles/Card.pre","Card",card);
            print("恭喜你获得卡牌");
            --卡牌消失后继续抽卡
            CardFlag =0;
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

        local music =RM:LoadPath("Assets/Resources/music/PomkMusic.mp3","PomkMusic");
        AM:PlayMusic(music);

        uiRoot =CS.UnityEngine.GameObject.Find("Canvas");
        backButton =uiRoot.transform:Find("back");
        pomkButton =uiRoot.transform:Find("pomk");

        assert(backButton,"dont get backButton");
        assert(pomkButton,"dont get pomkButton");

        btn = backButton:GetComponent("Button");
        bun = pomkButton:GetComponent("Button");
        btn.onClick:AddListener(function()
            --验证成功后为按钮设置防抖
                btn.interactable = false;
                flag =1;
        end);
        --这里也能用cardview来创建对象，但是采用来cardview后实际上是每次都实例化一次pre
        --每次抽卡实际上是重新实例化一个卡牌的预制体。因此性能非常差
        --将实例话的卡牌放入对象池中提高性能？
        bun.onClick:AddListener(function ()
            bun.interactable =false;
            CardFlag =1;
            --num需要为卡牌的id，通过卡牌id来处理实例化
            local num=math.random(1,4);
            print("Card number is:"..num);
            local newCard =RM:popPool("Assets/StreamingAssets/AssetBundles/Card.pre","Card");
            if not newCard then
                newCard =RM:instantiatePath("Assets/StreamingAssets/AssetBundles/Card.pre","Card",uiRoot,CS.UnityEngine.Vector3(0,0,0));
            end
            newCard.transform.localScale =CS.UnityEngine.Vector3(1,1,1);
             --local cardName =newCard.transform:Find("name_back").gameObject.transform:Find("Name");
            local cardName =newCard.transform:Find("name_back/Name");
            local cardImage =newCard.transform:Find("Image/Image_back");
            local cardCost =newCard.transform:Find("cost_back/cost/costValue");
            local cardContent =newCard.transform:Find("Content/Text");
            cardName:GetComponent("Text").text =cardInfo[num].name;
            local pic =RM:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic",cardInfo[num].img);;
            --print(cardImage:GetComponent("Image").sprite);
            --由于预制体的设置，如果不设置color这里会出现全黑的情况
            cardImage:GetComponent("Image").sprite =pic;
            --print(cardImage:GetComponent("Image").color);
            cardImage:GetComponent("Image").color =CS.UnityEngine.Color(1,1,1);
            cardCost:GetComponent("TextMeshProUGUI").text =cardInfo[num].cost;
            cardContent:GetComponent("Text").text=cardInfo[num].introduction;

            print("是否未拥有卡牌："..num);
            print(type(CardList.not_obtain[num]) =="table");
            --[[
            for i,v in pairs(CardList.not_obtain[num]) do
                print(i);
                print(v);
            end
            ]]--
            --暂时先使用cardlistmanager的接口
            --这里获取任何card都会返回卡牌存在或已经销毁？？？
            --userGet 通过name来判断not-obtain是否有卡的存在，但是打印出来实际上没看到name属性？nil~=""值为真
            --此时卡牌拥有
            CardListManager:userGet(num);
            --卡牌在数据文件中不存在，所以卡牌会一直显示未拥有
            --每次获取卡牌后，保存最新消息
            --此时卡牌未拥有
            --无论什么时候都会返回卡牌不存在或者已经获得，使用方法不对？

            --CardListManager:saveCards();
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