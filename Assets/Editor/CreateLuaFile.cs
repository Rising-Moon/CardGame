using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class CreateLuaFile
{
    [MenuItem("Assets/Create/Lua File",false,1)]
    static void Createluafile(){
        string path = GetSelectedPathOrFallback();
        File.Create(path + "/luaFile.lua");
        AssetDatabase.Refresh();

        var asset = AssetDatabase.LoadAssetAtPath(path + "/luaFile.lua", typeof(Object));
        Selection.activeObject = asset;
    }
    
    public static string GetSelectedPathOrFallback()
    {
        string path = "Assets";
        foreach (Object obj in Selection.GetFiltered(typeof(Object), SelectionMode.Assets))
        {
            path = AssetDatabase.GetAssetPath(obj);
            if (!string.IsNullOrEmpty(path) && File.Exists(path))
            {
                path = Path.GetDirectoryName(path);
                break;
            }
        }
        return path;
    }
    
}
