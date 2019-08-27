local UIUtil = {}

--将传入gameobject的所有子节点生成一张表
function UIUtil.genAllChildNameMap(root)
    local map = {};
    local stack = {};
    local nameStack = {};
    local transformList = root:GetComponentsInChildren(typeof(CS.UnityEngine.Transform), true);
    local i = 1;
    while i <= transformList.Length - 1 do
        local current = transformList[i];
        if (#stack == 0) then
            table.insert(stack, current);
            table.insert(nameStack, current.name);
            map[nameStack[#nameStack]] = current;
        elseif (current.parent == stack[#stack]) then
            table.insert(stack, current);
            table.insert(nameStack, nameStack[#nameStack] .. "." .. current.name);
            map[nameStack[#nameStack]] = current;
        elseif (current.parent ~= stack[#stack]) then
            table.remove(stack);
            table.remove(nameStack);
            i = i - 1;
        end
        i = i + 1;
    end
    return map;
end

return UIUtil;