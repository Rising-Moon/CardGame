
local ScenesManager ={};
ScenesManager.__index =ScenesManager;

------------------------------------
ScenesManager.scenesStack =nil;
ScenesManager.uiRoot =nil;

local ScenesManagement =CS.UnityEngine.SceneManagement.SceneManager;

function ScenesManager:init()
    if self.scenesStack then
        return
    end
    --存储场景的栈
    self.scenesStack =CS.System.Collections.Stack();
    --print(self.scenesStack);
    self:initRoot();
end

function ScenesManager:initRoot()
    if self.uiRoot then
        return
    end
    self.uiRoot=CS.UnityEngine.GameObject.Find("Canvas");
    --print(self.uiRoot);
end

--场景加载
--参数为要加载的场景编号
function ScenesManager:LoadScene(index)
    if  self.scenesStack then
        --将要加载的场景编号押入栈中
        --永远不会加载场景0
        --不允许回退到2，3界面，进行抽卡和战斗
        if index ~=2 and index ~= 3then
            self.scenesStack:Push(index);
        end
        ScenesManagement.LoadScene(index);
    else
        print("wrong happen in stack");
    end
end


--异步加载场景
function ScenesManager:AsyncLoadScene(index)
    if  self.scenesStack then
        --将要加载的场景编号押入栈中
        --永远不会加载场景0
        if index ~=2 and index ~= 3then
            self.scenesStack:Push(index);
        end

        coroutine.resume(AsyncLoad,false,index);
        coroutine.resume(AsyncLoad,true);
    else
        print("wrong happen in stack");
    end
end
--后期可能会加入进度条加载的修改，现在还未实现
--重载场景加载的异步方法
function ScenesManager:AsyncLoadScene1(index)
    local loading =self.uiRoot.transform:Find("Loading");
    print(loading);
    --loading:SetActive(false);
    --loading.enable = true;
end

--场景返回
function ScenesManager:BackScene()
    if self.scenesStack and self.scenesStack.Count > 1 then
        --弹出对象并移除
        self.scenesStack:Pop();
        --获取上一级对象
        local lastScene = self.scenesStack:Peek();
        print("now back to");
        print(lastScene);
        ScenesManagement.LoadScene(lastScene);
    else
        print(" there is no last scene which can be loaded ");
    end
end

--重启游戏进入主场景
function ScenesManager:ReStart()
    self.scenesStack:Clear();
    ScenesManagement.LoadScene(1);
end

--退出游戏
function ScenesManager:QuitGame()
    print("game is quiting");
    CS.UnityEngine.Application.Quit();
end
---------------------内部接口----------------------
---异步加载场景
AsyncLoad = coroutine.create(
        function(bool ,index)
            --异步加载场景
            local operation = ScenesManagement.LoadSceneAsync(index);
            print("do you run?");
            --阻止当加载完成后自动切换
            operation.allowSceneActivation =bool;
            print(operation.allowSceneActivation);
            yreturn =coroutine.yield();
            operation.allowSceneActivation =yreturn;
            print("do you run agine");
            print(operation.allowSceneActivation);
 end)

ScenesManager:init();

return ScenesManager