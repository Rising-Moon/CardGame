--导包
local resourcesManager = require('ResourcesManager');
local uiUtil = require('UIUtil');

local BuffView = {};

function BuffView:createView(buff,parent)
    -- 实例化界面
    local view = nil;
    view = resourcesManager:instantiatePath("Assets/StreamingAssets/AssetBundles/buff.pre", "Buff", parent);
    -- 获取UI上的主要元素
    local uiMap = uiUtil.genAllChildNameMap(view);
    -- buff图标
    local icon = uiMap["Icon"]:GetComponent("Image");
    -- buff数值
    local value = uiMap["Value"]:GetComponent("Text");

    -- buff view更新
    local update = function()
        --加载buff指向的图片
        local buffIcon = nil;
        if (buff.name) then
            buffIcon = resourcesManager:LoadPath("Assets/StreamingAssets/AssetBundles/bufficon.pic", buff.IconName);
            print("load img:" .. buffIcon:ToString());
        end

        print("Buff信息更新");

        view.name = buff.name;
        icon.sprite = buffIcon;
        value.text = buff.value;
    end

    -- 先进行一次update对view进行初始化
    update();

    -- 添加update为card的监听者
    buff:addListener(view:GetHashCode(), update);

    return view;

end

function BuffView:destroy(buff, view)
    buff:removeListener(view:GetHashCode());
    CS.UnityEngine.GameObject.Destroy(view);
end

return BuffView;