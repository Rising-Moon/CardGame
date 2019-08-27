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
    public static void AddDownload(DownloadUtil.Item download){
        downloads.Add(download);
    }

    //删除现有下载
    public static void FinishDownload(DownloadUtil.Item download){
        downloads.Remove(download);
        finish.Enqueue(download);
    }

    //是否下载完成
    public static bool IsDone(){
        return downloads.Count == 0;
    }

    //进度
    public static float GetProgress(){
        return finish.Count / (downloads.Count + finish.Count);
    }
    
    //将完成列表清空
    public static void Clear(){
        finish.Clear();
    }
}