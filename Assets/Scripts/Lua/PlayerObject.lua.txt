class =require("class");
local Character = require("CharacterObject");

--------------------------------------
--更改创建方法，避免全局混用
-- 创建子类Child
local Player =class("Player",Character);
Player.__index =Player;

---------------------属性表------------------------
--初始化状态
Player.initStates =1;
--玩家名
Player.objName = nil;
--玩家实例对象的引用
Player.objInstantiate =nil;
--玩家类型
Player.objType =1;
--玩家血条
Player.lifNumber = 10;
--玩家id
Player.objId = 0;
--玩家等级
Player.level = 1;
--玩家经验
Player.experience =0;
--本地初始化状态
Player.localinitStates =0;
------------------------------------------------

--卡player名
function  Player:setName(objName)
    self.objName=objName;
end

--player id
function Player:setId()
    --id唯一
    Player.super.setId(self);
end

--player类型
function Player:setType()
    --1表示玩家
    self.objType=1;
end
--player数值
function Player:setNumber()
    --血条
    --每次升级后获得等级*2的血量上限
    self.lifNumber=10+self.level*2;
end
--player对象
function Player:setInstantiate(objInstantiate)
    self.objInstantiate=objInstantiate or "error";
    print(self.objInstantiate);
end

------------------------------------------------------------
--构造函数
function Player:ctor()
    Player.super.ctor(self,"player");
end

--初始化
function Player:init(objName,objId,objInstantiate)

    if self.initStates ==1 then
        self.level =1;
        self:setName(objName);
        self:setId(objId);
        self:setType();
        self:setNumber();
        self:setInstantiate(objInstantiate);
        self.experience =0;
        self.initStates=0;
    else
        print("不能重复赋值");
    end

end

---------------------------玩家升级相关逻辑-------------------
--获得经验
--获取经验的时候判断是否升级
function Player:getExperience(experience)
    --先获取经验
    self.experience =self.experience+experience;
    self.experience =self:updateLevel();
end

--升级
function Player:updateLevel()
    --玩家升级所需经验需要当前的两倍
    local restExperience = self.experience % (self.level*2);
    --玩家等级不能超过十级
    if self.level<10 and restExperience >= 1 then
        --升级标准
        --玩家升级时
        --floor 向下取整
        self.level=self.level+math.floor(self.experience/(self.level*2));
        --升级增加血量
        self:setNumber();
        return restExperience
    else
        print("不满足升级条件");
        --不满足升级经验的时候全额返还
        return self.experience
    end
end
-----------------------------------------------------------

--------------------玩家战斗相关----------------------------
function Player:handleCard(mss)
    print("from player:"..mss);
end

-----------------------------------------------------------

---------------------玩家本地存档相关-----------------------

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
---------------------------------------------------------

--
function Player:playerInformation()
    print("Player information is here");
    return 1
end

--
function Player:movePlayer()

end

function Player:usePlayer()

end

function Player:drop()
    Player.super.drop(self);
    print("Player  drop");
end

return Player