------------这里的逻辑不用看，还不完整---------------

local SM =require("ScenesManager");

local GateButtonEvent = {};

local fightFlag =0;
local BagFlag =0;
local pomkFlag =0;
local quitFlag =0;

local uiRoot =nil;
local fightButton =nil;
local pomkButton =nil;
local closeButton =nil;
local bagButton =nil;

local cardBag =nil;
local cardIma =nil

local initState =1;

local function imgOnClick(gameObject)
    print(gameObject.name);
end

local function imgPointEnter(gameObject)
    gameObject.transform.localScale=CS.UnityEngine.Vector3(1.5,1.5,1.5);
end

function GateButtonEvent.listenEvent(callback)
    --print(SM:GetIndex());
    if callback and initState then
        --静态函数
        uiRoot =CS.UnityEngine.GameObject.Find("Canvas");
        assert(uiRoot,"didnt get canvas");

        fightButton =uiRoot.transform:Find("fight");
        assert(fightButton,"didnt get fightButton");

        pomkButton =uiRoot.transform:Find("pomk");
        assert(pomkButton,"didnt get pomkingButton");

        closeButton =uiRoot.transform:Find("quit");
        assert(closeButton,"didnt get closeButton");

        bagButton =uiRoot.transform:Find("bag");
        assert(bagButton,"dont get bagButton");

        cardBag =CS.UnityEngine.GameObject.Find("Canvas/CardBag");
        --cardBag =uiRoot.transform:Find("CardBag");
        assert(cardBag,"dont get card bag");


        for i=0,cardBag.transform.childCount-1,1 do
            local img =cardBag.transform:GetChild(i);
            --点击背包的图片后，打印ui组件名字
            CS.UGUIEventListener.Get(img.gameObject).onClick =imgOnClick;
            --CS.UGUIEventListener.Get(img.gameObject).PointEnter =imgPointEnter;
            --CS.UGUIEventListener.Get(img.gameObject).OnMouseEnter =imgPointEnter;
        end

        cardBag.transform.localScale=CS.UnityEngine.Vector3(0,0,0);

        fightButton:GetComponent("Button").onClick:AddListener(function()
        fightFlag =1;
        local btn =  fightButton:GetComponent("Button");
        btn.interactable = false;
        end);

        pomkButton:GetComponent("Button").onClick:AddListener(function()
        pomkFlag =1;
        local btn =  pomkButton:GetComponent("Button");
        btn.interactable = false;
        end);

        closeButton:GetComponent("Button").onClick:AddListener(function()
    quitFlag =1;
    local btn =  closeButton:GetComponent("Button");
    btn.interactable = false;
    end);

    bagButton:GetComponent("Button").onClick:AddListener(function ()
    if BagFlag ==0 then
    cardBag.transform.localScale=CS.UnityEngine.Vector3(1,1,1);
    BagFlag =1;
    return
    end
    if BagFlag ==1 then
    cardBag.transform.localScale=CS.UnityEngine.Vector3(0,0,0);
    BagFlag =0;
    return
    end

    end);
    initState =callback.initListener(initState);
        end

    if fightFlag ==1 then
        fightButton:GetComponent("Button").onClick:RemoveAllListeners();
        SM:LoadScene(2);
        --加载后将initState置回1，当下次重新加载入该场景后可以重现绑定事件
        --fightFlag =0;
        initState =1;
    end

    if pomkFlag ==1 then
        pomkButton:GetComponent("Button").onClick:RemoveAllListeners();
        SM:LoadScene(3);
        initState =1;
        pomkFlag =0;

    end

    if quitFlag ==1  then
        closeButton:GetComponent("Button").onClick:RemoveAllListeners();
        --application 在 调试时无法显示效果
        SM:QuitGame();
        initState =1;
        quitFlag =0;
    end


end

return GateButtonEvent