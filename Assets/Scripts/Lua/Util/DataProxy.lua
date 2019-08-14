DataProxy = {};

function DataProxy:createProxy(sourceTable, listeners)
    local proxy = {
        addListener = function(proxy, func)
            table.insert(listeners, func);
        end
    };
    local meta = {
        __index = function(p, name)
            return sourceTable[name];
        end,
        __newindex = function(p, name, value)
            if (sourceTable[name] ~= value) then
                local oldValue = sourceTable[name];
                local newValue = value;

                if (type(newValue) == "table") then
                    newValue = self:createProxy(newValue, listeners);
                end

                for _, v in pairs(listeners) do
                    if (v) then
                        v(oldValue, newValue);
                    end
                end
            end
            sourceTable[name] = newValue;
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