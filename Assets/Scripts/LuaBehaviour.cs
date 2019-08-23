using UnityEngine;
using XLua;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;

namespace XLuaBehaviour{
    [System.Serializable]
    public class Injection{
        public string name;
        public GameObject value;
    }
    
    [System.Serializable]
    public class LuaScript{
        public string luaFileName;
        public Injection[] injections;
        internal LuaTable scriptEnv;
        internal Action luaFixedUpdate;
        internal Action luaStart;
        internal Action luaUpdate;

        internal Action luaOnDestory;

        //监听消息列表
        internal Action luaMessageCast;
    }

    [LuaCallCSharp]
    public class LuaBehaviour : MonoBehaviour, IMessageListener{
        
        //lua路径列表
        private List<string> luaPathList;

        //lua AB包
        private AssetBundle luaAB;
        
        //lua脚本列表
        public LuaScript[] scripts;

        internal static LuaEnv luaEnv = new LuaEnv(); //all lua behaviour shared one luaenv only!
        internal static float lastGCTime = 0;
        internal const float GCInterval = 1; //1 second 

        void Awake(){

            //不销毁mainApp避免lua脚本失效
            DontDestroyOnLoad(gameObject);

            
            luaPathList = new List<string>();
            //添加lua文件路径
            addLuaPath("Assets.Scripts.Lua");
            addLuaPath("Assets.Scripts.Lua.lib");
            addLuaPath("Assets.Scripts.Lua.Model");
            addLuaPath("Assets.Scripts.Lua.Controller");
            addLuaPath("Assets.Scripts.Lua.Util");
            addLuaPath("Assets.Scripts.Lua.View");


            //将luaBehaviour注册到消息列表监听
            MessageQueueManager.GetMessageQueue().RegisteredListener(this);

            LuaTable meta = luaEnv.NewTable();

            //导入lua依赖
            luaEnv.AddBuildin("pb", XLua.LuaDLL.Lua.LoadLuaProfobuf);

            //添加自定义Loader
            luaEnv.AddLoader(LuaPathLoader);
            luaEnv.AddLoader(LuaABLoader);

            //使lua中可以操作全局变量（慎用）
            luaEnv.Global.Set("global", luaEnv.Global);

            meta.Set("__index", luaEnv.Global);
            foreach (var script in scripts) {
                script.scriptEnv = luaEnv.NewTable();
                script.scriptEnv.SetMetaTable(meta);
                //设置全局变量
                script.scriptEnv.Set("self", this);
                script.scriptEnv.Set("vm", luaEnv);

                foreach (var injection in script.injections) {
                    script.scriptEnv.Set(injection.name, injection.value);
                }
            }

            runLuaFile();

            meta.Dispose();
        }

        //开始执行
        private void runLuaFile(){
            foreach (var script in scripts) {
                //加载主lua文件
                WWW luaFile = new WWW("file:///" + Application.dataPath + "/Scripts/Lua/" + script.luaFileName);
                luaEnv.DoString(luaFile.text, script.luaFileName, script.scriptEnv);
                Action luaAwake = script.scriptEnv.Get<Action>("awake");
                script.luaStart = script.scriptEnv.Get<Action>("start");
                script.luaUpdate = script.scriptEnv.Get<Action>("update");
                script.luaOnDestory = script.scriptEnv.Get<Action>("ondestroy");
                script.luaFixedUpdate = script.scriptEnv.Get<Action>("fixedupdate");
                script.luaMessageCast = script.scriptEnv.Get<Action>("response");

                if (luaAwake != null)
                    luaAwake();
            }
        }

        //自定义Loader定位到Lua文件夹
        private byte[] LuaPathLoader(ref string filename){
            foreach (var path in luaPathList) {
                string luafile = path + filename + ".lua";
                if (File.Exists(luafile))
                    return Encoding.UTF8.GetBytes(File.ReadAllText(luafile));
            }

            return null;
        }

        //自定义Loader可以从AssetsBundle包读出
        private byte[] LuaABLoader(ref string filename){
            string luaABPath = Application.streamingAssetsPath + "/AssetBundles/" + "lua.lua";
            if (!File.Exists(luaABPath)) {
                Debug.Log("LUA_AB文件不存在");
                return null;
            }

            if (luaAB == null)
                luaAB = AssetBundle.LoadFromFile(luaABPath);
            TextAsset luaFile = luaAB.LoadAsset<TextAsset>(filename + ".lua.bytes");
            if (luaFile == null) {
                return null;
            }

            return luaFile.bytes;
        }

        //添加路径
        private void addLuaPath(string path){
            path = path.Replace(".", "/") + "/";
            luaPathList.Add(path);
        }

        void Start(){
            foreach (var script in scripts) {
                if (script.luaStart != null) {
                    script.luaStart();
                }
                
            }
        }

        void Update(){
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

        void OnDestroy(){
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
        
        //接收消息处理后映射到lua中，消息内容在lua的messageCast变量中
        public bool Response(Message msg){
            foreach (var script in scripts) {
                LuaTable luaTable = luaEnv.NewTable();
                luaTable.Set("message", msg is Message.ByteMessage ? (Message.ByteMessage) msg : msg);
                luaTable.Set("type", msg is Message.ByteMessage ? 2 : 1);
                script.scriptEnv.Set("messageCast", luaTable);

                if (script.luaMessageCast != null)
                    script.luaMessageCast();
            }

            return false;
        }
    }
}