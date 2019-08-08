local BaseObject =require("BaseObject");
local UserObject =class("UseObject",BaseObject);

UserObject.data={
    --名字
    --objName="",
    --id
    --objId = 0,
    --持有金币
    Money =0,
    --持有卡牌编号
    ownCards ={}
}
--构造函数
--调用new被自动调动
function UserObject:ctor(fillthing,objName,objMoney,objCards)
    UserObject.super.ctor(self,"UserObject",objName);

    print("User ctor run");
    --print(self.data.objName)
    --属性设置
    self.data.Money =objMoney or 0;
    self.data.ownCards =objCards or {};
    print("User ctor finish");
end

function UserObject:clear()
    UserObject.super.clear(self);
    print("user clear ");
end

return UserObject