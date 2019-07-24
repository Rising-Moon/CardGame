
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using XLua;
using System;
using System.IO;
using System.Text;

namespace BGcontroller
{
    [System.Serializable]
    public class Injection
    {
        public string name;
        public GameObject value;
    }

    [LuaCallCSharp]
    public class BGController : MonoBehaviour
    {
        public TextAsset luaScript;
        public Injection[] injections;

        internal static LuaEnv luaEnv = new LuaEnv(); //all lua behaviour shared one luaenv only!
        internal static float lastGCTime = 0;
        internal const float GCInterval = 1; //1 second 

        private Action luaStart;
        private Action luaUpdate;
        private Action luaOnDestroy;

        private LuaTable scriptEnv;

        void Awake()
        {
            scriptEnv = luaEnv.NewTable();

            // 为每个脚本设置一个独立的环境，可一定程度上防止脚本间全局变量、函数冲突
            LuaTable meta = luaEnv.NewTable();
            meta.Set("__index", luaEnv.Global);
            scriptEnv.SetMetaTable(meta);
            meta.Dispose();

            scriptEnv.Set("self", this);
            foreach (var injection in injections)
            {
                scriptEnv.Set(injection.name, injection.value);
            }
            //luaEnv.DoString(luaScript.text, "BGController", scriptEnv);
            luaEnv.DoString(luaScript.text, "cardBase", scriptEnv);
            /*luaEnv.AddLoader(loadermy);
            luaEnv.DoString("require'BGController'","require 'BGController",scriptEnv);*/
            //luaEnv.Dispose();
            /*LuaTable scriptEnv1 = scriptEnv.Get<LuaTable>("BGController");
            scriptEnv1.Set("self", this);
            scriptEnv1.Set("hello", 2);
            foreach (var injection in injections)
            {
                scriptEnv1.Set(injection.name, injection.value);
            }*/
            
            Action luaAwake = scriptEnv.Get<Action>("awake");
            scriptEnv.Get("showCardId", out luaStart);
            /*scriptEnv.Get("start", out luaStart);
            scriptEnv.Get("update", out luaUpdate);
            scriptEnv.Get("ondestroy", out luaOnDestroy);*/


            if (luaAwake != null)
            {
                luaAwake();
            }
        }

        // Use this for initialization
        void Start()
        {
            if (luaStart != null)
            {
                luaStart(); 
                
            }
        }

        // Update is called once per frame
        void Update()
        {
            
            
            if (luaUpdate != null)
            {
                luaUpdate();
            }

            if (Time.time - BGController.lastGCTime > GCInterval)
            {
                luaEnv.Tick();
                BGController.lastGCTime = Time.time;
            }
        }

        void OnDestroy()
        {
            if (luaOnDestroy != null)
            {
                luaOnDestroy();
            }
            luaOnDestroy = null;
            luaUpdate = null;
            luaStart = null;
            scriptEnv.Dispose();
            injections = null;
        }

        private byte[] loadermy(ref string path)
        {
            string absPath = Application.streamingAssetsPath + "/" + path + ".lua.txt";
            return Encoding.UTF8.GetBytes(File.ReadAllText(absPath)); //读取lua文件
            /*string mypath = Application.streamingAssetsPath + "/" + path + ".lua.txt";
          
            byte[] newpath = File.ReadAllBytes(mypath);
            return Encoding.UTF8.GetBytes(newpath);*/

        }

    }
}