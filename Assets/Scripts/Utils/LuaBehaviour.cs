using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using XLua;
using System;
using System.IO;
using System.Text;
using System.Threading;
using XLua.LuaDLL;
using Object = System.Object;

namespace XLuaBehaviour{

    [System.Serializable]
    public class Injection
    {
        public string name;
        public GameObject value;
    }

    [System.Serializable]
    public class LuaScript{
        public TextAsset luaScript;
        public Injection[] injections;
        internal LuaTable scriptEnv;
        internal Action luaFixedUpdate;
        internal Action luaStart;
        internal Action luaUpdate;
        internal Action luaOnDestory;
    }

    [LuaCallCSharp]
    public class LuaBehaviour : MonoBehaviour
    {
        [LuaCallCSharp]
        public static class LuaCallCS{
            public static List<Type> lua_call_cs = new List<Type>() {
                typeof(Physics)
            };
        } 
            
        public LuaScript[] scripts;

        internal static LuaEnv luaEnv = new LuaEnv(); //all lua behaviour shared one luaenv only!
        internal static float lastGCTime = 0;
        internal const float GCInterval = 1;//1 second 

        
        
        void Awake(){
            Thread.Sleep(1000);
            LuaTable meta = luaEnv.NewTable();
            meta.Set("__index", luaEnv.Global);
            foreach (var script in scripts) {
                script.scriptEnv = luaEnv.NewTable();
                script.scriptEnv.SetMetaTable(meta);
                script.scriptEnv.Set("self",this);
                script.scriptEnv.Set("vm",luaEnv);

                foreach (var injection in script.injections) {
                    script.scriptEnv.Set(injection.name,injection.value);
                }

                luaEnv.DoString(script.luaScript.text, script.luaScript.name, script.scriptEnv);
                Action luaAwake = script.scriptEnv.Get<Action>("awake");
                script.luaStart = script.scriptEnv.Get<Action>("start");
                script.luaUpdate = script.scriptEnv.Get<Action>("update");
                script.luaOnDestory = script.scriptEnv.Get<Action>("ondestroy");
                script.luaFixedUpdate = script.scriptEnv.Get<Action>("fixedupdate");

                if (luaAwake != null)
                    luaAwake();
            }
            meta.Dispose();
        }

        private byte[] MyLoader(ref string path){
            string p = "Assets/protoc-gen-lua/protobuf/" + path;
            if (!File.Exists(p)) {
                return null;
            }

            return Encoding.UTF8.GetBytes(File.ReadAllText(p));
        }

        // Use this for initialization
        void Start()
        {
            foreach (var script in scripts) {
                if (script.luaStart != null) {
                    script.luaStart();
                }
            }
        }

        // Update is called once per frame
        void Update()
        {
            foreach (var script in scripts) {
                if (script.luaUpdate != null) {
                    script.luaUpdate();
                }
                if (Time.time - lastGCTime > GCInterval) {
                    
                    lastGCTime = Time.time;
                }
            }
        }

        private void FixedUpdate(){
            foreach (var script in scripts) {
                if (script.luaFixedUpdate != null) {
                    script.luaFixedUpdate();
                }
            }
        }

        void OnDestroy()
        {
            foreach (var script in scripts) {
                if (script.luaOnDestory != null) {
                    script.luaOnDestory();
                }

                script.luaOnDestory = null;
                script.luaUpdate = null;
                script.luaStart = null;
                script.scriptEnv.Dispose();
                script.injections = null;
            }
        }

        public void P(int aa,string hh){
            print("Hello World!!!!!" + " : "+aa+hh);
        }
        
        
        
        public Vector3 Raycast(Ray ray, int distance, LayerMask layerMask){
            Debug.Log(ray + "  " + distance + "  " + layerMask);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, distance, layerMask)) {
                return hit.point;
            }
            return hit.point;
        }
    }
}
