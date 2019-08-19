--导包
local resourcesManager = require('ResourcesManager');
local uiUtil = require('UIUtil');

EnemyView = {};

function EnemyView:createView(enemy, parent, name)
    -- 实例化出来的敌人gameobject
    local view = nil;
    view = resourcesManager:instantiatePath("Assets/StreamingAssets/AssetBundles/enemy.pre", name, parent);
    -- 获取敌人UI上的主要元素
    local uiMap = uiUtil.genAllChildNameMap(view);
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

    -- 敌人view更新
    local update = function()
        print("怪物信息更新");
        --更新卡牌信息
        view.name = enemy.name;
        lifeRect:GetComponent("Slider").value = enemy.life / enemy.maxLife;
        lifeText:GetComponent("Text").text = enemy.life .. "/" .. enemy.maxLife;
        manaRect:GetComponent("Slider").value = enemy.mana / enemy.maxMana;
        manaText:GetComponent("Text").text = enemy.mana .. "/" .. enemy.maxMana;
        def:GetComponent("Text").text = enemy.attributeList.def;
    end

    -- 先进行一次update对view进行初始化
    update();

    -- 添加update为card的监听者
    enemy:addListener(view:GetHashCode(), update);

    return view;
end

function EnemyView:destroy(enemy, view)
    enemy:removeListener(view:GetHashCode());
    CS.UnityEngine.GameObject.Destroy(view);
end

return EnemyView;