local GateButtonEvent =require("GateButtonEvent");

local ScenesManager=require("ScenesManager");
local GatesController = {};

GatesController.callback ={};
local callback =GatesController.callback;

function callback.initListener(num)
    num =nil;
    return num
end

-- 初始化
function GatesController:init()

end
--除了场景0，其他场景的start均不会再被调用
function GatesController.start()

end

function GatesController.update()
    GateButtonEvent.listenEvent(callback);
end

function GatesController.ondestroy()

end

return GatesController