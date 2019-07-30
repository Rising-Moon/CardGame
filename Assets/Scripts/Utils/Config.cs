using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;

public static class Config{
    public static Dictionary<string, string> configList;
    private static string filePath = "Assets/config.txt";

    //从配置文件中读取配置
    static Config(){
        configList = new Dictionary<string, string>();
        if (!File.Exists(filePath)) {
            Debug.LogError("配置文件不存在");
            File.Create(filePath);
            return;
        }

        string[] lines = File.ReadAllLines(filePath);
        foreach (string line in lines) {
            if(line.StartsWith("//"))
                continue;
            string[] pair = line.Split('=');
            configList.Add(pair[0],pair[1]);
        }
    }
}