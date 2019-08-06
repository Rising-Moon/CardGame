-- 导包
local pb = require('pb');
local protoc = require('protoc');
local fileReader = require('FileRead');
local class = require('class');
local serialize = require('serialize');

-- 初始化变量
local messageQueue = CS.MessageQueueManager.GetMessageQueue();

function start()
    local object = class("Object");
    object.name = "obj";
    function object:changeName(name)
        self.name = name;
    end
    function object:ctor(name)
        self.name = name;
    end
    local obj = object.new("object1111");
    print(obj.name);
    local obj2 = class("Obj2",object);
    obj2.__index = obj2;
    local obj22 = obj2.new("object22222");
    obj22:changeName("object333333");
    print(obj22.name);
    print(serialize(obj22));
    end

-- 处理响应服务器消息
local responseHandle = {
    -- 处理服务器返回的消息
    SocketResponse = function()

        --解析消息到msg中
        local message = fileReader:read("Assets/Resources/Protos/Message.proto");
        assert(protoc:load(message));
        msg = assert(pb.decode("MessageProto", messageCast.message.msg));

        local switch = {
            -- 本地与服务器版本号不同时拉取更新
            [0] = function()
                if (msg.body ~= CS.Config.Get("version")) then
                    local update = {
                        type = 1,
                        head = "local version",
                        body = CS.Config.Get("version")
                    };
                    local body = assert(pb.encode("MessageProto", update));
                    local message = CS.Message.ByteMessage(CS.Message.MessageType.SocketToServer, body);
                    messageQueue:SendMessage(message);
                end
            end,
            -- 获取解析更新文件列表
            [1] = function()
                updateUtil = CS.UpdateUtil(msg.body);
                updateUtil:Update(msg.body);
            end,
            -- 直接放入消息队列
            [2] = function()
                local message = CS.Message(msg.head,msg.body);
                messageQueue:SendMessage(message);
            end
        }

        local f = switch[msg.type];
        if (f) then
            f();
        end
        f = nil;
    end,

    -- 发送消息给服务器
    SocketLuaPack = function()

    end
}

--对接收消息进行处理
function response()
    if (messageCast.message.head == CS.Message.MessageType.SocketResponse) then
        responseHandle.SocketResponse();
    elseif (messageCast.message.head == CS.Message.MessageType.SocketLuaPack) then
        responseHandle.SocketLuaPack();
    end
end


