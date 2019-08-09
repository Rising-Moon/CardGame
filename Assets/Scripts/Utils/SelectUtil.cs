using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using Object = System.Object;

[LuaCallCSharp]
public class SelectUtil{
    //获取射线碰撞的物体
    public static GameObject RayCastObject2D(Ray ray){
        RaycastHit2D hit = Physics2D.Raycast(Camera.main.ScreenToWorldPoint(Input.mousePosition), Vector2.zero);
        if (!ReferenceEquals(hit.collider,null)) {
            return hit.collider.gameObject;
        }
        return null;
    }

    //获取某点处的最前方物体
    public static GameObject ObjectOnPoint(Vector2 point){
        Collider2D[] cols = Physics2D.OverlapPointAll(point);
        int sibing = 0;
        GameObject select = null;
        foreach (var c in cols) {
            if (ReferenceEquals(select, null)) {
                select = c.gameObject;
                sibing = select.transform.GetSiblingIndex();
            }

            int currenSibing = c.transform.GetSiblingIndex();
            if (currenSibing > sibing) {
                sibing = currenSibing;
                select = c.gameObject;
            }
        }

        return select;
    }
    
    //获取鼠标位置的物体
    public static GameObject ObjectOnMouse(){
        return ObjectOnPoint(Camera.main.ScreenToWorldPoint(Input.mousePosition));
    }
}