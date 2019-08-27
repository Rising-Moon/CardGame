using System;
using System.Collections.Generic;
using UnityEngine;
using XLua;

public class XLuaBlackList{
    [BlackList] public static List<Type> BlackList = new List<Type>() {
        typeof(Light)
    };
}