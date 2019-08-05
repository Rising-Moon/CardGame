FileRead = {}

function FileRead:read(path)
    file = io.open(path,"r");
    message = '';

    line = file:read();

    while (line ~= nil) do
        message = message .. line;
        line = file:read();
    end
    return message;
end

return FileRead;