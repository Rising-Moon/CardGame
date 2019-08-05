

local SceneManager = {}
SceneManager.zPosStep = -2000
SceneManager.orderStep = 20


function SceneManager:init()
    if self.sceneStack then
        return
    end

    self.sceneStack = {}
end

function SceneManager:initRoot()
    if self.uiRoot then
        return
    end
    local uiRoot =CS.UnityEngine.GameObject.Find("Canvas");
    if uiRoot then
        print(uiRoot);
        self.uiRoot = uiRoot;
        print("成功获取根结点");
        local all = CS.UnityEngine.GameObject.FindObjectsOfTypeAll();
        print(all);
        for k,v in ipairs(all) do
            print(k);
            print(v);
        end
    end

end

function SceneManager:startGame()
    self:initRoot();
end


function SceneManager:restartGame()
    --loadingScene是一个静态打包的场景，直接加载
    CS.UnityEngine.SceneManagement.SceneManager.LoadScene(2);
end


function SceneManager:recieveChange()

end

function SceneManager:isLock()
    return self.lockFlag
end

function SceneManager:lock()
    self.lockFlag = true
end

function SceneManager:unlock()
    self.lockFlag = nil
end

SceneManager:init();

return SceneManager