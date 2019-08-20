using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class DownloadManager{
    private static List<DownloadUtil.Item> downloads;

    static DownloadManager(){
        downloads = new List<DownloadUtil.Item>();
    }

    //添加新的下载
    public static void addDownload(DownloadUtil.Item download){
        downloads.Add(download);
    }
    
    //删除现有下载
    public static void removeDownload(DownloadUtil.Item download){
        downloads.Remove(download);
    }
    
    //是否下载完成
    public static bool isDone(){
        return downloads.Count == 0;
    }
    
    //未完成数量
    public static int Count(){
        return downloads.Count;
    }
}