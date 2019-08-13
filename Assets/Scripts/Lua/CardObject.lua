--------------参照---------------------------
--class =require("class");
--serialize = require("serialize");
--require("json");
local BaseObject = require("BaseObject");

--更改创建方法，避免全局混用
--参考cocos的语法糖
-- 创建子类
local Card =class("Card",BaseObject);


---------------属性列表---------------
Card.data={
    --卡牌名字
    objName="",
    --卡牌id
    --objId = 0,
    --卡牌效果
    --{effectname1 =effect,effectname2 =effect}
    objEffect ={},
    --卡牌数值
    objNumber = 0;
    --卡牌level
    level =1,
    --卡牌消耗
    objMaNa =2
}
--实例化的物体
Card.objInstantiate =nil;
-------------------------------------

------------设置属性的接口------------

--卡牌升级（可选）
function Card:updateLevel()
    if self.data.level<3 then
        self.data.level=self.data.level+1;
        --留下更改地点，具体规则后期实现
        self.data.objNumber =self.data.objNumber+1;
        self.data.objMaNa =self.data.objMaNa+2;
        print(self.data.level);
        return true
    else
        print("不能重复升级");
        return false
    end
end
-------------------------------------------------

-------------------初始化卡牌----------------------
--构造函数
--调用new被自动调动
function Card:ctor(objName,objEffect,objNumber,objMaNa,objInstantiate)
    Card.super.ctor(self,"Card");

    print("card ctor run");
    --print(self.data.objName)
    --属性设置
    self.data.objName =objName or "Card";
    self.data.objEffect=objEffect or {};
    self.data.objNumber=objNumber or 10;
    self.data.objMaNa =objMaNa or 2;
    self.objInstantiate=objInstantiate or nil;
    self.data.level =1;
    print("card ctor finish");
end

-----------------------------------------------------------


----------------------对卡牌进行操作的接口----------------------

--返回卡牌信息
function Card:cardInformation()
    print("Card information is here");
    return self.data
end

--使用卡牌
--进行消息队列的使用
--预想利用通信将卡牌信息发送给网络层，由网络层的后段进行计算
--未实现
function Card:useCard()
    local messageQueue = CS.MessageQueueManager.GetMessageQueue();
    local msg = CS.Message(CS.Message.MessageType.TestMessage,'form Card');
    messageQueue:SendMessage(msg);
end

--删除卡牌属性信息
function Card:clear()
    Card.super.clear(self);
    print("Card is drop");
end

----------------------存储相关-----------------

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

--------------------------------------------------


return Card