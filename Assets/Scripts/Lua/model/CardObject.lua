----导包
class =require("class");
serialize = require("serialize");
local BaseObject = require("BaseObject");

--继承
local Card =class("Card",BaseObject);


----属性列表
--id
Card.cardId = nil;
--卡牌名字
Card.name = nil;
--卡牌消耗
Card.cost = nil;
--卡牌等级
Card.level = nil;
--属性表
Card.valueMap = nil;


--构造函数
function Card:ctor(cardId,name,cost,level,valueMap)
    Card.super.ctor(self);
    --属性设置
    self.cardId = cardId;
    self.name = name or "";
    self.cost = cost or 0;
    self.level = level or 1;
    self.valueMap = valueMap or {};
end

----存储相关

--读取文件
function Card:readLastFile()
    local file =io.open("Assets/Resources/Config/Card.txt","r");
    --local num = 9;
    for i in file:lines() do
        print(i);
    end
    --print(file:read());
    file:close();
end

--写txt文件
function Card:writeFile()

    local file = io.open("Assets/Resources/Config/Card.txt","a+");
    --将卡牌的临时复制序列化
    local tempStr = serialize(self.data);
    print("demo is here "..tempStr);
    file:write(tempStr);
    file:write("\n");
    file:close();

end

return Card