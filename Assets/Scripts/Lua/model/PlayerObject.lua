--class =require("class");
local Character = require("CharacterObject");

--------------------------------------
--更改创建方法，避免全局混用
-- 创建子类Child
local PlayerObject =class("PlayerObject",Character);

---------------------属性表------------------------
PlayerObject.data={
    --玩家名
    --objName = nil;
    --玩家血条
    --objBlood = 10;
    --玩家id
    --objId = 0;
    --玩家等级
    --level = 1;
    --玩家attribute
    --attribute
    --玩家经验
    Experience =0,
    --角色拥有的卡牌组
    holdCard ={}
};

--玩家实例对象的引用
--Player.objInstantiate =nil;


--本地初始化状态
--Player.localinitStates =0;

------------------------------------------------------------
--构造函数
function PlayerObject:ctor(objName,objNumber,objMaNa,objAttrubute,objExperience,holdCard,objInstantiate)
    --使用.传值，需要将左边第一个参数设置为self
    PlayerObject.super.ctor(self,objName,objNumber,objMaNa,objAttrubute,objInstantiate);
    print("player ctor run");
    self.data.Experience =objExperience or 0;
    self.data.holdCard =holdCard or {};
    print("player ctor finish");
end

---------------------------玩家升级相关逻辑-------------------
--获得经验
--获取经验的时候判断是否升级
function PlayerObject:getExperience(experience)
    --先获取经验
    self.data.Experience =self.data.Experience+experience;
    self.data.Experience =self:updateLevel();
end

--升级
function PlayerObject:updateLevel()
    --玩家升级所需经验需要当前的两倍
    local restExperience = self.data.Experience / (self.data.level*2);
    --玩家等级不能超过十级
    print(self.data.level);
    print(self.data.Experience);
    print(restExperience);
    if self.data.level<10 and restExperience >= 1 then
        --升级标准
        --玩家升级时
        --floor 向下取整

        self.data.level=self.data.level+math.floor(self.data.Experience/(self.data.level*2));
        if self.data.level >10 then
            self.data.level =10;
        end
        --升级增加血量
        --
        return restExperience
    else
        print("不满足升级条件");
        --不满足升级经验的时候全额返还
        return self.data.Experience
    end
end
-----------------------------------------------------------

--------------------玩家战斗相关----------------------------
function PlayerObject:handleCard(mss)
    print("from player:"..mss);
end

-----------------------------------------------------------

---------------------玩家本地存档相关-----------------------
--[[
--储存玩家本身相关数据
function Player:storeInfor()
    CS.UnityEngine.PlayerPrefs.SetString("playerName",self.objName);
    CS.UnityEngine.PlayerPrefs.SetInt("playerId",self.objId);
    CS.UnityEngine.PlayerPrefs.SetInt("playerLifeNumber",self.lifNumber);
    CS.UnityEngine.PlayerPrefs.SetInt("playerLevel",self.level);
    CS.UnityEngine.PlayerPrefs.SetInt("playerExper",self.experience);
    self.localinitStates =1;
end

--清除存档
--先卸载人物类进行测试
function Player:deleteAll()
    CS.UnityEngine.PlayerPrefs.DeleteAll();
end

--根据键清除某项属性
function Player:deleteByKey(key)
    CS.UnityEngine.PlayerPrefs.DeleteKey(key);
end

--根据本地存储文件进行初始化
function Player:readInit()
    self.objName = CS.UnityEngine.PlayerPrefs.GetString("playerName","jack");
    self.objId = CS.UnityEngine.PlayerPrefs.GetInt("palerId",1);
    self.lifNumber =CS.UnityEngine.PlayerPrefs.GetInt("playerLifeNumber",10);
    self.level = CS.UnityEngine.PlayerPrefs.GetInt("playerLevel",1);
    self.experience =CS.UnityEngine.PlayerPrefs.GetInt("palerExper",0);
    self.localinitStates=0;
end
]]--
---------------------------------------------------------

--
function PlayerObject:playerInformation()
    print("Player information is here");
    return 1
end

--
function PlayerObject:movePlayer()

end

function PlayerObject:usePlayer()

end

function PlayerObject:clear()
    PlayerObject.super.clear(self);
    print("Player  drop");
end

return PlayerObject