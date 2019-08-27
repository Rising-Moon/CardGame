local AudioManager ={};

local UE =CS.UnityEngine;

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
    --为抽卡，用牌留下
    self.effectMusic =self.cmRoot.gameObject:AddComponent(typeof(UE.AudioSource));
    --循环播放设置
    self.currentMusic.loop =true;
    self.currentMusic.volume =0.3;
    --
    self.effectMusic.loop =false;
    self.currentMusic.volume =0.9;
    
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

function AudioManager:PlayEffectMusic(audio,delay)
    if not self.effectMusic then
        return
    end
    if audio then
        if audio  == self.effectMusic.clip then
            if self.effectMusic.isPlaying then
                return
            end
        else
            self.effectMusic.clip =audio;
        end
    end
    if delay then
        self.effectMusic:PlayDelayed(delay);
    else
        self.effectMusic:Play();

    end
end

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

function AudioManager:CloseMusic()
    self.currentMusic =nil;
    self.effectMusic =nil;
end

function AudioManager:reOpen()
    self:init();
end

AudioManager:init();

return AudioManager