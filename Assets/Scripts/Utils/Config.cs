using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;

public static class Config{
    public static Dictionary<string, string> configList;

    //从配置文件中读取配置
    static Config(){
        configList = new Dictionary<string, string>();
        
        string filePath = "Assets/config.txt";
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

        //foreach (KeyValuePair<string,string> pair in configList) {
        //    Debug.Log("key: " + pair.Key + " value: " + pair.Value);
        //}
    }
}