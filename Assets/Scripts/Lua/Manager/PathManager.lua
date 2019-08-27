local PathManager ={};
PathManager.__index =PathManager;


function PathManager:init()
    --【伪绝对path】=相对path
    self.pathCache ={};
end

--根据路径判断从何处加载资源
function PathManager:BoolAsset(path)

    local boolAsset = string.find(path,"AssetBundles");

    return boolAsset
end

--去除后缀
function PathManager:RemovePoint(path)
    local pointIndex =string.find(path,"%.");
    if pointIndex then
        return string.sub(path,1,pointIndex-1);
    end
    return string.sub(path,1)
end

--提供给资源管理的接口
function PathManager:GetTruePath(path)
    if self.pathCache[path] then
        --print("from PM pach cache has it");
        return self.pathCache[path];
    end
    local newPath =nil;
    --其实这样不能算绝对路径
    local i =#"Asset/Resources/"+2;
    local boolAsset = string.find(path,"AssetBundles");
    --存在的话返回的是下标
    if boolAsset then

        newPath =CS.UnityEngine.Application.dataPath..string.sub(path,7);
        --print("from PM Asset path is "..newPath);
    else
        --将path的绝对路径改为相对路径
        newPath =string.sub(path,i);
        newPath=self:RemovePoint(newPath);
        --print("from PM Resources path is ");
        --print(newPath);
    end
    self.pathCache[path] =newPath;
    return newPath
end

--根据assetbundle路径查找ab资源信息(不含后缀）
--例如 human
function PathManager:findName(path)
    local objPath = nil;
    objPath =string.match(path,"/[%w]+%.");
    objPath =string.sub(objPath,2,#objPath-1);
    --print("From PM  findeName the abName is: "..objPath)
    return objPath
end

--根据assetbundle路径查找ab资源信息（含后缀）
--例如 human.pre
function PathManager:findAllName(path)
    local fullName =nil;
    fullName =string.match(path,"/[%w]+%.[%w]+");
    fullName =string.sub(fullName,2);
    --print("from PM fullName is :"..fullName);
    return fullName
end

function PathManager:clear()
    for i,v in  pairs(self.pathCache) do
        self.pathCache[i] =nil;
    end
    --print("from PM path cache is clear");
end

PathManager:init();

return PathManager