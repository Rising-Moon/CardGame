--导包
local RM = require('ResourcesManager');
local ProManager= require("ProManager");
local GDM =require("GateDataManager");

local EventView ={};

function EventView.InitView(Event,parent,callBack,typeNum)
    print("now new a new Event".."\t"..Event);
    local view =RM:instantiatePath("Assets/Resources/Prefabs/EventInfo.prefab","EventInfo",parent,parent.transform.position);
    --调整大小
    view.transform.localScale=CS.UnityEngine.Vector3(0.6,0.6,0.6);

    local EventDes =view.transform:Find("EventDes");
    local EventText =view.transform:Find("choose/Text");
    local EventButton =view.transform:Find("choose");
    assert(EventButton,"dont get EventButton");

    if EventDir[typeNum].type == 1 then
        EventDes:GetComponent("Image").sprite =RM:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic","Close_2");
        EventText:GetComponent("Text").text =EventDir[typeNum].descri;
        EventButton:GetComponent("Button").onClick:AddListener(function()
            GDM.handleEvent(tonumber(Event));
            callBack(1);
        end);

    elseif EventDir[typeNum].type ==2 and callBack then
        print("money Event");
        --在unity中 texture与sprite的转化要依靠sprite.create，但是在xlua中无法调用？
        --
        --给ui中的Image添加sprite的时候，必须要使用UnityEngine.sprite的形式
        --local pic =CS.UnityEngine.Sprite:Create(RM:LoadPath("Assets/Resources/Picture/money.jpg","money"));
        --EventDes:GetComponent("Image").sprite =pic;
        EventDes:GetComponent("Image").sprite =RM:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic","SIH_11");
        local num =math.random(2,6);
        EventText:GetComponent("Text").text =EventDir[typeNum].descri..num;
        --print(EventDes:GetComponent("Image").sprite);
        EventButton:GetComponent("Button").onClick:AddListener(function()
            ProManager.getMoney(num);
            GDM.handleEvent(tonumber(Event));
            EventView.destroyView(view);
            --新建一个
            EventView.createView(Event,parent,callBack);
            ProManager.saveInfo();

            callBack();
        end);

    elseif callBack then
        print("Expr Event");
        EventDes:GetComponent("Image").sprite =RM:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic","SIH_02");
        local num =math.random(1,10);
        EventText:GetComponent("Text").text =EventDir[typeNum].descri..num;
        --EventDes:GetComponent("Image").sprite =RM:LoadPath("Assets/Resources/Picture/Expr.jpg","Expr");
        EventButton:GetComponent("Button").onClick:AddListener(function()
            ProManager.getExpr(num);
            GDM.handleEvent(tonumber(Event));

            EventView.destroyView(view);


            EventView.createView(Event,parent,callBack);
            ProManager.saveInfo();

            callBack();
        end);

    else
        print("nil");
    end
    GDM.saveInfo();
    --EventText:GetComponent("Text").text =EventDir[typeNum].descri;

    return view
end



function EventView.createView(Event,parent,callBack)
    local view;
    local EventNum =tonumber(Event);
    --print("From Event view the event num is:");
    --print(GDM.Info[EventNum]);
    if not GDM.Info[EventNum] or GDM.Info[EventNum] == "default" then
        local num =math.random(1,3);
        EventView.InitView(Event,parent,callBack, num);
        GDM.saveEvent(EventNum,num);
        --print("From Event view the new event num is:");
        --print(GDM.Info[EventNum]);
    else
        EventView.InitView(Event,parent,callBack,tonumber(GDM.Info[EventNum]));
        print("From Event view the cache has value");
    end
    return view
end



function EventView.destroyView(view)
    RM:dropResoureces(view);
end

return EventView