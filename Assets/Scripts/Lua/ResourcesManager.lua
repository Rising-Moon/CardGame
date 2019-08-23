
local ResourcesManager ={};

ResourcesManager.__index =ResourcesManager;

local PM =require("PathManager");
----------------资源表---------------
function ResourcesManager:init()
    --resources路径加载后获取的资源
    --objMap[path]=...
    self.objMap ={};

    --资源池
    --[path]{gameobj}
    self.objPool ={};

    --ab的manifest依赖
    --初始化manifest
    self.manifest = self:InitManifest();

    --AssetBundle缓存
    --{assetBundle ,refCount}
    self.AssetBundleCacheMap ={};

    --Asset缓存 path.abName - asset
    self.AssetCacheMap={};

    --Assets依赖关系
    self.AssetBundleIndependenceMap ={};

    self.tempAbName =nil;




end
-------------------------------------

---------------------------主要使用的外部接口-------------------------
--外部获取游戏对象的接口
--返回为实例好的gameobject
function ResourcesManager:instantiatePath(path,abName,parent,position,rotation)
    --如果资源被缓存下来，直接进行初始化
    --print("from instantiatePath is :");
    local newPath =PM:GetTruePath(path);
    self.tempAbName =abName;
    --print(self.objMap[path]);
    if self.objMap[newPath] == nil and self.AssetCacheMap[newPath..abName] == nil then
        --print("From RM run syncInstantiate");
        return self:syncInstantiate(newPath,parent,position,rotation);
        --加载资源
    else
        --print("From RM run instantiate");
        --直接实例化
        return self:instantiate(newPath,parent,position,rotation);
    end
end

--删除对内存资源的引用
--删除资源
--提供给外部调用
function ResourcesManager:clear()
    --print("destroy objmap");
    if self.objMap or self.AssetCacheMap then

        for i, obj in pairs(self.objMap) do
            --print(obj);
            self.objMap[i] =nil;
        end
        --不设置为nil，避免在游戏未结束时进行clear
        --后期逻辑完成后在将该部分设置为nil
        self.objMap = {};
        --print("destroy objpool");
        for i,obj in pairs(self.objPool) do
            --print(obj);
            CS.UnityEngine.Object.Destroy(obj);
        end
        self.objPool = {};
        --print("destroy AssetBundle");
        for k,obj in pairs(self.AssetBundleCacheMap) do
            --print("path is "..k);
            obj.assetBundle:Unload(false);
        end
        self.AssetBundleCacheMap ={};
        self.AssetCacheMap ={};
    else
        --print("不要重复清除缓存");
    end

end

---------------------------不推荐使用的外部接口---------------------------------
--只使用路径和类型加载
--下次想要使用资源的时候可以直接通过返回值实例话
function ResourcesManager:LoadPath(path,abName)
    --print("from RM LoadPath:");
    self.tempAbName =abName;
    path=PM:GetTruePath(path);
    local boolAsset =PM:BoolAsset(path);

    if boolAsset then
        --加载assetbundle资源
        self:LoadAssetBundleResources(path);
    else
        --加载assetbundle资源
        self:LoadResources(path);
    end
    return self.objMap[path] or self.AssetCacheMap[path..self.tempAbName];
end

--删除单个物体
function ResourcesManager:dropResoureces(obj)
    --清除对象
    CS.UnityEngine.Object.Destroy(obj);
end

---------------------对象池处理---------------------------
--向对象池中存对象
function ResourcesManager:pushInPool(path,abName,obj)
    local newPath =PM:GetTruePath(path);
    --已经被存入了
    --意味着第二次打开的化实例化
    if self.objPool[newPath..abName] then
        return
    end
    self.objPool[newPath..abName]=obj;
    --table.insert(self.objPool,obj);
    obj:SetActive(false);
end

--从对象池中取对象

function ResourcesManager:popPool(path,abName)
    local newPath =PM:GetTruePath(path);
    if self.objPool[newPath..abName] then
        local obj =self.objPool[newPath..abName];
        obj:SetActive(true);
        self.objPool[newPath..abName]=nil;
        --table.remove(self.objPool,1);
        return obj
    else
        --print(" From RM popPool there is no obj");
        return nil
    end
end

--------------------------------------------------------


-------------------资源加载相关---------------------
--加载manifest
function ResourcesManager:InitManifest()
    --路径只有一个
    local manifestAB = CS.UnityEngine.AssetBundle.LoadFromFile(CS.UnityEngine.Application.streamingAssetsPath.."/AssetBundles/AssetBundles");
    --print("read manifestAb success");
    local manifest = manifestAB:LoadAsset("AssetBundleManifest");
    return manifest
end


