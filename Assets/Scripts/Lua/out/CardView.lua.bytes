--导包
local resourcesManager = require('ResourcesManager');
local uiUtil = require('UIUtil');

CardView = {}

function CardView:createView(card, parent)
    -- 实例化出来的卡牌gameobject
    local view = nil;
    view = resourcesManager:instantiatePath("Assets/StreamingAssets/AssetBundles/card.pre", "Card", parent);
    view.transform.localScale = view.transform.localScale * 0.73;
    -- 获取卡牌UI上的一些主要元素
    local uiMap = uiUtil.genAllChildNameMap(view);
    -- 卡牌图片
    local cardImage = uiMap["Image"];
    -- 卡牌名字
    local cardName = uiMap["name_back.Name"];
    -- 卡牌消耗
    local cardCost = uiMap["cost_back.cost.costValue"];
    -- 卡牌介绍
    local cardIntroduction = uiMap["Content.Text"];

    -- 卡牌view更新
    local update = function()
        --加载卡牌指向的图片
        local cardTexture = nil;
        if (view.img ~= "img") then
            cardTexture = resourcesManager:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic", card.img);
            print("load img:" .. cardTexture:ToString());
        end

        print("卡牌信息更新");
        --更新卡牌信息
        view.name = card.name;
        cardName:GetComponent("Text").text = card.name;
        cardCost:GetComponent("TextMeshProUGUI").text = card.cost;
        cardIntroduction:GetComponent("Text").text = card.introduction;
        cardImage:GetComponent("Image").sprite = cardTexture;
    end

    -- 先进行一次update对view进行初始化
    update();

    -- 添加update为card的监听者
    card:addListener(view:GetHashCode(), update);

    return view;
end

function CardView:destroy(card, view)
    card:removeListener(view:GetHashCode());
    CS.UnityEngine.GameObject.Destroy(view);
end

return CardView;