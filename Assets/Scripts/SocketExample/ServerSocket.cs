using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using UnityEngine;


public class ServerSocket : MonoBehaviour
{
    
    void Start(){
        ServerStart();
    }

    private void ServerStart(){
        try {
            int port = 8082;
            string ip = "10.0.8.193";
            Socket socketWatch = new Socket(AddressFamily.InterNetwork,SocketType.Stream,ProtocolType.Tcp);
            IPAddress ipAddress = IPAddress.Parse(ip);
            IPEndPoint point = new IPEndPoint(ipAddress,port);
            socketWatch.Bind(point);
            Debug.Log("绑定成功!");
            socketWatch.Listen(10);
            
            Thread thread = new Thread(Listen);
            thread.IsBackground = true;
            thread.Start(socketWatch);

        }
        catch (Exception e) {
            Debug.Log(e.Message);
        }
    }

    private Socket socketSend;
    
    void Listen(object o){
        Socket watch = o as Socket;
        while (true) {
            socketSend = watch.Accept();
            Debug.Log("服务端接收到连接！");
            Thread r_thread = new Thread(Recieve);
            r_thread.IsBackground = true;
            r_thread.Start(socketSend);
        }
    }

    void Recieve(object o){
        try {
            Socket socketSend = o as Socket;
            while (true) {
                byte[] buffer = new byte[1024 * 1024 * 3];
                int len = socketSend.Receive(buffer);
                if (len == 0) {
                    break;
                }

                string str = Encoding.UTF8.GetString(buffer, 0, len);
                Debug.Log("Server:" + str);
            }
        }
        catch (Exception e) {
            Debug.Log(e.Message);
        }
    }
}
