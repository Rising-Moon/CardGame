using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowMessage : MonoBehaviour,IMessageListener{
    private MessageQueue messageQueue;
    // Start is called before the first frame update
    void Start(){
        messageQueue = MessageQueueManager.GetMessageQueue();
        messageQueue.RegisteredListener(this);
    }

    public void ClickEvent(){
        Message msg = new Message("TestMessage","Hello World");
        messageQueue.SendMessage(msg);
    }

    public bool Response(Message msg){
        Debug.Log(msg.head + ":   "+msg.msg);
        return false;
    }
}
