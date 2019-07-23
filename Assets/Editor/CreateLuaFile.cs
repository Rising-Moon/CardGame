using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class CreateLuaFile
{
    [MenuItem("Assets/Create Lua File",false,1)]
    static void Createluafile(){
        string path = GetSelectedPathOrFallback();
        File.Create(path + "/luaFile.lua.txt");
        AssetDatabase.Refresh();
    }
    
    public static string GetSelectedPathOrFallback()
    {
        string path = "Assets";
        foreach (UnityEngine.Object obj in Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.Assets))
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
