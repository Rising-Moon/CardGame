using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MessageQueueManager{
    private static MessageQueue instance = null;

    //私有化构造方法，禁止实例化
    private MessageQueueManager(){}

    //获取消息列表
    public static MessageQueue GetMessageQueue(){
        if (instance == null) {
            //将消息列表挂载在一个GameObject上来实现同步（伪线程）
            GameObject msgQueue = new GameObject("MessageQueue");
            msgQueue.AddComponent(typeof(MessageQueue));
            instance = msgQueue.GetComponent<MessageQueue>();
            MonoBehaviour.DontDestroyOnLoad(instance);
        }

        return instance;
    }
}
