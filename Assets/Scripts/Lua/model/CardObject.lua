----导包
class =require("class");
serialize = require("serialize");
local BaseObject = require("BaseObject");

--继承
local Card =class("Card",BaseObject);


----属性列表
--id
Card.cardId = 0;
--卡牌名字
Card.name = "card";
--卡牌消耗
Card.cost = 0;
--卡牌等级
Card.level = 0;
--卡牌图片
Card.img = "";
--卡牌介绍
Card.introduction = "";
--属性表
Card.valueMap = {};


--构造函数
function Card:ctor(cardId,name,cost,level,img,introduction,valueMap)
    Card.super.ctor(self);
    --属性设置
    self.cardId = cardId;
    self.name = name or "name";
    self.cost = cost or 0;
    self.level = level or 1;
    self.valueMap = valueMap or {};
    self.img = img or "img";
    self.introduction = introduction or "introduction";
end

--toString方法
function Card:toString()
    local context = self.__cname .. "[";
    for k, v in pairs(self) do
        context = context .. k .. "(" .. type(v) .. ")";
        if (type(v) ~= "function" and type(v) ~= "table") then
            context = context .. ":" .. v;
        end
        context = context.."|";
    end
    context = context .. "]";
    return context;
end

return Card