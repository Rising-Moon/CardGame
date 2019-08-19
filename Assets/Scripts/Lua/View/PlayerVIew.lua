--导包
local resourcesManager = require('ResourcesManager');
local uiUtil = require('UIUtil');

PlayerView = {};

function PlayerView:createView(player, parent)
    -- 实例化的界面
    local view = nil;
    view = resourcesManager:instantiatePath("Assets/StreamingAssets/AssetBundles/playerInfo.pre", "PlayerInfos", parent);
    -- 获取UI上的主要元素
    local uiMap = uiUtil.genAllChildNameMap(view);
    -- 角色名
    local playerName = uiMap["Player.PlayerInfo.Name"];
    -- 生命值条
    local lifeRect = uiMap["StateBar.Health"];
    -- 生命值文字
    local lifeText = uiMap["StateBar.Health.Value"];
    -- 法力值条
    local manaRect = uiMap["StateBar.Mana"];
    -- 法力值文字
    local manaText = uiMap["StateBar.Mana.Value"];
    -- 防御值
    local def = uiMap["StateBar.Def.Value"];
    -- 经验值条
    local experienceRect = uiMap["Player.PlayerInfo.Exp"];

    -- 敌人view更新
    local update = function()
        print("玩家信息更新");
        --更新卡牌信息
        view.name = "Player";
        playerName:GetComponent("Text").text = player.name;
        lifeRect:GetComponent("Slider").value = player.life / player.maxLife;
        lifeText:GetComponent("Text").text = player.life .. "/" .. player.maxLife;
        manaRect:GetComponent("Slider").value = player.mana / player.maxMana;
        manaText:GetComponent("Text").text = player.mana .. "/" .. player.maxMana;
        experienceRect:GetComponent("Image").fillAmount = player.experience/player.maxExperience;
        def:GetComponent("Text").text = player.attributeList.def;
    end

    -- 先进行一次update对view进行初始化
    update();

    -- 添加update为card的监听者
    player:addListener(view:GetHashCode(), update);

    return view;
end

function PlayerView:destroy(player, view)
    player:removeListener(view:GetHashCode());
    CS.UnityEngine.GameObject.Destroy(view);
end

return PlayerView;