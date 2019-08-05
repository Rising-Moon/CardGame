
local ScenesManager ={};
ScenesManager.__index =ScenesManager;

local ScenesManagement =CS.UnityEngine.SceneManagement.SceneManager;

function ScenesManager:init()
    --存储场景的栈
    self.scenesStack =CS.System.Collections.Stack();
end

--场景加载
--参数为要加载的场景编号
--无场景编号时缺省会向前前进
function ScenesManager:LoadScene(index)
    --当前场景
    local currentIndex =ScenesManagement.GetActiveScene().buildIndex;
    --假设index不会高于10
    if self.scenesStack and currentIndex+1<10 and index <10 then
        --将当前场景入栈
        --场景0含有物体被设置为dontdestroy的mainapp，不能再进入场景0进行重复加载
        if  currentIndex>0 then
            self.scenesStack.Push(currentIndex);
        else
            print("dont load scene 0");
        end
        --loadScene
        ScenesManagement.LoadScene(index or currentIndex+1);
    else
        print("please reInit or wrong index");
    end
end

--场景返回
function ScenesManager:BackScene()
    if self.scenesStack and self.scenesStack.Count > 1 then
        --弹出对象并移除
        local lastScene = self.scenesStack.Pop();
        ScenesManagement.LoadScene(lastScene);
    else
        print(" this is no last scene can be loaded ");
    end
end

ScenesManager:init();

return ScenesManager