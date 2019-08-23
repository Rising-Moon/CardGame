local BagView =require("BagView");
local RM =require("ResourcesManager");
local SM =require("ScenesManager");
local AM =require("AudioManager");
local ProManager =require("ProManager");
local EventView =require("EventView");
local GateButtonEvent = {};


local BagFlag =0;
local pomkFlag =0;
local quitFlag =0;

local uiRoot =nil;

local pomkButton =nil;
local closeButton =nil;
local bagButton =nil;

local moneyText =nil;
local levelText =nil;

local cardBag =nil;

local Event1 =nil;
local Event2 =nil;
local Event3 =nil;

local initState =1;

local bigTimer =nil;

local function updateInfo(ifNum)
    if not ifNum then
        moneyText:GetComponent("Text").text =ProManager.Info["Money"];
        levelText:GetComponent("Text").text =ProManager.Level;
        return
    end

    initState =1;
    print("now the new init is \t"..initState);

end




function GateButtonEvent.listenEvent(callback)

    if callback and initState then

        local music =RM:LoadPath("Assets/Resources/music/backGroundMusic.mp3","backGroundMusic");
        AM:PlayMusic(music);
        --静态函数
        uiRoot =CS.UnityEngine.GameObject.Find("Canvas");
        assert(uiRoot,"didnt get canvas");



        pomkButton =uiRoot.transform:Find("pomk");
        assert(pomkButton,"didnt get pomkingButton");

        closeButton =uiRoot.transform:Find("quit");
        assert(closeButton,"didnt get closeButton");

        bagButton =uiRoot.transform:Find("bag");
        assert(bagButton,"dont get bagButton");

        cardBag =CS.UnityEngine.GameObject.Find("Canvas/CardBag");
        --cardBag =uiRoot.transform:Find("CardBag");
        assert(cardBag,"dont get card bag");

        --每次GETComponet都在消耗性能
        moneyText =uiRoot.transform:Find("user/money");
        levelText =uiRoot.transform:Find("user/level");
        moneyText:GetComponent("Text").text =ProManager.Info["Money"];
        levelText:GetComponent("Text").text =ProManager.Level;


        --背包设置很简陋，根据现有的数据只存在六个背包 panel设置为grid
        --如果有后期会加入动态添加背包格子的
        BagView:createView(cardBag);

        Event1=uiRoot.transform:Find("Event1");
        assert(Event1,"dont get Message");
        Event2=uiRoot.transform:Find("Event2");
        assert(Event1,"dont get Message");
        Event3=uiRoot.transform:Find("Event3");
        assert(Event1,"dont get Message");
        EventView.createView("1",Event1,updateInfo);
        EventView.createView("2",Event2,updateInfo);
        EventView.createView("3",Event3,updateInfo);
         cardBag.transform.localScale=CS.UnityEngine.Vector3(0,0,0);


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
    print("when you back ");
    print(initState);

 end

 return GateButtonEvent