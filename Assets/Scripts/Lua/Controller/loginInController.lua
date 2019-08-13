local ScenesManager=require("ScenesManager");
local loginInController = {};

local flag= 0;
local uiRoot=nil;
local password=nil;
local username=nil;
local button =nil;
local errorText =nil;

-- 初始化
function loginInController:init()

end

function loginInController.start()
    --根据只绑定一个mainapp.lua的object，这种加载应该只能写一次
    uiRoot =ScenesManager:initRoot();
    button =uiRoot.transform:Find("logIn");
    username =uiRoot.transform:Find("username");
    password =uiRoot.transform:Find("password");
    errorText =uiRoot.transform:Find("errorText");
    errorText.transform.localScale=CS.UnityEngine.Vector3(0,0,0);

    assert(username,"didnt get username");
    assert(password,"didnt get password");
    assert(button,"dont get button");
    assert(errorText,"dont get errorText");

    button:GetComponent("Button").onClick:AddListener(function()
        if #username:GetComponent("InputField").text > 0 and #password:GetComponent("InputField").text >0  then
            flag =1;
            print("flag has index");
            errorText.transform.localScale=CS.UnityEngine.Vector3(0,0,0);
        else
            errorText.transform.localScale=CS.UnityEngine.Vector3(1,1,1);
        end

    end);
end

function loginInController.update()

    if flag ==1 then
        print("flag has run");
        button:GetComponent("Button").onClick:RemoveAllListeners();
        ScenesManager:AsyncLoadScene(1);
        flag=0;
    end
end

return loginInController