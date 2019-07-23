﻿using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;

public class CreateAssetBundles
{
    [MenuItem("Assets/Build AssetBundle")]
    static void BuildBundles(){
        string AssetBundleDirectory = "Assets/AssetBundles";
        if (!Directory.Exists(AssetBundleDirectory))
            Directory.CreateDirectory(AssetBundleDirectory);
        BuildPipeline.BuildAssetBundles(AssetBundleDirectory, BuildAssetBundleOptions.None,
            BuildTarget.StandaloneOSX);
        AssetDatabase.Refresh();
    }

    
}
