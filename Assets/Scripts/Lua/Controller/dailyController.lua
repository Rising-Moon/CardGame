local Resou

local ScenesManager=require("ScenesManager");
local dailyController = {};

local flag=0;

local uiRoot=nil;
local fightButton =nil;
local pomkButton =nil;
local closeButton =nil;
-- 初始化
function dailyController:init()

end
--除了场景0，其他场景的start均不会再被调用
function dailyController.start()

    --[[
    uiRoot =ScenesManager:initRoot();
    fightButton =uiRoot.transform:Find("fight");
    pomkButton =uiRoot.transform:Find("pamkingCard");
    closeButton =uiRoot.transform:Find("quit");

    assert(closeButton,"dont get closebutton");
    assert(pomkButton,"dont get pomkButton");
    assert(fightButton,"dont get fightbutton");
    print("did this start run");
    ]]--
end

function dailyController.update()

end

function dailyController.ondestroy()

end

return dailyController