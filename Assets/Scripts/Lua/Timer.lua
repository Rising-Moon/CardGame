--使用xlua的协程
local util =require 'xlua.util'
local yield_return =(require('cs_coroutine')).yield_return


local Timer ={};

Timer.deleteTime=0;
Timer.listenFuc ={};

function Timer:init()

end


-- 以table名字作为函数的查找编号
function Timer:AddListen(table,fuc)

    --if self.listenFuc[table] then
      --  local
        --self:AddListen()
    --end
    if type(table) ~= "table" or type(fuc) ~= "function" then
        return
    end
    if self.listenFuc[table] and self.listenFuc[table] ==fuc  then
        return
    end
    self.listenFuc[table] =fuc;
end

function Timer:RemoveFuc(fuc)
    if type(fuc) ~="function" then
        return
    end
    for i,v in pairs(self.listenFuc)  do
        if v==fuc then
            self.listenFuc[k]=nil;
        end
    end
end

function Timer:RemoveAll()
    self.listenFuc ={};
end


Timer:init();

return Timer