using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;

public static class DownloadManager{
    private static List<DownloadUtil.Item> downloads;
    private static Queue<DownloadUtil.Item> finish;

    static DownloadManager(){
        downloads = new List<DownloadUtil.Item>();
        finish = new Queue<DownloadUtil.Item>();
    }

    //添加新的下载
    public static void addDownload(DownloadUtil.Item download){
        downloads.Add(download);
    }

    //删除现有下载
    public static void finishDownload(DownloadUtil.Item download){
        downloads.Remove(download);
        finish.Enqueue(download);
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