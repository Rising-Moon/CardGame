local util = require 'xlua.util';
local RM =require("ResourcesManager");

local ScenesManager ={};

ScenesManager.__index =ScenesManager;

local UE =CS.UnityEngine;

local myClass =UE.GameObject.Find("mainApp"):GetComponent("LuaBehaviour");
print("class is  :");
print(myClass);
------------------------------------

ScenesManager.scenesStack =nil;
--切换场景后要重新加载
ScenesManager.uiRoot =nil;

local ScenesManagement =UE.SceneManagement.SceneManager;

function ScenesManager:init()
    if self.scenesStack then
        return
    end
    --存储场景的栈
    self.scenesStack =CS.System.Collections.Stack();
    --print(self.scenesStack);
    --self:initRoot();
end


function ScenesManager:initRoot()
    if self.uiRoot then
        return self.uiRoot
    end
    self.uiRoot=UE.GameObject.Find("Canvas");
    --print(self.uiRoot);
    return self.uiRoot
end


function ScenesManager:GetIndex()
    return ScenesManagement.GetActiveScene().buildIndex
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
        self.uiRoot =nil;
    else
        print("wrong happen in stack");
    end
end

--此处协程有误
--异步加载场景
function ScenesManager:AsyncLoadScene(index)
    if  self.scenesStack then
        --将要加载的场景编号押入栈中
        --永远不会加载场景0
        if index ~=2 and index ~= 3then
            self.scenesStack:Push(index);
        end

        coroutine.resume(AsyncLoad,false,index);
        --local Timer= CS.Timer(1,true,true);
        coroutine.resume(AsyncLoad,true);

    else
        print("wrong happen in stack");
    end
end



--后期可能会加入进度条加载的修改，现在还未实现
--重载场景加载的异步方法
function ScenesManager:AsyncLoadSceneCall(index)
    --异步加载
    local LoadSceneAsync_Fun = util.cs_generator(function()
        local LoadPre =RM:instantiatePath("Assets/StreamingAssets/AssetBundles/human.pre","healthBar",UE.GameObject.Find("Canvas"));
        local Slider =LoadPre.transform:Find("Slider"):GetComponent(typeof(UE.UI.Slider));
        local Text =LoadPre.transform:Find("Text"):GetComponent(typeof(UE.UI.Text));

        Text.text = "Loading: 0%"

        -- 预加载场景资源,90%的进度条用于显示资源加载，剩余10%为场景加载
        local async = ScenesManagement.LoadSceneAsync(index);

        print("the next scene is: "..index);

        while not async.isDone do
            if async.progress <= 0.85 then
              Slider.value = async.progress;
            else
              Slider.value = 1;
            end
            Text.text = "Loading: ".. math.ceil(Slider.value * 100) .."%";
            coroutine.yield(UE.WaitForEndOfFrame)
        end
    end)

    if  self.scenesStack then
        --将要加载的场景编号押入栈中
        --永远不会加载场景0
        --不允许回退到2，3界面，进行抽卡和战斗
        if index ~=2 and index ~= 3then
            self.scenesStack:Push(index);
        end
        --local LoadSceneAsync = CS.XLua.Cast.IEnumerator(LoadSceneAsync_Fun)
        myClass:StartCoroutine(LoadSceneAsync_Fun);
        --myClass:StartCoroutine(LoadSceneAsync);
        self.uiRoot =nil;
    else
        print("wrong happen in stack");
    end


end

--场景返回
function ScenesManager:BackScene()
    if self.scenesStack and self.scenesStack.Count > 1 then
        --弹出对象并移除:GetComponent("Main")
        self.scenesStack:Pop();
        --获取上一级对象
        local lastScene = self.scenesStack:Peek();
        print("now back to");
        print(lastScene);
        ScenesManagement.LoadScene(lastScene);
        self.uiRoot =nil;
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
---lua中的协程实际上是暂停，与unity'中使用update来辅助协程不同，不能使用这样的方式
---或许可以使用定时器来定时检查
AsyncLoad = coroutine.create(
        function(bool ,index)
            --异步加载场景
            local operation = ScenesManagement.LoadSceneAsync(index);
            --print("do you run?");
            --阻止当加载完成后自动切换
            operation.allowSceneActivation =bool;
            --print(operation.allowSceneActivation);
            while (not operation.isDone) do
                print("please wait");
                coroutine.yield();
            end

            local yreturn =coroutine.yield();
            operation.allowSceneActivation =yreturn;
            --print("do you run agine");
            --print(operation.allowSceneActivation);
 end)
-----------------------------------------------------
ScenesManager:init();

return ScenesManager