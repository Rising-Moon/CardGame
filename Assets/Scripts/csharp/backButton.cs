using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using XLuaBehaviour;
public class backButton : MonoBehaviour
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
        print("back to last scene");
        //LuaBehaviour.sceneList.push(1);
        //加载上一个场景
        int index = LuaBehaviour.sceneList.pop();
        if(index != 0)
            SceneManager.LoadScene(index);
        else
        {
            print("不能回到场景0");
        }
    }
}
