using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using UnityEngine;
using XLua;

public static class Config{
    public static Dictionary<string, string> configList = null;
    private static string filePath = Application.dataPath+"/config.json";

    //从配置文件中读取配置
    static Config(){
        configList = new Dictionary<string, string>();
        Load();

        //调试
        //foreach (var pair in configList) {
        //    Debug.Log(pair.Key + ":" + pair.Value);
        //}
    }

    //存储配置文件
    public static void Save(){
        Format format = new Format();
        format.keys = configList.Keys.Select(p => p.ToString()).ToArray();
        format.values = configList.Values.Select(p => p.ToString()).ToArray();
        string json = JsonUtility.ToJson(format);
        File.WriteAllText(filePath,json);
    }

    //读取配置文件
    private static void Load(){
        if (!File.Exists(filePath)) {
            Debug.LogError("配置文件不存在");
            File.Create(filePath);
            return;
        }

        string jsonText = File.ReadAllText(filePath);

        Format format = JsonUtility.FromJson<Format>(jsonText);

        for (int i = 0; i < format.keys.Length; i++) {
            configList.Add(format.keys[i],format.values[i]);
        }
    }
    
    [LuaCallCSharp]
    public static string Get(string key){
        return configList[key];
    }

    private class Format{
        public string[] keys;
        public string[] values;
    }
}