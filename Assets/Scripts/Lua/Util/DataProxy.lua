DataProxy = {};

function DataProxy.createProxy(sourceTable, listeners)
    local proxy = {
        listeners = listeners,
        -- 添加监听者
        addListener = function(self, name, func)
            self.listeners[name] = func;
        end,
        -- 删除监听者
        removeListener = function(self, name)
            self.listeners[name] = nil;
        end,
        source = sourceTable;
    };


    for k,v in pairs(sourceTable) do
        if(type(v) == "table" and k ~= "__index") then
            sourceTable[k] = DataProxy.createProxy(sourceTable[k],listeners);
            for k, v in pairs(listeners) do
                print(k);
                if (v) then
                    v(sourceTable[k], nil);
                end
            end
        end
    end


    -- 生成一个数据代理，对sourceTable的数据修改进行监控
    local meta = {
        __index = function(p, name)
            return sourceTable[name];
        end,
        __newindex = function(p, name, value)
            if (sourceTable[name] ~= value) then
                local oldValue = sourceTable[name];
                local newValue = value;
                if (type(newValue) == "table") then
                    newValue = DataProxy.createProxy(newValue, listeners);
                end
                sourceTable[name] = newValue;

                for _, v in pairs(listeners) do
                    if (v) then
                        v(oldValue, newValue);
                    end
                end
            end
        end,
        __next = function(p, k)
            return next(sourceTable, k);
        end,
        __pairs = function(p)
            return pairs(sourceTable);
        end,
        __len = function(p)
            return #sourceTable;
        end
    }
    setmetatable(proxy, meta);
    return proxy;
end

return DataProxy;