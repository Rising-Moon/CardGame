--------------参照---------------------------
class =require("class");
serialize = require("serialize");
--require("json");
local Object = require("BaseObject");

--更改创建方法，避免全局混用
--参考cocos的语法糖
-- 创建子类
local Card =class("Card",Object);
Card.__index = Card;



---------------属性列表---------------
--卡牌id
Card.objId = 0;
--初始化状态
--只能初始化一次
Card.initStates = 1;
--卡牌名
Card.objName = nil;
--卡牌类型
--由类型字典确定
Card.objType =nil;
--卡牌数值
Card.objNumber =nil;
--卡牌的游戏对象
Card.objInstantiate =nil;
--卡牌等级
Card.level =1;

-------------------------------------

------------设置属性的接口------------
--卡牌名
function Card:setName(objName)
    self.objName=objName;
end

--卡牌id
function Card:setId()
    --id唯一
    self.objId=Card.super.setUniqueId();
end

--卡牌类型
function Card:setType(objType)
    --1表示攻击
    --2表示防御，护盾
    --3表示治疗，回血
    --4表示特殊效果
    print(type(global.typeDir));
    self.objType=global.typeDir[objType];
end

--卡牌数值
function Card:setNumber(objNumber)
    self.objNumber=objNumber;
end

--游戏对象
function Card:setInstantiate(objInstantiate)
    self.objInstantiate=objInstantiate or "error";
    print(self.objInstantiate);
end

--卡牌升级（可选）
function Card:updateLevel()
    if self.level<3 then
        self.level=self.level+1;
        print(self.level);
    else
        print("不能重复升级");
    end
end
-------------------------------------------------

-------------------初始化卡牌----------------------
--构造函数
--调用new被自动调动
function Card:ctor()
    Card.super.ctor(self,"Card");
end


--初始化
function Card:init(objName,objType,objNumber,objInstantiate)

    if self.initStates ==1 then
        self:setName(objName);
        self:setId();
        self:setType(objType);
        self:setNumber(objNumber);
        self:setInstantiate(objInstantiate);
        self.level =1;
        self.initStates=0;
    else
        print("不能重复赋值");
    end

end
-----------------------------------------------------------


----------------------对卡牌进行操作的接口----------------------
--返回卡牌信息
function Card:cardInformation()
    print("Card information is here");
    return self.objId
end

--移动卡牌（未完成）
function Card:moveCard()
    --self.objInstantiate:AddListener(function()
    if CS.UnityEngine.Input.GetMouseButton(0) then
        local h =CS.UnityEngine.Input.GetAxis("Mouse X");
        local v =CS.UnityEngine.Input.GetAxis("Mouse Y");
        self.objInstantiate.transform.position= self.objInstantiate.transform.position+CS.UnityEngine.Vector3(h*100,v*100,0);
    end
    --end)
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

--删除卡牌
function Card:drop()
    Card.super.drop(self);
    print("Card drop");
end

----------------------存储相关-----------------
--提取数据的临时拷贝
--进行序列化
function Card:dataCopy()
    local objdata ={};
    objdata = { objId = self.objId or 0,objName = self.objName or "card",
                objType =self.objType or global.typeDir.fight, objNumber =self.objNumber or 10 ,
                level =self.level or 1};
    --table.sort(objdata);
    --用pair全部遍历数据进行测试
    --全部遍历后内容随机
    --for i,v in pairs(objdata) do
    --print(i..v);
    --end
    return objdata
end

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
    local tempStr = serialize(self:dataCopy());
    --print("demo is here "..tempStr);
    file:write(tempStr);
    file:close();

end

--------------------------------------------------


return Card