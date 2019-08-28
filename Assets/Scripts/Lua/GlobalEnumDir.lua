----------------------卡牌属性表-------------------
cardInfo ={
    {
        introduction="造成8点伤害，给予2层流血",
        img="SIR_07",
        name="背刺",
        valueMap={
            atk=8,
            bleed=2
        },
        cost=2,
        cardId=1,
        level =1
    },

    {
        introduction="造成6点伤害",
        img="SIR_12",
        name="割裂",
        valueMap={
            atk=6
        },
        cost=1,
        cardId=2,
        level =1
    },

    {
        introduction="进行防御，产生5点\n防御值",
        img="CoverUp_2",
        name="防御",
        valueMap={
            def=5
        },
        cost=1,
        cardId=3,
        level =1
    },
    {
        introduction="将你当前的防御值翻倍",
        img="Close_2",
        name="巩固",
        valueMap={
            mul_atk = 2,
        },
        cost=2,
        cardId=4,
        level =1
    },
    {
        introduction="造成你当前护盾值的伤害",
        img="ToFace_2",
        name="盾击",
        valueMap={
            atk_def=1
        },
        cost=1,
        cardId=5,
        level =1
    },
    {
        introduction="使对方失去3点力量",
        img="Unarmed_2",
        name="缴械",
        valueMap={
            pow=-3
        },
        cost=2,
        cardId=6,
        level =1
    }

}


---------------------事件属性表------------------
EventDir={
    {
        name ="战斗",
        picName ="PacKForest01_6",
        descri="你通过战斗来获得奖赏",
        type =1
    },
    {
        name ="money",
        descri ="你将直接获得金钱：",
        type =2
    },
    {
        name ="Expr",
        descri ="你将直接获得经验：",
        type =3
    },
    {
        name ="Expr",
        descri ="你将获得三次经验加成",
        type =4
    },
    {
        name ="Money",
        descri ="你将获得三次金币加成",
        type =5
    },
    {
        name ="update",
        descri ="你将随机升级一张卡牌",
        type =6
    }
}
-----------------------------------------------