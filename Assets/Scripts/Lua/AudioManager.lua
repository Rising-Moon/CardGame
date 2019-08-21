local RM = require("ResourcesManager");
--local SM = require("ScenesManager");

local AudioManager ={};

local UE =CS.UnityEngine;

local isPlayMusic = false;

AudioManager.cmRoot =nil;

--Unity中控制声音播放所需三个必要组件，分别是AudioSource、AudioClip、AudioListener
function AudioManager:init()

    --挂载音频组件的camera
    --self.cmRoot =UE.GameObject.Find("Main Camera");
    --挂靠在场景的相机上，当切换场景的时候，音乐会消失
    self.cmRoot =UE.GameObject.Find("mainApp");

    --记录当前播放的音乐
    --AudioSource—声音的控制组件，包含了控制声音播放、暂停、停止等方法。
    self.currentMusic =self.cmRoot.gameObject:AddComponent(typeof(UE.AudioSource));
    --循环播放设置
    self.currentMusic.loop =true;
    self.currentMusic.volume =0.8;


    --不同的音乐应当都为背景乐，同一时间只能播放一首乐曲
    self.backGroundMusic =nil;


end

function AudioManager:initMain()
    if self.cmRoot then
        return
    end
    self.cmRoot =UE.GameObject:Find("mainApp");
end

--[[
--可以使用resourcesManager的lodapath；
function AudioManager:LoadAudio(path)
    local audio =UE.Resources.Load(path);
    return audio
end
]]--

--AudioClip—声音的源片段，即需要播放的声音对象。

--AudioListener—声音侦听器，没有它则无声音。

function AudioManager:PlayMusic(audio,delay)
    --不存在控制组件的时候退出
    if not self.currentMusic then
        return
    end
    --现在
    if audio  then
        if audio ==self.backGroundMusic then
            if self.backGroundMusic.isPlaying then
                return
            end
        else
            self.backGroundMusic =audio;
            self.currentMusic.clip =audio;
        end

    else
        if not self.backGroundMusic then
            print("没有可以播放的音频");
            return
        else
            self.currentMusic.clip =self.backGroundMusic;
        end
    end

    if delay then
        self.currentMusic:PlayDelayed(delay);
    else
        self.currentMusic:Play();
    end
end

--[[
--两个audio有些重复了，可以直接设置为两段音乐，然后在切换不同场景的时候切换，可用current作为temp，但是这样好像不太符合模块的定义？
function AudioManager:PlayBattleMusic(audio,delay)

end
]]--

--暂停
function AudioManager:Pause()
    if not self.currentMusic.clip then
        return
    end
    self.currentMusic:Pause();
end
--播放
function AudioManager:Play()
    if not self.currentMusic.clip then
        return
    end
    self.currentMusic:Play();
end

--停止，停止后再播放，声音从头开始播放
function AudioManager:Stop()
    if not self.currentMusic.clip then
        return
    end
    self.currentMusic:Stop();
end

AudioManager:init();

return AudioManager