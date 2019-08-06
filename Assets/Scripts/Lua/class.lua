--class 方法
function class(classname,super)
    local superType = type(super);
    local cls;

    if superType ~= "function" and superType ~= "table" then
        superType=nil;
        super =nil;
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- 定义table类
        cls = {};

        --将父类所有对象拷贝到子类
        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do
                cls[k] = v;
            end
            cls.__create = super.__create;
            cls.super    = super;
        else
            --使用create构造对象
            cls.__create = super;
        end

        cls.ctor    = function()
            print("空构造函数");
        end
        cls.__cname = classname;
        cls.__ctype = 1;
        --构造对象
        function cls.new(...)
            local instance = cls.__create(...);
            -- copy fields from class to native object
            for k,v in pairs(cls) do
                instance[k] = v;
            end
            instance.class = cls;
            instance:ctor(...);
            return instance
        end

    else
        --继承自普通lua表
        if super then
            cls = {};
            setmetatable(cls,{__index = super});
            cls.super = super;
        else
            cls = {ctor = function() end};
        end

        cls.__cname = classname;
        cls.__ctype = 2; -- lua
        cls.__index = cls;
        --实例化
        function cls.new(...)
            local instance = setmetatable({}, cls);
            instance.class = cls;
            instance:ctor(...);
            return instance;
        end
    end

    return cls

end

return class