--抽卡的时候指定的card的实例话属性
--由于测试预制体数量较少，将healthbar也加上，后期删除
CardPrefabsPathDir={
    {name ="Card",ResourcesPath ="Assets/Resources/Prefabs/Card.prefab",AssetBundlePath="Assets/StreamingAssets/AssetBundles/Card.pre"},
    {name ="HealthBar",ResourcesPath ="Assets/Resources/Prefabs/HealthBar.prefab"}
}

CardImageDir={
    {name ="Close_2"},
    {name ="Pikes_2"},
    {name ="Lunge_2"},
    {name ="Jeer_2"},
    {name ="Adrenalin_2"},
    {name ="SIH_01"},
    {name ="SIH_02"},
    {name ="SIH_07"},
    {name ="ToFace_2"}

}

----------------------卡牌属性表-------------------
--卡牌类型
global.typeDir ={
    fight = 1;
    defense = 2;
    treatment = 3;
    effect = 4;
};

--卡牌描述
global.nameDictionary = {
    fire =" this is fire card , use to fight",
    water ="this is water card, use to fight",
    wind ="this is wind card,use to fight"
};

---------------------怪物属性表------------------