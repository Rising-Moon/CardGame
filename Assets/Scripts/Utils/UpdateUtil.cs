using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpdateUtil{
    private static string targetUrl = "localhost:8081/";
    public static void Update(string updateItem){
        string[] items = updateItem.Split('\n');
        foreach (var item in items) {
            Debug.Log(item);
            string[] infos = item.Split(':');
            foreach (var info in infos) {
                Debug.Log(info);
            }
            DownloadManager.Download(targetUrl + infos[1] + infos[0],infos[2] + infos[0]);
        }
    }
}
