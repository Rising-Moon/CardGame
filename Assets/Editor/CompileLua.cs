using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;

public class CompileLua{
    private static string luaPath = Application.dataPath + "/Scripts/Lua";
    private static string outPath = Application.dataPath + "/Scripts/Lua/out";
    
    /***
     * 将lua文件改为bytes文件生成在同级目录下的out文件夹中
     */
    [MenuItem("Assets/Compile Lua", false, 2)]
    public static void Compile(){
        
        if (!Directory.Exists(outPath))
            Directory.CreateDirectory(outPath);
        
        Queue<string> directories = new Queue<string>();
        directories.Enqueue(luaPath);
        //遍历所有子文件夹
        while (directories.Count != 0) {
            string current = directories.Dequeue();
            CompileAllLuaFile(current);
            Directory.GetDirectories(current).ToList().ForEach(i => directories.Enqueue(i));
        }
        
        Directory.GetDirectories(luaPath).ToList().ForEach(i => Debug.Log(i));
        
        Debug.Log("Compile Lua:编译完成");
        AssetDatabase.Refresh();
    }

    private static void CompileAllLuaFile(string directory){
        List<string> luaFiles = Directory.GetFiles(directory).Where(i => i.EndsWith(".lua")).ToList();
        luaFiles.ForEach(i => {
            string path = i.Replace(directory, outPath) + ".bytes";
            if (!File.Exists(path))
                File.Create(path).Dispose();
            byte[] content = File.ReadAllBytes(i);
            File.WriteAllBytes(path,content);
        });
    }
}