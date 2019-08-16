using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Timer
{
    // 是否自动循环（小于等于0后重置）
    public bool IsAutoCycle 
    { 
        get;
        set;
    }
    // 是否是否暂停了
    public bool IsStoped
    {
        get; 
        set;
    }   
    // 当前时间                    
    public float CurrentTime
    {
        get
        {
            return UpdateCurrentTime();
        } 
    }
    // 是否时间到
    public bool IsTimeUp
    {
        get
        {
            return CurrentTime <= 0;
        }
    }
    //    时间长度
    public float Duration
    {
        get; 
        set;
    }
     // 上一次更新的时间             
    private float lastTime;   
    // 上一次更新倒计时的帧数（避免一帧多次更新计时）
    private int lastUpdateFrame;              
    // 当前计时器剩余时间
    private float currentTime;


    //设置时间循环时间和是否自动循环，定时器默认不自动循环，构造后就启动
    public Timer(float duration=3.0f, bool autocycle = false, bool autoStart = true)
    {
        IsStoped = true;
        Duration = Mathf.Max(0f, duration); 
        IsAutoCycle = autocycle; 
        Reset(duration, !autoStart);
    }

    /// 更新计时器时间
    //返回剩余时间
    private float UpdateCurrentTime()
    {
        if (IsStoped || lastUpdateFrame == Time.frameCount)         // 暂停了或已经这一帧更新过了，直接返回
            return currentTime;
        
        if (currentTime <= 0) // 小于等于0直接返回，如果循环那就重置时间
        {
            if (IsAutoCycle)
                Reset(Duration,false);
            return currentTime;
        }
        
        currentTime -= Time.time - lastTime;
        UpdateLastTimeInfo(); 
        return currentTime;
    }

    // 更新时间标记
    private void UpdateLastTimeInfo()
    { 
        lastTime = Time.time;
        lastUpdateFrame = Time.frameCount;
    }
        

    // 开始计时，取消暂停状态
    public void Start()
    { 
        Reset(Duration,false);
    }
        
    
    // 重置计时器
    public void Reset(float duration =3.0f, bool isStoped = false)
    {
        UpdateLastTimeInfo();
        Duration = Mathf.Max(0f, duration); 
        currentTime = Duration; 
        IsStoped = isStoped;
    }
        

    // 暂停
    public void Pause()
    {
        UpdateCurrentTime();    // 暂停前先更新一遍
        IsStoped = true;
    }

    // 继续（取消暂停）
    public void Continue()
    
    {
        UpdateLastTimeInfo(); // 继续前先更新当前时间信息
        IsStoped = false;
    }

    /// 终止，暂停且设置当前值为0
    public void End()
    
    {
        IsStoped = true;
        currentTime = 0f;
    }


    // 获取倒计时完成率（0为没开始计时，1为计时结束）
    public float GetPercent()

    {
        UpdateCurrentTime();
        if (currentTime <= 0 || Duration <= 0)
            return 1f;
        return 1f - currentTime / Duration;
    }

}
