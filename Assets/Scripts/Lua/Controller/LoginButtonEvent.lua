local ScenesManager=require("ScenesManager");

local LoginButtonController ={};

local flag= 0;
local uiRoot=nil;
local password=nil;
local username=nil;
local button =nil;
local errorText =nil;



local initState =1;


function LoginButtonController.listenLogin(callback)

    if callback and initState then

        uiRoot =CS.UnityEngine.GameObject.Find("Canvas");
        button =uiRoot.transform:Find("logIn");
        username =uiRoot.transform:Find("username");
        password =uiRoot.transform:Find("password");
        errorText =uiRoot.transform:Find("errorText");
        errorText.transform.localScale=CS.UnityEngine.Vector3(0,0,0);

        assert(username,"didnt get username");
        assert(password,"didnt get password");
        assert(button,"dont get button");
        assert(errorText,"dont get errorText");

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
            else
                errorText.transform.localScale=CS.UnityEngine.Vector3(1,1,1);
            end

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



end



return LoginButtonController