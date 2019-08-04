using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Object = System.Object;

public class MsgLoger : MonoBehaviour, IMessageListener{
    private void Awake(){
        MessageQueue mq = MessageQueueManager.GetMessageQueue();
        mq.RegisteredListener(this);
    }

    public bool Response(Message msg){
        if (msg.head == Message.MessageType.Debug)
            Debug.Log("DEBUG :" + msg.msg);
        return false;
    }
}