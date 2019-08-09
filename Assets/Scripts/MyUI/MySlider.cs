using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MySlider : Slider{

    [SerializeField]
    public class HealthInfo{
        public int maxHealth;
    }
    
    
    
    public Text textValue;
    public HealthInfo healthInfo;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update(){
        string value = base.value * healthInfo.maxHealth + "/" + healthInfo.maxHealth;
        textValue.text = value;
    }
}
