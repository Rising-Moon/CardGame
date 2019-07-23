using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;

//消息列表类
public class MessageQueue : MonoBehaviour
{

    //是否在转发
    private bool isForward = false;

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
    public bool SendMessage(Message msg){
        mMessageQueue.Enqueue(msg);
        //如果协程未运行，则运行协程转发数据
        if (isForward == false) {
            isForward = true;
            StartCoroutine("SendAllMessageInQueue");
        }

        //调试
        //foreach (var message in mMessageQueue) {
        //    Debug.Log(message.head + ": " + message.msg);
        //}

        return true;
    }
    
    //销毁消息列表
    public void OnDestroy(){
        StopCoroutine("SendAllMessageInQueue");
    }
    
    //消息列表发出消息（协程）
    //使用协程为避免某个消息监听者进行耗时操作造成阻塞时新消息无法进入队列
    private IEnumerator SendAllMessageInQueue(){
        //Debug.Log(mMessageQueue.Count);
        while (mMessageQueue.Count != 0) {
            for(int i = 0;i < mListeners.Count;i++) {
                if (mListeners[i] != null && mListeners[i].Response(mMessageQueue.Peek())) {
                        mMessageQueue.Dequeue();
                        i = 0; 
                }
                yield return 0;
            }

            mMessageQueue.Dequeue();
        }

        isForward = false;
    }
}
