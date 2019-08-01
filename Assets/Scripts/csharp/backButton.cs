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
        this.GetComponent<Button>().onClick.AddListener(OnClick);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnClick()
    {
        print("run");
        //LuaBehaviour.sceneList.push(1);
        SceneManager.LoadScene(LuaBehaviour.sceneList.pop());
    }
}
