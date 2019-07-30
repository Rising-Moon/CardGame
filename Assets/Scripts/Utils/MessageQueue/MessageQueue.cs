using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

//消息列表类
public class MessageQueue : MonoBehaviour{

    //消息列表
    //列表形式为大量消息提供缓冲
    private Queue<Message> mMessageQueue = new Queue<Message>();

    //监听列表
    private List<IMessageListener> mListeners = new List<IMessageListener>();

    //注册监听
    public void RegisteredListener(IMessageListener listener){
        mListeners.Add(listener);
    }

    //移除监听
    public void RemoveListener(IMessageListener listener){
        mListeners.Remove(listener);
    }

    //发送消息
    [LuaCallCSharp]
    public bool SendMessage(Message msg){
        mMessageQueue.Enqueue(msg);

        //调试
        //foreach (var message in mMessageQueue) {
        //    Debug.Log(message.head + ": " + message.msg);
        //}

        return true;
    }

    private void Update(){
        if (mMessageQueue.Count != 0) {
            for (int i = 0; i < mListeners.Count; i++) {
                if (mListeners[i] != null && mListeners[i].Response(mMessageQueue.Peek())) {
                    break;
                }
            }
            mMessageQueue.Dequeue();
        }
    }
}