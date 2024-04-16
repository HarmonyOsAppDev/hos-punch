import audio from '@ohos.multimedia.audio';
import media from '@ohos.multimedia.media';
import fs from '@ohos.file.fs'

let soundPool: media.SoundPool;
let streamId: number = 0;
let soundId: number = 0;

let audioRendererInfo: audio.AudioRendererInfo = {
  usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
  rendererFlags: 1
}
let PlayParameters: media.PlayParameters = {
  // loop: 1, // 循环4次
  rate: audio.AudioRendererRate.RENDER_RATE_NORMAL, // 正常倍速
  leftVolume: 0.5, // range = 0.0-1.0
  rightVolume: 0.5, // range = 0.0-1.0
  priority: 0, // 最低优先级
}
let uri: string = "";

async function create() {
  //创建soundPool实例
  soundPool = await media.createSoundPool(5, audioRendererInfo);
  //注册监听
  loadCallback();
  finishPlayCallback();
  setErrorCallback();
  // 加载音频资源
  await fs.open('/test_01.mp3', fs.OpenMode.READ_ONLY).then((file: fs.File) => {
    console.info("file fd: " + file.fd);
    uri = 'fd://' + (file.fd).toString()
  }); // '/test_01.mp3' 作为样例，使用时需要传入文件对应路径。

  soundId = await soundPool.load(uri);
}

async function loadCallback() {
  // 加载完成回调
  soundPool.on('loadComplete', (soundId_: number) => {
    console.info('loadComplete, soundId: ' + soundId_);
  })
}
//设置播放完成监听
async function finishPlayCallback() {
  // 播放完成回调
  soundPool.on('playFinished', () => {
    console.info("recive play finished message");
    // 可进行下次播放
  })
}
//设置错误类型监听
function setErrorCallback() {
  soundPool.on('error', (error) => {
    console.info('error happened,message is :' + error.message);
  })
}

async function PlaySoundPool() {
  // 开始播放,这边play也可带播放播放的参数PlayParameters
  streamId = await soundPool.play(soundId);
  // 设置循环播放次数
  soundPool.setLoop(streamId, 2); // 播放3次
  // 设置对应流的优先级
  soundPool.setPriority(streamId, 1);
  // 设置音量
  soundPool.setVolume(streamId, 0.5, 0.5);
}

async function release() {
  // 终止指定流的播放
  soundPool.stop(streamId);
  // 卸载音频资源
  await soundPool.unload(soundId);
  //关闭监听
  setOffCallback();
  // 释放SoundPool
  await soundPool.release();
}

//关闭监听
function setOffCallback() {
  soundPool.off('loadComplete');
  soundPool.off('playFinished');
  soundPool.off('error');
}