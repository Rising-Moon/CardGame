
local ResourcesManager ={};

ResourcesManager.__index =ResourcesManager;

----------------资源表---------------
function ResourcesManager:init()
    --路径加载后获取的资源
    --objMap[path]=...
    self.objMap ={};
    --资源池
    --[path]{gameobj}
    self.objPool ={};
end
-------------------------------------

---------------------------主要使用的外部接口-------------------------
--外部获取游戏对象的接口
--返回为实例好的gameobject
function ResourcesManager:instantiatePath(path,parent,position,rotation)
    --如果资源被缓存下来，直接进行初始化
    print("from instantiatePath is :");
    print(self.objMap[path]);
    if self.objMap[path] == nil then
        print("run syncInstantiate");
        return self:syncInstantiate(path,parent,position,rotation);
        --加载资源
    else
        print("run instantiate");
        --直接实例化
        return self:instantiate(path,parent,position,rotation);
    end
end

--删除对内存资源的引用
--删除资源
--提供给外部调用
function ResourcesManager:clear()
    print("destroy objmap");
    for i, obj in pairs(self.objMap) do
        --print(obj);
        self.objMap[i] =nil;
    end
    self.objMap = nil;
    print("destroy objpool");
    for i,obj in pairs(self.objPool) do
        --print(obj);
        CS.UnityEngine.Object.Destroy(obj);
    end
    self.objPool = nil;
end

---------------------------不推荐使用的外部接口---------------------------------
--只使用路径和类型加载
--下次想要使用资源的时候可以直接通过返回值实例话
function ResourcesManager:LoadPath(path)
    local boolAsset =self:BoolAsset(path);

    if boolAsset then
        --加载assetbundle资源
        self:LoadAssetBundleResources(path);
    else
        --加载assetbundle资源
        self:LoadResources(path);
    end
    return self.objMap[path];
end

--删除单个物体
function ResourcesManager:dropResoureces(obj)
    --清除对象
    CS.UnityEngine.Object.Destroy(obj);
end

---------------------对象池处理---------------------------
--向对象池中存对象
function ResourcesManager:pushInPool(path,obj)
    table.insert(self.objPool[path],obj);
    obj:SetActive(false);
end

--从对象池中取对象
--存在index错误的可能，发生在对象池中不存在对象的情况下
function ResourcesManager:popPool()
    if #self.objPool then
        local obj =self.objPool[1];
        obj:SetActive(true);
        table.remove(self.objPool,1);
        return obj
    else
        print("this is no obj");
    end
end

--------------------------------------------------------

------------------正则处理路径相关------------------------
--根据路径判断从何处加载资源
function ResourcesManager:BoolAsset(path)
    local boolAsset = string.find(path,".");
    return boolAsset
end

--根据assetbundle路径查找ab资源信息(不含后缀）
--例如 human
function ResourcesManager:findName(path)
    local objPath = nil;
    objPath =string.match(path,"/[%w]+%.");
    return string.sub(objPath,2,#objPath-1)
end

--根据assetbundle路径查找ab资源信息（含后缀）
--例如 human.pre
function ResourcesManager:findAllName(path)
    local fullName =nil;
    fullName =string.match(path,"/[%w]+%.[%w]+");
    return string.sub(fullName,2);
end

-------------------资源加载相关---------------------
--加载resources资源
function ResourcesManager:LoadResources(path)
    self.objMap[path] = CS.UnityEngine.Resources.Load(path);
    if self.objMap[path] then
        return true
    else
        return false
    end
end

-----------------------------------------------------------------
--资源实例化
function ResourcesManager:instantiate(path, parent, position, rotation)
    local gameObj;
    print(self.objMap[path]);
    if parent then
        --self.object:GetComponent("Transform"):SetParent(parent:GetComponent("Transform"));
        if position then
            gameObj = CS.UnityEngine.Object.Instantiate(self.objMap[path], position, rotation or CS.UnityEngine.Quaternion.identity);
        else
            gameObj = CS.UnityEngine.Object.Instantiate(self.objMap[path], parent.Transform, false);
        end
        gameObj:GetComponent("Transform"):SetParent(parent:GetComponent("Transform"));
    else
        gameObj = CS.UnityEngine.Object.Instantiate(self.objMap[path], position or CS.UnityEngine.Vector3.zero, rotation or CS.UnityEngine.Quaternion.identity);
    end
    --GameObject =CS.UnityEngine.Object.Instantiate(self.assetListenerMap[original]);
    --self.object.transform.localPosition=location;
    return gameObj
end


ResourcesManager:init();

return ResourcesManager