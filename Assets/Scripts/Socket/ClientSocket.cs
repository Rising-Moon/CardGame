using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using UnityEngine;
using XLua;

public class ClientSocket : MonoBehaviour, IMessageListener{
    private void Awake(){
        MessageQueueManager.GetMessageQueue().RegisteredListener(this);
        DontDestroyOnLoad(gameObject); 
    }

    void Start(){
        ConnectSocket();
    }

    private Socket socketSend;

    private void ConnectSocket(){
        try {
            int port = Int32.Parse(Config.Get("port"));
            string _ip = Config.Get("server_ip");

            socketSend = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            IPAddress ip = IPAddress.Parse(_ip);
            IPEndPoint point = new IPEndPoint(ip, port);
            socketSend.Connect(point);
            Debug.Log("服务器连接成功!");
            Thread c_thread = new Thread(Recieve);
            c_thread.IsBackground = true;
            c_thread.Start();
        }
        catch (Exception e) {
            Debug.LogError(e.Message);
        }
    }

    //消息接收线程
    void Recieve(){
        Queue<byte> byteQueue = new Queue<byte>();
        while (socketSend != null && socketSend.Connected) {
            
            try {
                byte[] buffer = new byte[1024 * 1024 * 3];
                int len = 1;
                int packLen = 0;
                
                if (len == 0 || !socketSend.Connected || socketSend == null) {
                    break;
                }

                /**
                * 读取流存入缓冲队列，当读取pack的长度为0时读取前两个byte作为packLen的值，
                * 当pack长度不为0时对比缓冲队列长度，长度足够时读出一个pack，将读取长度清0，
                * 不足时继续等待数据进入缓冲队列。
                */
                while (len != -1) {
                    len = socketSend.Receive(buffer);
                    //Debug:原始数据输出
                    //StringBuilder builder = new StringBuilder();
                    //for (int i = 0; i < len; i++) {
                    //    builder.Append(buffer[i] + " ");
                    //}
                    //Debug.Log("原始数据："+builder);
                    
                    //将数据存入缓冲队列
                    for (int i = 0; i < len; i++) {
                        byteQueue.Enqueue(buffer[i]);
                    }

                    if (packLen == 0) {
                        if (byteQueue.Count >= 2) {
                            packLen += (byteQueue.Dequeue() << 8);
                            packLen += byteQueue.Dequeue();
                        }
                        else {
                            break;
                        }
                    }
                    if(byteQueue.Count < packLen)
                        break;
                    //根据长度获取包
                    byte[] pack = new byte[packLen];
                    for (int i = 0; i < packLen; i++) {
                        pack[i] = byteQueue.Dequeue();
                    }

                    packLen = 0;
                    
                    //添加到消息列表
                    MessageQueueManager.GetMessageQueue()
                        .SendMessage(new Message.ByteMessage(Message.MessageType.SocketResponse, pack));
                    
                    //Debug:拆包后消息
                    MessageQueueManager.GetMessageQueue().SendMessage(new Message(Message.MessageType.Debug, "包数据:"+Encoding.UTF8.GetString(pack)));
                }
                
            }
            catch (Exception e) {
                MessageQueueManager.GetMessageQueue().SendMessage(new Message(Message.MessageType.Debug, e.Message));
                break;
            }
            
        }
    }

    [LuaCallCSharp]
    public void Send(string str){
        if (!socketSend.Connected || socketSend == null) {
            Debug.LogError("Socket连接未建立");
            return;
        }
        try {
            //添加2字节的消息头用于存储消息长度
            string msg = str;
            byte[] buffer = new byte[msg.Length + 2];
            byte[] encode = Encoding.UTF8.GetBytes(msg);
            Array.Copy(encode, 0, buffer, 2,encode.Length);
            buffer[1] = (byte) encode.Length;
            buffer[0] = (byte) (encode.Length >> 8);
            socketSend.Send(buffer);
        }
        catch (Exception e) {
            MessageQueueManager.GetMessageQueue().SendMessage(new Message(Message.MessageType.Debug, e.Message));
        }
    }

    [LuaCallCSharp]
    public void Send(byte[] bytes){
        if (!socketSend.Connected || socketSend == null) {
            Debug.LogError("Socket连接未建立");
            return;
        }
        //添加2字节的消息头用于存储消息长度
        byte[] pack = new byte[bytes.Length + 2];
        pack[1] = (byte) bytes.Length;
        pack[0] = (byte) (bytes.Length >> 8);
        Array.Copy(bytes, 0, pack, 2, bytes.Length);
        try {
            socketSend.Send(pack);
        }
        catch (Exception e) {
            MessageQueueManager.GetMessageQueue().SendMessage(new Message(Message.MessageType.Debug, e.Message));
        }
    }

    void OnDestroy(){
        string closeMsg = "exit()";
        Send(closeMsg);
        if (socketSend != null && socketSend.Connected) {
            socketSend.Close();
            socketSend = null;
        }
    }

    //接收消息传输给服务器
    public bool Response(Message msg){
        if (msg.head == Message.MessageType.SocketToServer) {
            if (msg is Message.ByteMessage) {
                Message.ByteMessage bm = msg as Message.ByteMessage;
                Send(bm.msg);
            }
            else {
                Send(msg.msg);
            }

            return true;
        }
        return false;
    }
}