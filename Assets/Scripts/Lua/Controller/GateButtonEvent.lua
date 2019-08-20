local util = require 'xlua.util';
local RM =require("ResourcesManager");
local SM =require("ScenesManager");
--对背包使用
local CardList =require("CardList");
local CardListManager = require("CardListManager");

local cardtable =CardListManager.getUserHaveCards();

--CardListManager在其他地方无法初始化？？？
for i,v in pairs(cardtable) do
    print(i);
    print(v);
end

--获取一个c#脚本调用
local myClass =CS.UnityEngine.GameObject.Find("mainApp"):GetComponent("LuaBehaviour");

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

local bigTimer =nil;

local function imgOnClick(gameObject)
    local Show_Fuc = util.cs_generator(function()
        gameObject.transform.localScale=CS.UnityEngine.Vector3(1.5,1.5,1.5);

        print(gameObject:GetComponent("Image").sprite);
        --暂时不能同时点开两个，点开两个后存在错误
        SM:createDes(gameObject:GetComponent("Image").sprite,gameObject.name,"this is card");

        coroutine.yield(CS.UnityEngine.WaitForSeconds(1));
        gameObject.transform.localScale=CS.UnityEngine.Vector3(1,1,1);
    end);
    myClass:StartCoroutine(Show_Fuc);



end


function GateButtonEvent.listenEvent(callback)

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

        --背包设置很简陋，只存在六个背包 panel设置为grid
        --如果有后期会加入动态添加背包格子的
        --[[ local i =0;
         --卡牌没有成功读取
         print(CardList.user_have[1]);
         for id,info in pairs(CardList.user_have) do
             print(id);
             print(info);
             local img =cardBag.transform:GetChild(i);
             assert(img,"dont get image");
             i=i+1;
             if img then
                 print("get img");
                 local pic =RM:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic",CardImageDir[i+1].name);
                 img:GetComponent("Image").sprite =pic;
                 CS.UGUIEventListener.Get(img.gameObject).onClick =imgOnClick;
             else
                 --超出限制之后退出，后期可能加上动态增加格子
                 break
             end
     end]]--


         for i=0,cardBag.transform.childCount-1,1 do
             local img =cardBag.transform:GetChild(i);
             --点击背包的图片后，打印ui组件名字
             --这里加载的应该是持有卡牌的贴图
             print("set a new img");
             local pic =RM:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic",CardImageDir[i+1].name);
             img:GetComponent("Image").sprite =pic;
             CS.UGUIEventListener.Get(img.gameObject).onClick =imgOnClick;
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
    --执行完upadte的代码后才会刷新
    if fightFlag ==1 then
        fightButton:GetComponent("Button").onClick:RemoveAllListeners();
        initState =1;
        fightFlag =0;
        --RM:clear();
        SM:LoadScene(2);
        --加载后将initState置回1，当下次重新加载入该场景后可以重现绑定事件
        --

    end

    if pomkFlag ==1 then
        pomkButton:GetComponent("Button").onClick:RemoveAllListeners();
        initState =1;
        --print("the new initstate is "..initState);
        pomkFlag =0;
        --异步加载后initstate将变为0？
        --在bag中由于将对象放在对象池后，当场景发生切换后,需要对对象池的引用进行清除
        RM:clear();
        SM:LoadScene(2);


    end

    if quitFlag ==1  then
        closeButton:GetComponent("Button").onClick:RemoveAllListeners();
        initState =1;
        quitFlag =0;
        --application 在 调试时无法显示效果
        SM:QuitGame();
    end


end

return GateButtonEvent