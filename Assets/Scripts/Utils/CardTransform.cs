using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CardTransform : MonoBehaviour{
    public GameObject lookAtPoint;
    public Vector3 offset;

    private void FixedUpdate(){
        if (transform.position.x != lookAtPoint.transform.position.x) {
            transform.LookAt(lookAtPoint.transform.position);
            if (transform.position.x < lookAtPoint.transform.position.x)
                transform.Rotate(new Vector3(0, -90, 90));
            else {
                transform.Rotate(new Vector3(180, -90, 90));
            }
        }
    }
}