local JS =require("json");

local ProManager ={};
ProManager.Info ={};

ProManager.Level =0;

local filePath = "Assets/Resources/data/Proto.txt";

function ProManager.loadFile()
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

function ProManager.decodeExpr()
    local level =0;
    local size =2;
    local num =ProManager.Info["Expr"];
    while num >= 0 do
        num=num -size*level;
        level =level +1;
    end
    ProManager.Level =level;
    return level
end

function ProManager.init()
    ProManager.Info =ProManager.loadFile();
    ProManager.Level=ProManager.decodeExpr();
end

function ProManager.getMoney(num)
    if not num then
        return
    end
    ProManager.Info["Money"] =ProManager.Info["Money"]+num;
end

function ProManager.useMoney(num)
    local newNum =ProManager.Info["Money"]-num;
    if newNum >= 0 then
        ProManager.Info["Money"] =newNum;
        return true
    else
        return false
    end
end

function ProManager.getExpr(num)
    ProManager.Info["Expr"] =ProManager.Info["Expr"]+num;
    ProManager.decodeExpr();
end

function ProManager.getFrag(num)
    ProManager.Info["Frag"] =ProManager.Info["Frag"]+num;
end

function ProManager.upDifficult()
    ProManager.Info["Gate"] =ProManager.Info["Gate"] +1;
end

function ProManager.saveInfo()
    local moneyFile = io.open(filePath, "w");
    local content = JS.encode(ProManager.Info);
    moneyFile:write(content);
    moneyFile:close();
end

ProManager.init();

return ProManager