
local ScenesManager ={};
ScenesManager.__index =ScenesManager;

local ScenesManagement =CS.UnityEngine.SceneManagement.SceneManager;

function ScenesManager:init()
    --存储场景的栈
    self.scenesStack =CS.System.Collections.Stack();
    --print(self.scenesStack);
end

--场景加载
--参数为要加载的场景编号
function ScenesManager:LoadScene(index)
    if  self.scenesStack then
        --将要加载的场景编号押入栈中
        --永远不会加载场景0
        self.scenesStack:Push(index);
        ScenesManagement.LoadScene(index);
    else
        print("wrong happen in stack");
    end
end

--场景返回
function ScenesManager:BackScene()
    if self.scenesStack and self.scenesStack.Count > 1 then
        --弹出对象并移除
        self.scenesStack:Pop();
        --获取上一级对象
        local lastScene = self.scenesStack:Peek();
        ScenesManagement.LoadScene(lastScene);
    else
        print(" this is no last scene can be loaded ");
    end
end

ScenesManager:init();

return ScenesManager