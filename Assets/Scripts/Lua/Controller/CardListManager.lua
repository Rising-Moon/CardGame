-- 导包
local CardObject = require('CardObject');
local serialize = require('serialize');
local cardList = require('CardList');

CardListManager = {}

function CardListManager.loadCards()
    print('load card');
    local cardsFile = io.open("Assets/Resources/data/Cards.txt");
end

function CardListManager.saveCards()

    print(cardList.not_obtain[1]);
end
return CardListManager;