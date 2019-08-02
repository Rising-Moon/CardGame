using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//Scence 栈结构，先进后出
public class SceneStack<T>
{
    private int top;
    private T[] stkArr;
    private int maxSize;
    
    //栈顶索引
    public int Top
    {
        get => top;
        set => top = value;
    }

    public T[] StkArr
    {
        get => stkArr;
        set => stkArr = value;
    }

    public int MaxSize
    {
        get => maxSize;
        set
        {
            if (value < 0)
            {
                throw new Exception("maxSize is d 0!");
            }
            else
            {
                maxSize = value;
            }
        }
    }
    public SceneStack(int maxSize)
    {
        this.MaxSize = maxSize;
        this.StkArr = new T[maxSize];
        Top = 0;
    }
    
    //判断栈满没满
    public bool isFull()
    {
        return (Top == MaxSize);
    }
    //判断栈是否为空
    public bool isNull()
    {
        return (Top == 0);
    }
    
    //出栈
    public T pop()
    {
        if (isNull())
        {
            throw new Exception("栈为空!");
        }
        else
        {
            return StkArr[--Top];
        }
    }
    //入栈
    public void push(T value)
    {
        if (isFull())
        {
            throw new Exception("栈已满!");
        }
        else
        {
            StkArr[top++] = value;
        }
    }
    //遍历
    public IEnumerable getEnumerable()
    {
        for (int i = 0; i < MaxSize; i++)
        {
            yield return stkArr[i];
        }
    }
}
