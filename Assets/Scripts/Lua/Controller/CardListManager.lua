-- 导包
local CardObject = require('CardObject');
local serialize = require('serialize');
local cardList = require('CardList');

CardListManager = {}

local filePath = "Assets/Resources/data/Cards.txt";

function CardListManager.loadCards()
    --从文件中读取卡牌信息
    --卡牌信息文件
    local cardsFile = io.open(filePath);
    --当前读取的卡牌id
    local currentId = nil;
    --当前卡牌的信息
    local cardInfo = "";
    --当前卡牌
    local currentCard = nil;
    if (cardsFile) then
        local lines = cardsFile:lines();
        for line in lines do
            --读取玩家拥有的卡牌id
            if (string.find(line, "user_have:") == 1) then
                local userHaveCardId = string.sub(line, 11);
                while (userHaveCardId ~= "\n" and userHaveCardId ~= "") do
                    local id;
                    --切割字符串，提取id
                    if (string.find(userHaveCardId, ",")) then
                        id = string.sub(userHaveCardId, 1, string.find(userHaveCardId, ",") - 1);
                        userHaveCardId = string.sub(userHaveCardId, string.find(userHaveCardId, ",") + 1);
                    elseif (userHaveCardId ~= "") then
                        id = string.sub(userHaveCardId, 1, string.find(userHaveCardId, "\n"));
                        userHaveCardId = "";
                    end
                    --创建一个空的卡牌对象，以卡牌的id为键值存入相应表中
                    cardList.user_have[id] = CardObject.new(tonumber(id));
                end
                --玩家未拥有卡牌
                --逻辑同上
            elseif (string.find(line, "not_obtain:") == 1) then
                local userHaveCardId = string.sub(line, 12);
                while (userHaveCardId ~= "\n" and userHaveCardId ~= "") do
                    local id;
                    if (string.find(userHaveCardId, ",")) then
                        id = string.sub(userHaveCardId, 1, string.find(userHaveCardId, ",") - 1);
                        userHaveCardId = string.sub(userHaveCardId, string.find(userHaveCardId, ",") + 1);
                    elseif (userHaveCardId ~= "") then
                        id = string.sub(userHaveCardId, 1, string.find(userHaveCardId, "\n"));
                        userHaveCardId = "";
                    end
                    cardList.not_obtain[id] = CardObject.new(id);
                end
                --分割卡牌信息
            elseif (string.find(line, "Card:") == 1) then
                local id = string.sub(line, 6, #line);
                local card = nil;

                --判读卡牌是否存在与游戏中
                if (cardList.user_have[id]) then
                    card = cardList.user_have[id];
                elseif (cardList.not_obtain[id]) then
                    card = cardList.not_obtain[id];
                end

                --反序列化数据存储到卡片对象中
                if (cardInfo ~= "") then
                    serialize.decodeCard(cardInfo, currentCard);
                    cardInfo = "";
                end

                --卡牌存在，修改迭代所用变量
                if (card) then
                    if (currentId ~= nil) then
                        currentId = id;
                        currentCard = card;
                    else
                        currentId = id;
                        currentCard = card;
                    end
                else
                    currentId = nil;
                    currentCard = nil;
                end
            else
                --当前卡牌id不为nil时组合信息
                if (currentId) then
                    cardInfo = cardInfo .. line .. "\n";
                end
            end
        end
        --循环结束后可能残存一张卡片的信息，将其反序列化
        if (cardInfo ~= "") then
            serialize.decodeCard(cardInfo, currentCard);
        end
    end

    cardsFile:close();
end

CardListManager.loadCards();

function CardListManager.saveCards()
    local cardsFile = io.open(filePath, "w");
    local content = "";
    --更新拥有和为拥有卡片id
    content = content .. "user_have:";
    for k, _ in pairs(cardList.user_have) do
        content = content .. k .. ",";
    end
    content = content .. "\n" .. "not_obtain:";
    for k, _ in pairs(cardList.not_obtain) do
        content = content .. k .. ",";
    end
    content = content .. "\n";

    --遍历卡牌列表
    for k, v in pairs(cardList.user_have) do
        if (v.name ~= "") then
            content = content .. "Card:" .. k .. "\n" .. serialize.encodeCard(v);
        end
    end
    for k, v in pairs(cardList.not_obtain) do
        if (v.name ~= "") then
            content = content .. "Card:" .. k .. "\n" .. serialize.encodeCard(v);
        end
    end

    cardsFile:write(content);
    cardsFile:flush();
    cardsFile:close();
end

CardListManager.saveCards();
return CardListManager;