--序列化
--参照网上方法
serialize = {};

function serialize.encode(obj)
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
        for k, v in pairs(obj) do
            print('key:' .. k .. '  v:' .. type(v));
            if (obj.__index == obj) then
                obj.__index = nil;
                print(lua);
                print(k);
                lua = lua .. "[" .. serialize.encode(k) .. "]=";
                lua = lua .. serialize.encode(v) .. ",\n";
                obj.__index = obj;
            else
                print(lua);
                print(k);
                lua = lua .. "[" .. serialize.encode(k) .. "]=";
                lua = lua .. serialize.encode(v) .. ",\n";
            end
        end
        local metatable = getmetatable(obj);
        if metatable ~= nil and type(metatable.__index) == "table" then
            for k, v in pairs(metatable.__index) do
                lua = lua .. "[" .. serialize.encode(k) .. "]=" .. serialize.encode(v) .. ",\n";
            end
        end
        lua = lua .. "}";
    elseif t == "nil" then

        --如果传入的数据中混入function ， 避免终止
    elseif t == "function" then
        lua = lua;
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

--序列化卡牌信息
function serialize.encodeCard(card)
    local lua = "";

    for k, v in pairs(card) do
        if (type(v) ~= "table" and type(v) ~= "function") then
            --print(k..":"..v);
            lua = lua .. k .. "=" .. v .. "\n";
        else
            if (type(v) == "table" and k == "valueMap") then
                lua = lua .. k .. "={\n" .. serialize.encodeCard(v) .. "}\n";
            end
        end
    end
    return lua;
end

--反序列化卡牌信息
function serialize.decodeCard(text, card)
    local class = card.class;

    while (string.find(text, "\n") ~= nil) do
        --序列化信息逐行
        local index = string.find(text, "\n");
        local line = string.sub(text, 1, index - 1);
        text = string.sub(text, index + 1);
        local split = string.find(line, "=");
        if (split) then
            local key = string.sub(line, 1, split - 1);
            local value = string.sub(line, split + 1);
            --print(key);
            --print(type(class[key]));
            --遇到table时递归处理
            if (value == "{") then
                card[key] = {};
                local table = "";
                local layer = 1;
                while (string.find(text, "\n") ~= nil) do
                    local index = string.find(text, "\n");
                    local line = string.sub(text, 1, index - 1);
                    text = string.sub(text, index + 1);
                    local split = string.find(line, "=");
                    if (split) then
                        if (string.sub(line, split + 1) == "{") then
                            layer = layer + 1;
                        end
                        table = table .. line .. "\n";
                    else
                        if (line == "}") then
                            layer = layer - 1;
                        end
                        if (layer == 0) then
                            break ;
                        end
                    end
                end
                serialize.decodeCard(table, card[key]);
                --print(table);
            else
                setValue(card, key, value);
            end
        end
    end
end

--赋值
function setValue(card, key, value)
    local class = card.class;
    if (class) then
        local t = type(class[key]);
        if (t == "number") then
            card[key] = tonumber(value);
        elseif (t == "boolean") then
            if (value == "true") then
                card[key] = true;
            else
                card[key] = false;
            end
        elseif (t == "string" or t == "nil") then
            card[key] = value;
        end
    else
        card[key] = value;
    end
end

return serialize;


