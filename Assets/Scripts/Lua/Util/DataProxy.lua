DataProxy = {};

function DataProxy.createProxy(sourceTable, listeners)
    local proxy = {
        listeners = listeners,
        -- 添加监听者
        addListener = function(proxy,name,func)
            proxy.listeners[name] = func;
        end,
        -- 删除监听者
        removeListener = function (proxy,name)
            proxy.listeners[name] = nil;
        end,
        source = sourceTable
    };

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
                    newValue = DataProxy:createProxy(newValue, listeners);
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