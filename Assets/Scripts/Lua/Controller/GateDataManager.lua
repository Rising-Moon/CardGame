local JS =require("Json");

local GateDataManager ={};
GateDataManager.Info ={};

local filePath ="Assets/Resources/data/gates.txt"

function GateDataManager.loadFile()
    --从文件中读取信息
    local File =io.open(filePath);
    --信息
    local Info ="";
    --预设中只有一行，所以实际上不用这样？
    if File then
        local lines =File:lines();
        for line  in lines do
            Info=Info..line;
        end
    end
    File:close();
    return JS.decode(Info)
end

function GateDataManager.init()
    GateDataManager.Info =GateDataManager.loadFile();
end

function GateDataManager.saveEvent(num,viewNum)
    if GateDataManager.Info[num] then
        GateDataManager.Info[num] =viewNum;
        return
    end
    --可能存在顺序问题
    table.insert(GateDataManager.Info,viewNum);

end

function GateDataManager.handleEvent(num)
    GateDataManager.Info[num]= "default";
end

function GateDataManager.saveInfo()
    local File = io.open(filePath, "w");
    local content = JS.encode(GateDataManager.Info);
    File:write(content);
    File:close();
end

GateDataManager.init();

return GateDataManager