--导包
local util = require 'xlua.util';
local RM = require('ResourcesManager');
local SM =require("ScenesManager");

--获取一个c#脚本调用
local myClass =CS.UnityEngine.GameObject.Find("mainApp"):GetComponent("LuaBehaviour");

--对背包使用
local CardList =require("CardList");
local CardListManager = require("CardListManager");
--初始化卡牌管理并从文件中获得卡牌信息
--CardListManager.init();

local BagView ={};

local function imgOnClick(gameObject)
    local Show_Fuc = util.cs_generator(function()
        gameObject.transform.localScale=CS.UnityEngine.Vector3(1.5,1.5,1.5);
        --暂时不能同时点开两个，点开两个后存在错误
        SM:createDes(gameObject:GetComponent("Image").sprite,gameObject.name,"this is :"..gameObject:GetComponent("Image").sprite.name);
        --协程
        coroutine.yield(CS.UnityEngine.WaitForSeconds(1));
        gameObject.transform.localScale=CS.UnityEngine.Vector3(1,1,1);
    end);
    myClass:StartCoroutine(Show_Fuc);

end

--获取预制的背包组件
--根据id来排背包中卡牌的位子
function BagView:createView(bagObject)
    for id,info in pairs(CardList.user_have) do
        --限制六个背包格子
        if id <= 6 then
            local img =bagObject.transform:GetChild(id-1);
            assert(img,"dont get image");
            if img then
                print("get img");
                local pic =RM:LoadPath("Assets/StreamingAssets/AssetBundles/cardimage.pic",CardList.user_have[id].img);
                img:GetComponent("Image").sprite =pic;
                CS.UGUIEventListener.Get(img.gameObject).onClick =imgOnClick;
            else
                --超出限制之后退出，后期可能加上动态增加格子
                break
            end
        end

    end
end

return BagView