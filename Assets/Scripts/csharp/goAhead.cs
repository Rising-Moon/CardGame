using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using XLuaBehaviour;

public class goAhead : MonoBehaviour
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
          print("go to next scene");
          //将当前场景入栈
          int index = SceneManager.GetActiveScene().buildIndex;
          if(index != 0) 
              LuaBehaviour.sceneList.push(index);
          else
          {
              print("场景0 不能进栈 ");
          }
          SceneManager.LoadScene(index+1);
    }
}
