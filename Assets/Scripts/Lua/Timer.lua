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



end

Timer:init();

return Timer