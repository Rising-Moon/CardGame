------------这里的逻辑不用看，还不完整---------------

local SM =require("ScenesManager");

local GateButtonEvent = {};

local fightFlag =0;
local pomkFlag =0;
local quitFlag =0;
local uiRoot =nil;
local fightButton =nil;
local pomkButton =nil;
local closeButton =nil;
local initState =1;
local AsyIsDone =1;

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


        fightButton:GetComponent("Button").onClick:AddListener(function()
            fightFlag =1;
            print(fightFlag);
        end);

        pomkButton:GetComponent("Button").onClick:AddListener(function()
            pomkFlag =1;
        end);
        closeButton:GetComponent("Button").onClick:AddListener(function()
            quitFlag =1;
        end);
        initState =callback.initListener(initState);
    end

    if fightFlag ==1 and AsyIsDone then
        fightButton:GetComponent("Button").onClick:RemoveAllListeners();
        AsyIsDone =nil;
        SM:LoadScene(2);
        --加载后将initState置回1，当下次重新加载入该场景后可以重现绑定事件
        fightFlag =0;
        initState =1;
    end

    if pomkFlag ==1 and AsyIsDone then
        pomkButton:GetComponent("Button").onClick:RemoveAllListeners();
        AsyIsDone =nil;
        SM:LoadScene(3);
        initState =1;
        pomkFlag =0;

    end

    if quitFlag ==1 and AsyIsDone then
        closeButton:GetComponent("Button").onClick:RemoveAllListeners();
        AsyIsDone =nil;
        --application 在 调试时无法显示效果
        SM:QuitGame();
        initState =1;
        quitFlag =0;
    end


end

return GateButtonEvent