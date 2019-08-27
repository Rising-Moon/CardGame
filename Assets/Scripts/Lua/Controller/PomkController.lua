local ScenesManager=require("ScenesManager");
local RM =require("ResourcesManager");
local AM =require("AudioManager");
local UIUtil =require("UIUtil");
local MBM =require("MessageBoxManager");

--抽卡后使用
local CardList =require("CardList");
local CardListManager=require("CardListManager");
local ProManager =require("ProManager");

--切换场景后的控制器
--互相调用了
--local GatesController =require("GatesController");

PomkController ={};

local CardFlag =0;
local flag= 0;

--组件
local uiRoot=nil;

local backButton =nil;
local btn;

local pomkButton =nil;
local bun;

local temp =nil;

local moneyNum =nil;
local FragNum =nil;

local effictMusic =nil;

--------------------------------
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
------------------------------------------
---
local function multiFlag()
    CardFlag =0;
end



-- 回调函数表
PomkController.Callback = {};
local callback = PomkController.Callback;




function PomkController.init()
    effictMusic=RM:LoadPath("Assets/Resources/music/Pomk.mp3","pomk");
    --[[
    if temp then
        print("hello world");
    end
    ]]--
    local music =RM:LoadPath("Assets/Resources/music/PomkMusic.mp3","PomkMusic");
    AM:PlayMusic(music);

    uiRoot =CS.UnityEngine.GameObject.Find("Canvas");
    local moneyBox =uiRoot.transform:Find("Money");
    moneyBox.transform.localScale=CS.UnityEngine.Vector3(1,1,1);

    backButton =uiRoot.transform:Find("back");
    assert(backButton,"dont get backButton");
    pomkButton =uiRoot.transform:Find("pomk");
    assert(pomkButton,"dont get pomkButton");
    moneyNum =uiRoot.transform:Find("Money/moneyNum");
    assert(moneyNum,"dont get moneyNum");

    FragNum =uiRoot.transform:Find("Money/FragNum");
    assert(FragNum,"dont get FragNum");


    --每次GETComponet都在消耗性能
    moneyNum:GetComponent("Text").text =ProManager.Info["Money"];
    FragNum:GetComponent("Text").text =ProManager.Info["Frag"];

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
        print("the money you now have is:"..ProManager.Info["Money"]);
        local boolUse =ProManager.useMoney(10);
        if boolUse then
            bun.interactable =false;

            CardFlag =1;
            --num需要为卡牌的id，通过卡牌id来处理实例化
            local num=math.random(1,6);
            print("Card number is:"..num);
            local newCard =RM:popPool("Assets/StreamingAssets/AssetBundles/Card.pre","Card");
            if not newCard then
                newCard =RM:instantiatePath("Assets/StreamingAssets/AssetBundles/Card.pre","Card",uiRoot,CS.UnityEngine.Vector3(0,0,0));
            end
            newCard.transform.localScale =CS.UnityEngine.Vector3(1,1,1);
            local cardMap =UIUtil.genAllChildNameMap(newCard);
            local cardName =cardMap["name_back.Name"];
            cardName:GetComponent("Text").text =cardInfo[num].name;

            local cardImage =cardMap["Image.Image_back"];
            cardImage:GetComponent("Image").color =CS.UnityEngine.Color(1,1,1);
            cardImage:GetComponent("Image").sprite =RM:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic",cardInfo[num].img);

            local cardCost =cardMap["cost_back.cost.costValue"];
            cardCost:GetComponent("TextMeshProUGUI").text =cardInfo[num].cost;

            local cardContent =cardMap["Content.Text"];
            cardContent:GetComponent("Text").text=cardInfo[num].introduction;
            --[[
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
            ]]--

            --最初调用方法出错，暂时先使用cardlistmanager的接口
            local boolGet =CardListManager.userGet(num);
            --更新
            moneyNum:GetComponent("Text").text =ProManager.Info["Money"];
            print("是否未拥有卡牌："..num);
            print(boolGet);
            if boolGet then
                --保存卡牌
                CardListManager.saveCards();
                --保存金币信息

                AM:PlayEffectMusic(effictMusic);
            else
                ProManager.getFrag(10);
                FragNum:GetComponent("Text").text =ProManager.Info["Frag"];
                RM:pushInPool("Assets/StreamingAssets/AssetBundles/Card.pre","Card",newCard);
                MBM.CreateMessage("卡牌重复获得，获得基础碎片",multiFlag);

            end
            ProManager.saveInfo();
            --print("the money you now have is:"..ProManager.Info["Money"]);
        else
            MBM.CreateMessage("金币不够，请前往充值");
            print("金币不够，请前往充值");

        end

    end);
end

function PomkController.start()

end

function PomkController.update()
    if flag ==1 then
        ScenesManager:LoadScene(1);
        switchController(GatesController);
        flag=0;
    end
    if CardFlag ==1 then
        getCard();
    end
    if CardFlag ==0 and bun then
        bun.interactable =true;
    end
end

return PomkController