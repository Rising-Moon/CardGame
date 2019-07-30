using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using UnityEngine;

public class ClientSocket : MonoBehaviour, IMessageListener{
    private void Awake(){
        MessageQueueManager.GetMessageQueue().RegisteredListener(this);
    }

    void Start(){
        ConnectSocket();
    }

    private Socket socketSend;

    private void ConnectSocket(){
        try {
            int port = Int32.Parse(Config.configList["port"]);
            string _ip = Config.configList["server_ip"];

            socketSend = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            IPAddress ip = IPAddress.Parse(_ip);
            IPEndPoint point = new IPEndPoint(ip, port);
            socketSend.Connect(point);
            Debug.Log("客户端连接成功!");
            Thread c_thread = new Thread(Recieve);
            c_thread.IsBackground = true;
            c_thread.Start();
        }
        catch (Exception e) {
            Debug.LogError(e.Message);
        }
    }

    void Recieve(){
        while (socketSend.Connected && socketSend != null) {
            
            try {
                byte[] buffer = new byte[1024 * 1024 * 3];
                int len = socketSend.Receive(buffer);
                if (len == 0 || !socketSend.Connected || socketSend == null) {
                    break;
                }
                MessageQueueManager.GetMessageQueue()
                    .SendMessage(new Message.ByteMessage(Message.MessageType.SocketResponse, buffer));
                string str = Encoding.UTF8.GetString(buffer, 0, len);
                Debug.Log("Client:" + str);
            }
            catch (Exception e) {
                Debug.LogError(e.Message);
                break;
            }
            
        }
    }

    private void Send(string str){
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
            Debug.Log(e.Message);
        }
    }

    private void Send(byte[] bytes){
        //添加2字节的消息头用于存储消息长度
        byte[] pack = new byte[bytes.Length + 2];
        pack[1] = (byte) bytes.Length;
        pack[0] = (byte) (bytes.Length >> 8);
        Array.Copy(bytes, 0, pack, 2, bytes.Length);
        try {
            socketSend.Send(pack);
        }
        catch (Exception e) {
            Debug.Log(e.Message);
        }
    }

    void OnDestroy(){
        string closeMsg = "exit()";
        Send(closeMsg);
        if (socketSend != null && socketSend.Connected)
            socketSend.Close();
    }

    //接收消息传输给服务器
    public bool Response(Message msg){
        if (msg.head == Message.MessageType.SocketToServer) {
            if (!socketSend.Connected || socketSend == null) {
                Debug.LogError("Socket连接未建立");
                return false;
            }
            if (msg is Message.ByteMessage) {
                Message.ByteMessage bm = msg as Message.ByteMessage;
                Send(bm.msg);
            }

            return true;
        }
        return false;
    }
}