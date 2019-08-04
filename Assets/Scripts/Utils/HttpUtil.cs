﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using UnityEditor;
using UnityEngine;
using UnityEngine.Networking;

public class HttpUtil : MonoBehaviour{
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
            Debug.Log("开始下载: " + url);

            if (www.isHttpError || www.isNetworkError) {
                Debug.LogError(www.error);
                Destroy(this);
            }
            else {
                while (!www.isDone) {
                    //Debug.Log("进度:" + www.downloadProgress);
                }

                if (www.isDone) {
                    Debug.Log("下载内容: " + www.downloadHandler.text);
                    StringBuilder stringBuilder = new StringBuilder();
                    string[] deep = path.Split('/');
                    for (int i = 0; i < deep.Length - 1; i++) {
                        stringBuilder.Append(deep[i] + "/");
                        if (!Directory.Exists(stringBuilder.ToString()))
                            Directory.CreateDirectory(stringBuilder.ToString());
                    }

                    stringBuilder.Append(deep[deep.Length - 1]);
                    if (!File.Exists(stringBuilder.ToString()))
                        File.Create(path).Dispose();
                    File.WriteAllBytes(path, www.downloadHandler.data);
                }
            }
        }
        
        Destroy(gameObject);
        yield break;
    }
}