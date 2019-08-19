local ScenesManager=require("ScenesManager");

local LoginButtonController ={};

local flag= 0;
local uiRoot=nil;
local password=nil;
local username=nil;
local button =nil;
local errorText =nil;
local UI_Alpha =1;
local alphaSpeed =2;
local remUP =nil;

local canvasGroup;

local initState =1;

local UPTimer =nil;
local isON =nil;

function LoginButtonController.listenLogin(callback)

    if callback and initState then

        uiRoot =CS.UnityEngine.GameObject.Find("Canvas");
        button =uiRoot.transform:Find("logIn");
        assert(button,"dont get button");

        username =uiRoot.transform:Find("username");
        assert(username,"didnt get username");

        password =uiRoot.transform:Find("password");
        assert(password,"didnt get password");

        errorText =uiRoot.transform:Find("errorText");
        assert(errorText,"dont get errorText");

        errorText.transform.localScale=CS.UnityEngine.Vector3(0,0,0);

        canvasGroup =uiRoot:GetComponent("CanvasGroup");
        assert(canvasGroup,"dont get canvasGroup");

        remUP =uiRoot.transform:Find("remUP");
        assert(remUP,"dont get remUP");

        local btn =  button:GetComponent("Button");

        btn.onClick:AddListener(function()
            --验证成功后为按钮设置防抖
            local usernameText=nil;
            local passwordText=nil;
            usernameText =username:GetComponent("InputField").text;
            passwordText =password:GetComponent("InputField").text;
            if #usernameText > 0 and #passwordText >0  then
                btn.interactable = false;
                flag =1;
                errorText.transform.localScale=CS.UnityEngine.Vector3(0,0,0);
                isON =remUP.gameObject:GetComponent(typeof(CS.UnityEngine.UI.Toggle)).isOn;
                print(isON);
                if isON then
                    CS.UnityEngine.PlayerPrefs.SetString("username",usernameText);
                    CS.UnityEngine.PlayerPrefs.SetString("password",passwordText);
                end
            else
                errorText.transform.localScale=CS.UnityEngine.Vector3(1,1,1);
            end

        end);

        initState =callback.initListener(initState);
        --声明定时器
        UPTimer=CS.Timer(3);
        UPTimer:Start();
    end

    if flag ==1 then
        --button:GetComponent("Button").onClick:RemoveAllListeners();
        --先别使用协程
        --ScenesManager:AsyncLoadScene(1);
        ScenesManager:LoadScene(1);
        initState =1;
        flag=0;
    end

    if UI_Alpha ~=canvasGroup.alpha then
        canvasGroup.alpha =CS.UnityEngine.Mathf.Lerp(canvasGroup.alpha, UI_Alpha, alphaSpeed * CS.UnityEngine.Time.deltaTime);
        if CS.UnityEngine.Mathf.Abs(UI_Alpha - canvasGroup.alpha) <= 0.01 then
            canvasGroup.alpha = UI_Alpha;
        end
    end

    if UPTimer and UPTimer.IsTimeUp then
        UPTimer =nil;
        if CS.UnityEngine.PlayerPrefs:HasKey("username") then
            print("local username and password is on");
            username:GetComponent("InputField").text =CS.UnityEngine.PlayerPrefs.GetString("username","demo");
            password:GetComponent("InputField").text =CS.UnityEngine.PlayerPrefs.GetString("password","12345");

        end
    end


end



return LoginButtonController