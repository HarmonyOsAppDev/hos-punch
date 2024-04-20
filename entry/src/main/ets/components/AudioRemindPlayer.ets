import media from '@ohos.multimedia.media';
import common from '@ohos.app.ability.common';
import { EventCode } from '../constants';
import emitter from '@ohos.events.emitter';
import { BusinessError } from '@ohos.base';
import audio from '@ohos.multimedia.audio';

@Component
export struct AudioRemindPlayer {

  aboutToAppear(): void {
    emitter.on({eventId: EventCode.PLAY_REMIND_AUDIO}, () => {
      this.playAudio();
    });
  }

  aboutToDisappear(): void {
    emitter.off(EventCode.PLAY_REMIND_AUDIO)
  }


   async playAudio() {

     let context = getContext(this) as common.UIAbilityContext;

     let fileDescriptor = await context.resourceManager.getRawFd("ding.mp3");

     let avFileDescriptor: media.AVFileDescriptor = { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length };

     let audioRendererInfo: audio.AudioRendererInfo = {
       usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
       rendererFlags: 1
     }

     media.createSoundPool(1, audioRendererInfo, (error: BusinessError, soundPool_: media.SoundPool) => {
       if (error) {
         console.error(`createSoundPool failed`)
         return;
       } else {
         const soundPool = soundPool_;
         //获取fd的uri路径
         const fileDescriptor: number = avFileDescriptor.fd; // 假设有一个文件描述符
         const offset: number = avFileDescriptor.offset as number; // 偏移量
         const length: number = avFileDescriptor.length as number; // 长度

         soundPool.load(fileDescriptor, offset, length, (error: BusinessError, soundId_: number) => {
           if (error) {
             console.error(`load soundPool Error: errCode is ${error.code}, errMessage is ${error.message}`)
           } else {
             setTimeout(() => {
               // this.soundPool?.play(soundId_);
               soundPool?.play(soundId_).then((streamId: number) => {
                 console.info('play success');
               },(err: BusinessError) => {
                 console.error('soundpool play failed and catch error is ' + err.message);
               });
             }, 50)
           }
         });
       }
     })
   }

  build() {
      Row() {}
  }
}