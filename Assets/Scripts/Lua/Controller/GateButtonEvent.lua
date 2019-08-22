local BagView =require("BagView");
local RM =require("ResourcesManager");
local SM =require("ScenesManager");
local AM =require("AudioManager");
local ProManager =require("ProManager");

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

local moneyText =nil;
local levelText =nil;

local cardBag =nil;
local cardIma =nil

local initState =1;

local bigTimer =nil;




function GateButtonEvent.listenEvent(callback)

    if callback and initState then

        local music =RM:LoadPath("Assets/Resources/music/backGroundMusic.mp3","backGroundMusic");
        AM:PlayMusic(music);
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

        --每次GETComponet都在消耗性能
        moneyText =uiRoot.transform:Find("user/money");
        levelText =uiRoot.transform:Find("user/level");
        moneyText:GetComponent("Text").text =ProManager.Info["Money"];
        levelText:GetComponent("Text").text =ProManager.Level;


        --背包设置很简陋，根据现有的数据只存在六个背包 panel设置为grid
        --如果有后期会加入动态添加背包格子的
        BagView:createView(cardBag);

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