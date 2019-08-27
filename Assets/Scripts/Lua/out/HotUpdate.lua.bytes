-- 导包
local pb = require('pb');
local protoc = require('protoc');
local fileReader = require('FileRead');

local messageQueue = CS.MessageQueueManager.GetMessageQueue();


local HotUpdate = {};
local message = fileReader:read("Assets/Resources/Protos/Message.proto");

assert(protoc:load(message));

-- 发出热更新请求
function HotUpdate:update()
    local update = {
        type = 2,
        head = "update",
        body = ""
    };
    local body = assert(pb.encode("MessageProto", update));
    local message = CS.Message.ByteMessage(CS.Message.MessageType.SocketToServer, body);
    messageQueue:SendMessage(message);
end

return HotUpdate;