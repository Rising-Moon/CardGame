--导包
local resourcesManager = require('ResourcesManager');
local uiUtil = require('UIUtil');
local Buff = require("Buff");
local BuffView = require("BuffView");
local DataProxy = require("DataProxy");

PlayerView = {};

function PlayerView:createView(player, parent, clickEvents)
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
    -- buff栏
    local buffs = uiMap["Buff/Debuff"];
    -- 经验值条
    local experienceRect = uiMap["Player.PlayerInfo.Exp"];
    -- 下回合按钮
    local nextTurn = uiMap["NextTurn"];
    nextTurn:GetComponent("Button").onClick:AddListener(clickEvents.nextTurnfunc);

    -- buff列表
    local buffViewList = {};

    -- 敌人view更新
    local update = function()
        print("玩家信息更新");
        --更新卡牌信息
        view.name = "Player";
        playerName:GetComponent("Text").text = player.name;
        lifeRect:GetComponent("Slider").value = player.life / player.maxLife;
        lifeText:GetComponent("Text").text = math.floor(player.life) .. "/" .. math.floor(player.maxLife);
        manaRect:GetComponent("Slider").value = player.mana / player.maxMana;
        manaText:GetComponent("Text").text = math.floor(player.mana) .. "/" .. math.floor(player.maxMana);
        experienceRect:GetComponent("Image").fillAmount = player.experience / player.maxExperience;

        -- 更新buff栏
        for k, v in pairs(player.attributeList) do
            if (not v or v == 0) then
                if (buffViewList[k]) then
                    BuffView:destroy(buffViewList[k].object, buffViewList[k].view);
                    buffViewList[k].object.value = 0;
                    buffViewList[k] = nil;
                end
            else
                v = math.floor(v);
                if (not buffViewList[k]) then
                    local buff = Buff:newBuff(k);
                    if (buff) then
                        local buf = DataProxy.createProxy(buff, {});
                        buffViewList[k] = { object = buf, view = BuffView:createView(buf, buffs) };
                        buffViewList[k].object.value = v;
                    end
                else
                    buffViewList[k].object.value = v;
                end
            end
        end
    end

    -- 先进行一次update对view进行初始化
    update();

    -- 添加update为card的监听者
    player:addListener(view:GetHashCode(), update);
    --player.attributeList:addListener(view:GetHashCode(), update);

    return view;
end

function PlayerView:destroy(player, view)
    player:removeListener(view:GetHashCode());
    CS.UnityEngine.GameObject.Destroy(view);
end

return PlayerView;