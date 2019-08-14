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
        print(button);

        button:GetComponent("Button").onClick:AddListener(function()
            if #username:GetComponent("InputField").text > 0 and #password:GetComponent("InputField").text >0  then
                flag =1;
                errorText.transform.localScale=CS.UnityEngine.Vector3(0,0,0);
            else
                errorText.transform.localScale=CS.UnityEngine.Vector3(1,1,1);
            end

        end);

        initState =callback.initListener(initState);
    end

    if flag ==1 then
        button:GetComponent("Button").onClick:RemoveAllListeners();
        --先别使用协程，不能保证在一枕之内加载完成
        --ScenesManager:AsyncLoadScene(1);
        ScenesManager:LoadScene(1);
        initState =1;
        flag=0;
    end

end



return LoginButtonController