using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.Collections.LowLevel.Unsafe;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class TestScript : MonoBehaviour{
    public GameObject image;

    // Start is called before the first frame update
    void Start(){
    }

    // Update is called once per frame
    void Update(){
        if (Input.GetKeyDown("d")) {
            Destroy(gameObject);
            
        }
    }
}