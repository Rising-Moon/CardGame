CardController = require("CardController");

BattleController = {};

-- 回调函数表
BattleController.Callback = {}
local callback = BattleController.Callback;

--使用卡牌
function callback.UseCard(card)
    print("使用了卡牌"..card);
end

function BattleController:init()

end

function BattleController.update()
    CardController.CardMove(callback);
end

return BattleController;