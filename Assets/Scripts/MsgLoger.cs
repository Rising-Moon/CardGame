using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MsgLoger : MonoBehaviour,IMessageListener
{
    private void Awake(){
        MessageQueue mq = MessageQueueManager.GetMessageQueue();
        mq.RegisteredListener(this);
    }

    public bool Response(Message msg){
        Debug.Log("Head:" + msg.head + "\nBody:"+msg.msg);
        return false;
    }
}
