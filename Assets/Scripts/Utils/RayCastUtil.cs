using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RayCastUtil{
    public static GameObject RayCastObject2D(Ray ray){
        RaycastHit2D hit = Physics2D.Raycast(Camera.main.ScreenToWorldPoint(Input.mousePosition), Vector2.zero);
        if (hit.collider != null) {
            return hit.collider.gameObject;
        }
        return null;
    }
}