using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

public static class LuaCallCS{
    [LuaCallCSharp]
    public static List<Type> lua_call_cs_list = new List<Type>() {
        typeof(GameObject),
        typeof(Vector3)
    };
}
