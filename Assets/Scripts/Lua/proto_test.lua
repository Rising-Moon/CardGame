local pb = require 'pb'
local protoc = require 'protoc'

function start ()
    messageQueue = CS.MessageQueueManager.GetMessageQueue();
end

--读取proto文件
file = io.open("Assets/Resources/Protos/Message.proto","r");
message = '';

line = file:read();

while (line ~= nil) do
    message = message .. line;
    line = file:read();
end

--创建待编码消息
local msg = {
    type = 0,
    head = 'update',
    body = 'Map'
}

--protoc加载消息，返回为'_pb'文件
assert(protoc:load(message));

--编码
bytes = assert(pb.encode("MessageProto", msg));

--调试：测试网络通信
function update()

    --点击Z发送Socket消息
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Z) then
        print('按下Z');
        msg = CS.Message.ByteMessage(CS.Message.MessageType.SocketToServer, bytes);
        result = messageQueue:SendMessage(msg);
    end

    --点击F发送测试消息
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.F) then
        print('按下F');
        msg = CS.Message.ByteMessage(CS.Message.MessageType.TestMessage, bytes);
        result = messageQueue:SendMessage(msg);
    end

end

--调试：测试消息监听
function response()
    if (messageCast ~= nil and messageCast.message.head == CS.Message.MessageType.TestMessage) then
        print('Lua监听：type ' .. messageCast.type);
        print('Lua监听：message ' .. messageCast.message.msg);
        local response = assert(pb.decode("MessageProto", messageCast.message.msg));
        print('Lua监听：decode ' .. response.body);
    end
end