--加载assetbundle 封装后包含一个ab包 和一个引用计数)
function ResourcesManager:LoadAssetBundle(path)

    local assetBundle = self.AssetBundleCacheMap[path];

    if assetBundle then
        assetBundle.refCount = assetBundle.refCount + 1;
    else
        --print("From RM find AssetBundel path is "..path);
        local cache = CS.UnityEngine.AssetBundle.LoadFromFile(path);
        --print("From RM find AssetBundel asset is");
        --print(cache);
        --print("assetbundle has be down");
        self.AssetBundleCacheMap[path] = {assetBundle = cache , refCount=1};
        --print("From RM LoadAssetBundle the path of AssetBundleCacheMap is :"..path);
        --print("From RM LoadAssetBundle the AssetBundle is:");
        --print(self.AssetBundleCacheMap[path].assetBundle);

    end
    --返回一个ab包cache
    return self.AssetBundleCacheMap[path]
end

--加载asset
function ResourcesManager:LoadAsset(ab, path)

    local asset = self.AssetCacheMap[path..self.tempAbName];
    --asset不存在的时候
    if not asset then

        local dependences = self.AssetBundleIndependenceMap[path]
        --加载依赖
        --这里没有考虑到如果两个asset都依赖同一项而这一项在第二个加载时没有重内存中移除，而被重新加载出错
        if not dependences then
            dependences = self.manifest:GetAllDependencies(PM:findAllName(path));
            self.AssetBundleIndependenceMap[path] = dependences;
            --print("From RM LoadAsset the dependence size is "..dependences.Length);
        end
        --加载所有依赖
        for i=0, dependences.Length-1, 1 do
            self:LoadAssetBundle(CS.UnityEngine.Application.dataPath.."/StreamingAssets/AssetBundles/"..dependences[i]);
        end
        asset = ab.assetBundle:LoadAsset(self.tempAbName);
        self.AssetCacheMap[path..self.tempAbName] = asset;
    end
    --print("from RM LoadAsset the asset path is : "..path);
    --print("From RM LoadAsset the asset is:");
    --print(asset);
    return asset
end

--加载resources资源
function ResourcesManager:LoadResources(path)
    self.objMap[path] = CS.UnityEngine.Resources.Load(path);
    --print("from RM resources path is :"..path);
    --print(self.objMap[path]);
    if self.objMap[path] then
        return true
    else
        return false
    end
end

--加载assetbundle资源
function ResourcesManager:LoadAssetBundleResources(path)
    --先加载assetbundle，再加载asset
    self.AssetCacheMap[path..self.tempAbName] =self:LoadAsset(self:LoadAssetBundle(path),path);
    if self.AssetCacheMap[path..self.tempAbName] then
        return true
    else
        return false
    end
end

-----------------------------------------------------------------
--同步实例化
--请求路径，类型，父物体，位置，角度
function ResourcesManager:syncInstantiate(path,parent,position,rotation)
    local boolAsset =PM:BoolAsset(path);
    --path是否正确且资源是否能被加载
    local boolright =nil;
    if boolAsset then
        --加载assetbundle资源
        boolright =self:LoadAssetBundleResources(path);
    else
        --加载assetbundle资源
        boolright =self:LoadResources(path);
    end

    --返回实例化的对象
    if boolright then
        return self:instantiate(path,parent,position,rotation);
    else
        --print(" from RM  synceInstantiate load path error or resources wrong");
        return nil
    end
end

--资源实例化
function ResourcesManager:instantiate(path, parent, position, rotation)
    local gameObj;
    --print("From RM instantiate the uninstantiate object is ");
    --print(self.objMap[path] or self.AssetCacheMap[path..self.tempAbName]);
    if parent then
        --self.object:GetComponent("Transform"):SetParent(parent:GetComponent("Transform"));
        if position then
            gameObj = CS.UnityEngine.Object.Instantiate(self.objMap[path] or self.AssetCacheMap[path..self.tempAbName], position, rotation or CS.UnityEngine.Quaternion.identity);
        else
            gameObj = CS.UnityEngine.Object.Instantiate(self.objMap[path] or self.AssetCacheMap[path..self.tempAbName], parent.Transform, false);
        end
        --gameObj:GetComponent("Transform"):SetParent(parent:GetComponent("Transform"));
        gameObj.transform.parent =parent.transform;
    else
        gameObj = CS.UnityEngine.Object.Instantiate(self.objMap[path] or self.AssetCacheMap[path..self.tempAbName], position or CS.UnityEngine.Vector3.zero, rotation or CS.UnityEngine.Quaternion.identity);
    end
    --GameObject =CS.UnityEngine.Object.Instantiate(self.assetListenerMap[original]);
    --self.object.transform.localPosition=location;
    --缩放为正常大小
    gameObj.transform.localScale=CS.UnityEngine.Vector3(1,1,1);
    --print("from RM abName is clear");
    self.tempAbName =nil;
    return gameObj
end


ResourcesManager:init();

return ResourcesManager