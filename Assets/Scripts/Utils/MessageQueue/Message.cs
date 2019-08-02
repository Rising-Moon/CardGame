using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

//消息类
public class Message{
    public Message.MessageType head;
    public string msg;

    public enum MessageType{
        TestMessage,SocketToServer,SocketResponse,SocketLuaPack,Debug
    }

    public Message(MessageType head, string msg){
        this.head = head;
        this.msg = msg;
    }

    public class ByteMessage : Message{
        public byte[] msg;
        public ByteMessage(MessageType head, byte[] bytes) : base(head, bytes.ToString()){
            this.head = head;
            StringBuilder builder = new StringBuilder();
            foreach (var b in bytes) {
                builder.Append(b.ToString()+ " ");
            }

            base.msg = builder.ToString();
            this.msg = bytes;
        }
    }
}
