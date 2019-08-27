using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;
using UnityEngine.UI;
using XLua;

public class MoveUtil : MonoBehaviour{
    //回调
    private Action callBack = null;

    ////
    /// 移动
    ////

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

    ////
    /// 变化
    ////

    //目标大小
    private Vector3 targetScale = Vector3.one;

    //当前大小
    private Vector3 originScale = Vector3.one;

    //使用时间
    private float resizeTime = 1f;

    //插值系数
    private float resizeIt = 0f;

    //正在变化
    private bool isResize = false;

    ////
    /// 旋转
    ////

    //目标角度
    private Quaternion targetAngle = Quaternion.identity;

    //当前角度
    private Quaternion originAngle = Quaternion.identity;

    //使用时间
    private float rotateTime = 1f;

    //插值系数
    private float rotateIt = 0f;

    //正在旋转
    private bool isRotate = false;


    private void Start(){
        originPoint = transform.position;
    }

    // Update is called once per frame
    void Update(){
        if (isMove) {
            Vector3 newPos = Vector3.zero;
            if (type == UNIFORM) {
                if (Vector3.Distance(transform.position, target) <= speed * Time.deltaTime) {
                    newPos = target;
                    isMove = false;
                    if (callBack != null) {
                        callBack();
                        callBack = null;
                    }
                }
                else {
                    newPos = transform.position +
                             Time.deltaTime * speed * Vector3.Normalize(target - transform.position);
                }
            }
            else if (type == SLOW_DOWN) {
                if (Vector3.Distance(transform.position, target) <= speed * Time.deltaTime / 2) {
                    newPos = target;
                    isMove = false;
                    if (callBack != null) {
                        callBack();
                        callBack = null;
                    }
                }
                else {
                    var speed = this.speed * Vector3.Distance(transform.position, target) / distance;
                    newPos = transform.position +
                             Time.deltaTime * speed * Vector3.Normalize(target - transform.position);
                }
            }

            transform.position = newPos;
        }

        if (isResize) {
            resizeIt += Time.deltaTime / resizeTime;
            Vector3 newSize = Vector3.Lerp(originScale, targetScale, resizeIt);
            transform.localScale = newSize;
            if (resizeIt >= 1) {
                resizeIt = 0;
                isResize = false;
            }
        }

        if (isRotate) {
            rotateIt += Time.deltaTime / rotateTime;
            Quaternion newRotation = Quaternion.Lerp(originAngle, targetAngle, rotateIt);
            transform.rotation = newRotation;
            if (rotateIt >= 1) {
                rotateIt = 0;
                isRotate = false;
            }
        }
    }

    [LuaCallCSharp]
    public void SetOriginPoint(Vector3 point){
        originPoint = point;
    }

    [LuaCallCSharp]
    public void SmoothMoveBack(float speed, int type){
        SmoothMove(originPoint, speed, type);
    }

    [LuaCallCSharp]
    public void SmoothMove(Vector3 target, float speed){
        SmoothMove(target, speed, UNIFORM);
    }

    [LuaCallCSharp]
    public void SmoothMove(Vector3 target, float speed, int type){
        this.target = target;
        this.speed = speed;
        this.type = type;
        distance = Vector3.Distance(transform.position, target);
        isMove = true;
    }

    [LuaCallCSharp]
    public void ReSize(Vector3 tar, Vector3 ori, float time){
        originScale = ori;
        targetScale = tar;
        resizeTime = time;
        isResize = true;
    }

    public void Rotate(Quaternion tar, Quaternion ori, float time){
        originAngle = ori;
        targetAngle = tar;
        rotateTime = time;
        isRotate = true;
    }

    [LuaCallCSharp]
    public void Discard(Vector3 target, float speed, int typek){
        //变化时间
        var time = 0.2f;
        SmoothMove(target, speed, type);
        var v1 = (target - transform.position).normalized;
        var v2 = Vector3.down;
        var angle = Mathf.Acos(Vector3.Dot(v1, v2)) / Mathf.PI * 180 * (v1.x > v2.x ? 1 : -1);
        transform.Rotate(transform.forward, angle);
        Rotate(transform.rotation, Quaternion.Euler(Vector3.zero), time);
        ReSize(Vector3.one * 0.2f, transform.localScale, time);
    }

    [LuaCallCSharp]
    public void SetCallBack(Action callback){
        callBack = callback;
    }
}