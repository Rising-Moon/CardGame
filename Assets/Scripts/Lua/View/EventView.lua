--导包
local util = require 'xlua.util';
local RM = require('ResourcesManager');
local ProManager= require("ProManager");
local ScenesManager =require("ScenesManager");
local uiUtil = require('UIUtil');
local SM =require("ScenesManager");

local EventView ={};


function EventView.createView(Event,parent,callBack)
    print("now new a new Event".."\t"..Event);
    local view =RM:instantiatePath("Assets/Resources/Prefabs/EventInfo.prefab","EventInfo",parent,parent.transform.position);
    --调整大小
    view.transform.localScale=CS.UnityEngine.Vector3(0.6,0.6,0.6);

    local EventDes =view.transform:Find("EventDes");
    local EventText =view.transform:Find("choose/Text");
    local EventButton =view.transform:Find("choose");
    assert(EventButton,"dont get EventButton");
    local num =math.random(1,3);
    if EventDir[num].type == 1 then
        EventDes:GetComponent("Image").sprite =RM:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic","Close_2");

        EventButton:GetComponent("Button").onClick:AddListener(function()
            callBack(1);
        end);

    elseif EventDir[num].type ==2 and callBack then
        print("money Event");
        --在unity中 texture与sprite的转化要依靠sprite.create，但是在xlua中无法调用？
        --给ui中的Image添加sprite的时候，必须要使用UnityEngine.sprite的形式
        --local pic =CS.UnityEngine.Sprite:Create(RM:LoadPath("Assets/Resources/Picture/money.jpg","money"));
        --EventDes:GetComponent("Image").sprite =pic;
        EventDes:GetComponent("Image").sprite =RM:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic","SIH_11");

        print(EventDes:GetComponent("Image").sprite);
        EventButton:GetComponent("Button").onClick:AddListener(function()

            ProManager.getMoney(math.random(2,6));
            EventView.destroyView(view);
            EventView.createView(Event,parent,callBack);
            ProManager.saveInfo();
            callBack();
        end);

    elseif callBack then
        print("Expr Event");
        EventDes:GetComponent("Image").sprite =RM:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic","SIH_02");

        --EventDes:GetComponent("Image").sprite =RM:LoadPath("Assets/Resources/Picture/Expr.jpg","Expr");
        EventButton:GetComponent("Button").onClick:AddListener(function()
            ProManager.getExpr(math.random(1,10));
            EventView.destroyView(view);
            EventView.createView(Event,parent,callBack);
            ProManager.saveInfo();
            callBack();
        end);

    else
        print("nil");
    end
    EventText:GetComponent("Text").text =EventDir[num].descri;

    return view
end

function EventView.destroyView(view)
    RM:dropResoureces(view);
end

return EventView