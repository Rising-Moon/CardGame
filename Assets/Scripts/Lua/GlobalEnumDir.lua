----------------------卡牌属性表-------------------
cardInfo ={
    {
        introduction="使用钝器攻击对方，\n造成5点伤害",
        img="Stun_2",
        name="棒击",
        valueMap={
            atk=5
        },
        cost=2,
        cardId=1
    },

    {
        introduction="造成3点伤害",
        img="SIR_12",
        name="割裂",
        valueMap={
            atk=3
        },
        cost=1,
        cardId=2
    },

    {
        introduction="进行防御，产生2点\n防御值",
        img="CoverUp_2",
        name="防御",
        valueMap={
            def=2
        },
        cost=1,
        cardId=3
    },
    {
        introduction="射出两只箭\n造成4点伤害",
        img="SIH_08",
        name="双重箭",
        valueMap={
            mul_atk = 2,
        },
        cost=4,
        cardId=4
    },
    {
        introduction="造成4点伤害",
        img="Lunge_2",
        name="突进",
        valueMap={
            atk = 4,
        },
        cost=4,
        cardId=5
    },
    {
        introduction="警惕两个方向进行的\n攻击，防御值翻倍",
        img="Close_2",
        name="双向防御",
        valueMap={
            mul_def = 2
        },
        cost=3,
        cardId=6
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
        descri ="你将直接获得金钱",
        type =2
    },
    {
        name ="Expr",
        descri ="你将直接获得经验",
        type =3
    }
}