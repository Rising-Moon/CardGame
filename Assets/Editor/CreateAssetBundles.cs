using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class CreateAssetBundles
{
    [MenuItem("Assets/Build AssetBundle")]
    static void BuildBundles(){
        string AssetBundleDirectory = Application.streamingAssetsPath + "/AssetBundles";
        if (!Directory.Exists(AssetBundleDirectory))
            Directory.CreateDirectory(AssetBundleDirectory);
        BuildPipeline.BuildAssetBundles(AssetBundleDirectory, BuildAssetBundleOptions.None,
            BuildTarget.StandaloneOSX);
        AssetDatabase.Refresh();
    }

    
}
