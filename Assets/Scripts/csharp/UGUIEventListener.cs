using System;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Events;

public class UGUIEventListener : EventTrigger
{
    public UnityAction<GameObject> onClick;
/*    public UnityAction<GameObject> OnMouseEnter;*/

    //可以重载EventTrigger的其他虚方法来实现点击拖动等事件
    public override void OnPointerClick(PointerEventData eventData)
    {
        base.OnPointerClick(eventData);

        if(onClick != null)
        {
            onClick(gameObject);
        }
        
    }
    

    /*public void OnPointEnter(PointerEventData eventData)
    {
        base.OnPointerEnter(eventData);
        if (OnMouseEnter != null)
        {
            OnMouseEnter(gameObject);
        }
    }*/

    public static UGUIEventListener Get(GameObject go)
    {
        UGUIEventListener listener = go.GetComponent<UGUIEventListener>();

        if (!listener)
            listener = go.AddComponent<UGUIEventListener>();

        return listener;
    }
}