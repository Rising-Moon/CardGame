using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpdateUtil{
    private string updateItems;
    private string targetUrl = "//" + Config.Get("server_ip") + ":" + "25563" + "/";

    public UpdateUtil(string updateItems){
        this.updateItems = updateItems;
    }
    public void Update(){
        string[] items = updateItems.Split('\n');
        foreach (var item in items) {
            string[] infos = item.Split(':');
            DownloadUtil.Download(targetUrl + infos[1] + infos[0], infos[2] + infos[0]);
        }
    }
}
