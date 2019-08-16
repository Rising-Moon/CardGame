local ScenesManager=require("ScenesManager");
local RM=require("ResourcesManager");
local PomkEventController ={};

local flag= 0;
local uiRoot=nil;

local backButton =nil;
local pomkButton =nil;

local initState =1;


function PomkEventController.listenEvent(callback)

    if callback and initState then

        uiRoot =CS.UnityEngine.GameObject.Find("Canvas");
        backButton =uiRoot.transform:Find("back");
        pomkButton =uiRoot.transform:Find("pomk");


        assert(backButton,"dont get button");


        local btn = backButton:GetComponent("Button");
        local bun = pomkButton:GetComponent("Button");
        btn.onClick:AddListener(function()
            --验证成功后为按钮设置防抖
                btn.interactable = false;
                flag =1;
        end);
        bun.onClick:AddListener(function ()
            bun.interactable =false;
            RM:instantiatePath("Assets/StreamingAssets/AssetBundles/Card.pre","Card",uiRoot,CS.UnityEngine.Vector3(0,0,0));        end);
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



end



return PomkEventController