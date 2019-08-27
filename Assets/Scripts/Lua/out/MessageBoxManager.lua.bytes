local RM =require("ResourcesManager");
local ScenesManager =require("ScenesManager");

local MessageBoxManager ={};



--可以用对象池复用
--该消息框为一个图片，两个按钮
function MessageBoxManager.createDes(sprite,name,descri,callback)
    print("From SceneManager the name is:");
    print(name);
    local info =RM:popPool("Assets/Resources/Prefabs/informa.prefab","informa"..name);
    if not info then
        --ab打包的时候新出问题，先用resources加载测试
        info =RM:instantiatePath("Assets/Resources/Prefabs/informa.prefab","informa",ScenesManager:initRoot(),CS.UnityEngine.Vector3(0,0,0));
    end
    info.transform.localScale=CS.UnityEngine.Vector3(2,2,2);
    info.transform:Find("Image"):GetComponent(typeof(CS.UnityEngine.UI.Image)).sprite =sprite;
    --设置预制体的时候text较小，使用后就尽量为一行描述
    info.transform:Find("info"):GetComponent("Text").text =name.."\t"..descri;
    info.transform:Find("close"):GetComponent("Button").onClick:AddListener(function ()
        RM:pushInPool("Assets/Resources/Prefabs/informa.prefab","informa"..name,info);
    end);
    if not callback then
        info.transform:Find("update"):GetComponent("Button").interactable =false;
    end
    info.transform:Find("update"):GetComponent("Button").onClick:AddListener(function()
        callback();
    end);

end

--该消息框为一个text文本及一个按钮
function MessageBoxManager.CreateMessage(message,callback)
    local info =RM:popPool("Assets/Resources/Prefabs/textInfo.prefab","message");
    if not info then
        info =RM:instantiatePath("Assets/Resources/Prefabs/textInfo.prefab","message",ScenesManager:initRoot(),CS.UnityEngine.Vector3(0,0,0));
    end
    info.transform:Find("Text"):GetComponent("Text").text =message;
    info.transform:Find("Button"):GetComponent("Button").onClick:AddListener(function ()
        RM:pushInPool("Assets/Resources/Prefabs/textInfo.prefab","message",info);
        if callback then
            callback();
        end
    end);
end


return MessageBoxManager