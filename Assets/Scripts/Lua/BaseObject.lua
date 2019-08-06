class = require("class");
-- 定义基类
local BaseObject = class("BaseObject");

-- 构造函数
--调用new会自动执行
function BaseObject:ctor(baseName)
    self.objName = baseName;
end

--随机数闪避几率
function BaseObject:RandomIndex()
    math.randomseed(tostring(os.time()):reverse():sub(1, 7)) --设置时间种子
    local tb = math.random(1,100);
    return tb
end

function BaseObject:setUniqueId()
    --local id =config.id + 1;
    --return id
end

--清除函数
function BaseObject:drop()
    for i,v in ipairs(self) do
        self.remove(self,i);
    end
    for j,v in ipairs(self) do
        print(j..v);
    end
    print("object drop");
end

return BaseObject