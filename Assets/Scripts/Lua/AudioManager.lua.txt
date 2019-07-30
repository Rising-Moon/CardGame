
local AudioManager ={}

AudioManager.audioStack=nil;
AudioManager.audio=nil;

----------------资源表-----------
--已加载资源的实例化列表，实例化后的obj都存储在这里
--asset--{path, userMap={id--obj}}
ResourcesManager.assetListenerMap = {};

function AudioManager:init()
    if self.audioStack then
        return
    end

    self.audioStack = {}
end

-----------------外部接口-------------
function AudioManager:LoadAuido(path)

end

AudioManager:init();


return AudioManager