--导包
local BagView =require("BagView");
local RM =require("ResourcesManager");
local SM =require("ScenesManager");
local AM =require("AudioManager");
local ProManager =require("ProManager");
local EventView =require("EventView");
local GateButtonEvent = {};

--按钮使用标志
local fightFlag=0;
local BagFlag =0;
local pomkFlag =0;
local quitFlag =0;

--ui组件
local uiRoot =nil;

local pomkButton =nil;
local closeButton =nil;
local bagButton =nil;

local moneyText =nil;
local levelText =nil;
local gateText =nil;

local cardBag =nil;

--三个需要响应的事件
local Event1 =nil;
local Event2 =nil;
local Event3 =nil;

local initState =1;

--获取消息队列
local message =CS.MessageQueueManager.GetMessageQueue();

local bigTimer =nil;

--回调函数，便于更新text
local function updateInfo(ifNum)
    if not ifNum then
        moneyText:GetComponent("Text").text =ProManager.Info["Money"];
        levelText:GetComponent("Text").text =ProManager.Level;
        return
    end

    fightFlag =1;

    --发送信息给战斗模块，告知当前难度
    --由当前难度来决定当前怪物血量等信息
    local msg = CS.Message(CS.Message.MessageType.Difficulty,tostring(ProManager.Info["Gate"]));
    message:SendMessage(msg);
end

--[[
local function testMessage1()
    local msg =CS.Message(CS.Message.MessageType.Difficulty,"hello");
    message:SendMessage(msg);
end

local function testMessage2()
    local msg =CS.Message(CS.Message.MessageType.Difficulty,"world");
    message:SendMessage(msg);
end
]]--
function GateButtonEvent.listenEvent(callback)

    if callback and initState then
        --testMessage1();
        --testMessage2();
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
        gateText =uiRoot.transform:Find("user/Gates");
        moneyText:GetComponent("Text").text =ProManager.Info["Money"];
        levelText:GetComponent("Text").text =ProManager.Level;
        gateText:GetComponent("Text").text =ProManager.Info["Gate"];


        --背包设置很简陋，根据现有的数据只存在六个背包 panel设置为grid
        --如果有后期会加入动态添加背包格子的
        BagView:createView(cardBag);

        Event1=uiRoot.transform:Find("Event1");
        assert(Event1,"dont get Message");
        Event2=uiRoot.transform:Find("Event2");
        assert(Event1,"dont get Message");
        Event3=uiRoot.transform:Find("Event3");
        assert(Event1,"dont get Message");

        --初始化三个事件
        EventView.createView("1",Event1,updateInfo);
        EventView.createView("2",Event2,updateInfo);
        EventView.createView("3",Event3,updateInfo);

        cardBag.transform.localScale=CS.UnityEngine.Vector3(0,0,0);

        --界面跳转
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

        --鼠标点击进行缩放背包
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
        initState =1;
        fightFlag =0;
        --RM:clear();
        SM:LoadScene(2);

        --
    end

     if pomkFlag ==1 then
         pomkButton:GetComponent("Button").onClick:RemoveAllListeners();
         --加载后将initState置回1，当下次重新加载入该场景后可以重现绑定事件
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