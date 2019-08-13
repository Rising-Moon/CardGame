--[[
local BaseObject =require("BaseObject");
local CardList =class("CardList",BaseObject);

CardList.data={
    --名字
    --objName="",
    --id
    --objId = 0,
    --未持有卡牌
    notObtain ={},
    --持有卡牌
    userHave ={}
}

--构造函数
--调用new被自动调动
--cardlist 全局唯一，只需要设置持有
function CardList:ctor(objName,userHave,objCards)
    CardList.super.ctor(self);

    print("Card list  ctor run");
    --print(self.data.objName)
    --属性设置
    self.data.userHave =userHave or CS.System.Collections.list();
    self.data.notObtain =objCards or {};
    print("Card list ctor finish");
end

function CardList:clear()
    CardList.super.clear(self);
    print("user clear ");
end

return CardList
]]--

--CardList应当为全局唯一，不继承baseobject

local CardList ={};
CardList.__index =CardList;

function CardList:init()
    --key为int，value为luatable类型，便于存储信息，也可以改为纯gameobject
    self.userHave =CS.System.Collections.Generic["Dictionary`2[System.Int32,XLua.LuaTable]"]();;
    self.notObtain =CS.System.Collections.Generic["List`1[System.Int32]"]();

    --print(self.notObtain);
end

--每个card都有单独的编号
function CardList:GetNewCard(cardIndex,cardObject)

    --不存在元素再添加
    if not self.userHave:ContainsKey(cardIndex,cardObject) then
        print("there is no "..cardIndex)
        self.userHave:Add(cardIndex,cardObject);
        self:RemoveIndex(cardIndex);
        return true
    else
        print("you have own this card");
        return false
    end

    --当访问不存在的的key时，抛出异常，
    --添加元素
    --    self.userHave:Add(1,{path = 0,card =1});
    --    self.userHave:Add(2,{path = 1,card =2});
    --    print(self.userHave[1]);
    --    self.userHave:Remove(1);
    --print(self.userHave[2]);
    --[[通过pair来访问
    for i,v in pairs(self.userHave) do
        print(i);
        print(v);
    end
    ]]--

end

--当有新卡获得时
--新增userHave数据，并除去notObtain的值
function CardList:RemoveIndex(cardIndex)
    --[[
    --添加元素
    self.notObtain:Add(10);
    print(self.notObtain[0]);
    --在指定索引位插入
    self.notObtain:Insert(0,12);
    print(self.notObtain[0]);
    --移除指定位置的元素
    --获取一个元素所在列表中的索引位子
    self.notObtain:RemoveAt(self.notObtain:IndexOf(12));
    print(self.notObtain[0]);
    --将卡牌编号由小到大排序
    self.notObtain:Add(2);
    self.notObtain:Sort();
    for i = 0, 1 do
        print(self.notObtain[i]);
    end
    ]]--
    if self.notObtain:IndexOf(cardIndex) then
        self.notObtain:RemoveAt(cardIndex);
        return true
    else

        return false
    end

end

CardList:init();

return CardList