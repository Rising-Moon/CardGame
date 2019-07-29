using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using UnityEngine;
using Object = System.Object;

public class ClientSocket : MonoBehaviour
{
    // Start is called before the first frame update
    void Start(){
        ConnectSocket();
    }

    private Socket socketSend;
    private void ConnectSocket(){
        try {
            int port = 8082;
            string _ip = "127.0.0.1";
            
            socketSend = new Socket(AddressFamily.InterNetwork,SocketType.Stream,ProtocolType.Tcp);
            IPAddress ip = IPAddress.Parse(_ip);
            IPEndPoint point = new IPEndPoint(ip,port);
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

    private void Recieve(){
        while (true) {
            try {
                byte[] buffer = new byte[1024 * 1024 * 3];
                int len = socketSend.Receive(buffer);
                if (len == 0) {
                    break;
                }

                string str = Encoding.UTF8.GetString(buffer, 0, len);
                Debug.Log("Client:" + str);
                
            }
            catch (Exception e) {
                Debug.Log(e.Message);
            }
        }
    }
    
    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.S)) {
            Debug.Log("发送消息");
            string str = "Hello";
            Send(str);
        }
    }

    private void Send(string str){
        try {
            string msg = str;
            byte[] buffer = new byte[1024 * 1024 * 3];
            buffer = Encoding.UTF8.GetBytes(msg);
            socketSend.Send(buffer);
        }
        catch (Exception e) {
            Debug.Log(e.Message);
        }
    }
    
    void OnDestroy(){
        string closeMsg = "exit()";
        Send(closeMsg);
        socketSend.Close();
    }
}
