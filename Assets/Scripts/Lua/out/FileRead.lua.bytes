local FileRead = {};

function FileRead:read(path)
    local file = io.open(path,"r");
    local message = '';

    local line = file:read();

    while (line ~= nil) do
        message = message .. line;
        line = file:read();
    end
    file:close();
    return message;
end

function FileRead:write(path,type,str)
    local file =io.write(path,type);
    if not file  then
        print(path.."is not exit");
        return
    else
        file:write(str);
    end
    file:close();
end

return FileRead;