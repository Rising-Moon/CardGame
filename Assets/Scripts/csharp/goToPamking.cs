﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using XLuaBehaviour;

public class goToPamking : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        //绑定按钮事件
        this.GetComponent<Button>().onClick.AddListener(OnClick);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnClick()
    {
        print("go to pamking scene");
        //将当前场景入栈
        LuaBehaviour.sceneList.push(SceneManager.GetActiveScene().buildIndex);
        SceneManager.LoadScene(3);
    }
}
