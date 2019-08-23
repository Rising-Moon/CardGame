-- 导包
local ResourcesManager = require("ResourcesManager");


local MusicManager = {};

----
--- 音效列表
----

MusicManager.clips = {
    BattleMusic = { path = "Assets/StreamingAssets/AssetBundles/loadingmusic.music", name = "battle_background" },
    HitAfx = { path = "Assets/StreamingAssets/AssetBundles/loadingmusic.music", name = "hit_2" },
    HitAfx2 = { path = "Assets/StreamingAssets/AssetBundles/loadingmusic.music", name = "hit_3" },
    Armor = { path = "Assets/StreamingAssets/AssetBundles/loadingmusic.music", name = "armor" },
    Licens = { path = "Assets/StreamingAssets/AssetBundles/loadingmusic.music", name = "licens" },
    PickCard = {path = "Assets/StreamingAssets/AssetBundles/loadingmusic.music", name = "pick_card"},
    PutCard = {path = "Assets/StreamingAssets/AssetBundles/loadingmusic.music", name = "put_card"}
}

local clips = MusicManager.clips;

----
--- 通用
----

-- 音乐播放挂载的object
local playerObject = nil;

if (playerObject == nil) then
    playerObject = CS.UnityEngine.GameObject("MusicPlayer");
end

-- 加载音乐
function loadAudio(path, name)
    local clip = ResourcesManager:LoadPath(path, name);
    return clip;
end

----
--- 背景音乐部分
----

MusicManager.background = {};
local background = MusicManager.background;
-- 背景音乐
background.music = nil;
-- AudioSource组件
background.audio = nil;

-- 设置背景音乐
function background:setMusic(clipName)
    if (not background.audio) then
        background.audio = playerObject:AddComponent(typeof(CS.UnityEngine.AudioSource));
        background.audio.priority = 0;
        background.audio.playOnAwake = false;
    end
    background.audio:Stop();
    background.music = background;
    background.audio.clip = loadAudio(clips[clipName].path, clips[clipName].name);
end

-- 设置音乐大小
function background:setVolume(volume)
    background.audio.volume = volume;
end

-- 开始播放背景音乐
function background:play()
    if (background.music == nil) then
        error("未设置背景音乐")
        return false;
    end
    background.audio:Play();
end

-- 暂停背景音乐
function background:pause()
    if (background.audio.isPlaying) then
        background.audio:Pause();
    else
        error("背景音乐未在播放");
    end
end

-- 停止背景音乐
function background:stop()
    if (background.audio.isPlaying) then
        background.audio:Stop();
    else
        error("背景音乐未在播放");
    end
end

----
--- 音效部分 (控制可同时播放数量，不到上限时，当前AudioSource正在播放,则创建新的AudioSource来播放，如果已经
--- 到达上限，则遍历列表，找到已经播放完的AudioSource来播放当前音效)
----
MusicManager.afx = {};
local afx = MusicManager.afx;
-- AudioSource组件
local audio = {};
-- 当前使用的第几个
local current = 1;
-- 最大可同时播放的音效数
local maxClipCount = 4;

-- 播放音效
function afx:playClip(clipName, volume)
    local usingAudio = nil;
    -- audio不存在则创建
    if (not audio[current]) then
        audio[current] = playerObject:AddComponent(typeof(CS.UnityEngine.AudioSource));
        usingAudio = audio[current];
        usingAudio.volume = volume;
        usingAudio.playOnAwake = false;
    else
        usingAudio = audio[current];
        usingAudio.volume = volume;
    end

    -- 当前音效未结束就切换AudioSource
    if (usingAudio.isPlaying) then
        if (current < maxClipCount) then
            current = current + 1;
            afx:playClip(clipName, volume);
            return ;
        else
            for i = 1, maxClipCount do
                if (not audio[i].isPlaying) then
                    current = i;
                    afx:playClip(clipName, volume);
                    return ;
                end
            end
        end
    end

    -- 播放音效
    if (usingAudio) then
        print("播放音效："..clipName);
        usingAudio.clip = loadAudio(clips[clipName].path, clips[clipName].name);

        usingAudio:Play();
    end
end

return MusicManager;