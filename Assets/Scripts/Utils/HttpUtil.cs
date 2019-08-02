using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Net;
using UnityEngine;
using UnityEngine.Networking;

public class HttpUtil : MonoBehaviour{
    protected UnityWebRequest www;
    protected string url;
    protected string path;

    public static void Download(string url, string path){
        GameObject downLoadObject = new GameObject("download");
        downLoadObject.AddComponent(typeof(HttpUtil));
        DontDestroyOnLoad(downLoadObject);
        HttpUtil httpUtil = downLoadObject.GetComponent<HttpUtil>();
        httpUtil.url = url;
        httpUtil.path = path;
        httpUtil.StartDownload();
    }

    protected void StartDownload(){
        StartCoroutine("Get");
    }

    private IEnumerator Get(){
        using (UnityWebRequest www = UnityWebRequest.Get(url)) {
            www.SendWebRequest();
            Debug.Log("开始下载");
            
            while (!www.isDone) {
                Debug.Log("进度:" + www.downloadProgress);
            }

            if (www.isDone) {
                Debug.Log("下载完成");
                File.WriteAllBytes(path, www.downloadHandler.data);
            }

            if (www.isHttpError || www.isNetworkError) {
                Debug.LogError(www.error);
            }
        }

        Destroy(this);
        yield break;
    }
}