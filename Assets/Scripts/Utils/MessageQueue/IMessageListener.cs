using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IMessageListener{
    bool Response(Message msg);
}
