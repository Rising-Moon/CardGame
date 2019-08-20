using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Security.Cryptography;
using System.Text;
using UnityEditor;
using UnityEngine;
using UnityEngine.Networking;

public class DownloadUtil : MonoBehaviour{

    //调用时创建一个实例
    public static void Download(string url, string path){
        GameObject downLoadObject = new GameObject("download");
        downLoadObject.AddComponent(typeof(Item));
        DontDestroyOnLoad(downLoadObject);
        Item item = downLoadObject.GetComponent<Item>();
        item.url = url;
        item.path = path;
        DownloadManager.addDownload(item);
        item.StartDownload();
    }

    public class Item : MonoBehaviour{
        public string url;
        public string path;
        private bool done = false;
        
        public void StartDownload(){
            StartCoroutine("Get");
        }
        
        //协程下载
        private IEnumerator Get(){
            yield return null;
            using (UnityWebRequest www = UnityWebRequest.Get(url)) {
                www.SendWebRequest();
                if (www.isHttpError || www.isNetworkError) {
                    Debug.LogError(www.error);
                    gameObject.SetActive(false);
                    DownloadManager.removeDownload(this);
                    print(DownloadManager.Count());
                    done = true;
                }
                else {
                    while (!www.isDone) {
                        yield return null;
                        //Debug.Log("进度:" + www.downloadProgress);
                    }

                    if (www.isDone) {
                        StringBuilder stringBuilder = new StringBuilder();
                        string[] deep = path.Split('/');
                        for (int i = 0; i < deep.Length - 1; i++) {
                            stringBuilder.Append(deep[i] + "/");
                            if (!Directory.Exists(stringBuilder.ToString()))
                                Directory.CreateDirectory(stringBuilder.ToString());
                        }
                        stringBuilder.Append(deep[deep.Length - 1]);
                        
                        if (www.downloadHandler.data.Length == 0) {
                            Debug.Log(www.url + "\n下载失败，下载文件为空");
                            yield break;
                        }
                        if (!File.Exists(stringBuilder.ToString()))
                            File.Create(path).Dispose();
                        File.WriteAllBytes(path, www.downloadHandler.data);
                        Debug.Log("下载完成:" + path);
                        
                        print(DownloadManager.Count());
                        DownloadManager.removeDownload(this);
                    }
                }
            }
            
            DownloadManager.removeDownload(this);
            print(DownloadManager.Count());
            gameObject.SetActive(false);
            done = true;
        }
        
        

        public bool isDone(){
            return done;
        }
    }
}