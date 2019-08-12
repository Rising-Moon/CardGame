local RM = require("ResourcesManager");
--local SM = require("ScenesManager");

local AudioManager ={};

local UE =CS.UnityEngine;

AudioManager.cmRoot =nil;

--Unity中控制声音播放所需三个必要组件，分别是AudioSource、AudioClip、AudioListener
function AudioManager:init()

    --挂载音频组件的camera
    --self.cmRoot =UE.GameObject.Find("Main Camera");
    --挂靠在场景的相机上，当切换场景的时候，音乐会消失
    self.cmRoot =UE.GameObject.Find("mainApp");

    --AudioSource—声音的控制组件，包含了控制声音播放、暂停、停止等方法。
    self.backGroundMusic =self.cmRoot.gameObject:AddComponent(typeof(UE.AudioSource));
    --循环播放设置
    self.backGroundMusic.loop =true;
    self.backGroundMusic.volume =0.8;
    --记录当前播放的音乐
    --在战斗场景和其他场景，背景乐应当不一样
    self.currentMusic =nil;

end

function AudioManager:initMainCamera()
    if self.cmRoot then
        return
    end
    self.cmRoot =UE.GameObject:Find("mainApp");
end

--可以使用resourcesManager的lodapath；
function AudioManager:LoadAudio(path)
    local audio =UE.Resources.Load(path);
    return audio
end


--AudioClip—声音的源片段，即需要播放的声音对象。

--AudioListener—声音侦听器，没有它则无声音。

function AudioManager:PlayBacKGroundMusic(audio,delay)
    if not self.backGroundMusic then
        return
    end

    if audio  then
        if audio ==self.currentMusic then
            if self.currentMusic.isPlaying then
                return
            end
        else
            self.backGroundMusic.clip =audio;
        end

    else
        if not self.currentMusic then
            return
        end
    end

    if delay then
        self.backGroundMusic:PlayDelayed(delay)
    else
        self.backGroundMusic:Play()
    end
end

--暂停
function AudioManager:Pause()
    self.backGroundMusic:Pause();
end
--播放
function AudioManager:Play()
    self.backGroundMusic:Play();
end

--停止，停止后再播放，声音从头开始播放
function AudioManager:Stop()
    self.backGroundMusic:Stop();
end

AudioManager:init();

return AudioManager