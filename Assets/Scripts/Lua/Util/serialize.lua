--序列化
--参照网上方法
function serialize (obj)
    local lua = "";
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj;
    elseif t == "boolean" then
        lua = lua .. tostring(obj);
    elseif t == "string" then
        lua = lua .. string.format("%q", obj);
    elseif t == "table" then
        lua = lua .. "{\n";
        --遍历子层
        --约束 obj不会超过两层
        for k, v in pairs(obj) do
            print(k);
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n";
            print(v);
        end
        local metatable = getmetatable(obj);
        if metatable ~= nil and type(metatable.__index) == "table" then
            for k, v in pairs(metatable.__index) do
                lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n";
            end
        end
        lua = lua .. "}";
    elseif t == "nil" then
        return nil
        --如果传入的数据中混入function ， 避免终止
    elseif t == "function" then
        lua = lua .."function,\n";
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

return serialize
