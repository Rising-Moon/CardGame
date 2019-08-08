using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveUtil : MonoBehaviour{
    //运动方式
    //匀速
    public static readonly int UNIFORM = 0;
    //减速
    public static readonly int SLOW_DOWN = 1;

    //起始点
    private Vector3 originPoint;
    //目标点
    private Vector3 target = Vector3.zero;
    //速度
    private float speed = 0;
    //移动方式
    private int type = 0;
    //距离
    private float distance = 0;
    //正在移动
    private bool isMove = false;

    private void Start(){
        originPoint = transform.position;
    }

    // Update is called once per frame
    void Update(){
        if (!isMove)
            return;
        Vector3 newPos = Vector3.zero;
        if (type == UNIFORM) {
            if (Vector3.Distance(transform.position, target) <= speed * Time.deltaTime) {
                newPos = target;
                isMove = false;
            }
            else {
                newPos = transform.position + Time.deltaTime * speed * Vector3.Normalize(target - transform.position);
            }
        }
        else if (type == SLOW_DOWN) {
            if (Vector3.Distance(transform.position, target) <= speed * Time.deltaTime/2) {
                newPos = target;
                isMove = false;
            }
            else {
                var speed = this.speed * Vector3.Distance(transform.position, target) / distance;
                newPos = transform.position + Time.deltaTime * speed * Vector3.Normalize(target - transform.position);
            }
        }
        Debug.Log(transform.position + ";" + newPos + ";" + target);
        transform.position = newPos;
    }

    public void SmoothMoveBack(float speed,int type){
        SmoothMove(originPoint,speed,type);
    }

    public void SmoothMove(Vector3 target, float speed){
        SmoothMove(target, speed, UNIFORM);
    }

    public void SmoothMove(Vector3 target, float speed, int type){
        this.target = target;
        this.speed = speed;
        this.type = type;
        distance = Vector3.Distance(transform.position, target);
        isMove = true;
    }
}