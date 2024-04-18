import media from '@ohos.multimedia.media';
import { BusinessError } from '@ohos.base';

export class AVPlayerDemo {
  private avPlayer;
  private count: number = 0;
  private isSeek: boolean = true; // 用于区分模式是否支持seek操作


  setAVPlayerCallback(avPlayer: media.AVPlayer) {
    // seek操作结果回调函数
    avPlayer.on('seekDone', (seekDoneTime: number) => {
      console.info(`AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    })
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用 reset接口触发重置流程
    avPlayer.on('error', (err: BusinessError) => {
      console.error(`Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      avPlayer.reset(); // 调用reset重置资源，触发idle状态
    })
    // 状态机变化回调函数
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          console.info('AVPlayer state idle called.');
          avPlayer.release(); // 调用release接口销毁实例对象
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          console.info('AVPlayer state initialized called.');
          avPlayer.prepare();
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          console.info('AVPlayer state prepared called.');
          avPlayer.play(); // 调用播放接口开始播放
          break;
        case 'playing': // play成功调用后触发该状态机上报
          console.info('AVPlayer state playing called.');
          if (this.count !== 0) {
            if (this.isSeek) {
              console.info('AVPlayer start to seek.');
              avPlayer.seek(avPlayer.duration); //seek到音频末尾
            } else {
              // 当播放模式不支持seek操作时继续播放到结尾
              console.info('AVPlayer wait to play end.');
            }
          } else {
            avPlayer.pause(); // 调用暂停接口暂停播放
          }
          this.count++;
          break;
        case 'paused': // pause成功调用后触发该状态机上报
          console.info('AVPlayer state paused called.');
          avPlayer.play(); // 再次播放接口开始播放
          break;
        case 'completed': // 播放结束后触发该状态机上报
          console.info('AVPlayer state completed called.');
          avPlayer.stop(); //调用播放结束接口
          break;
        case 'stopped': // stop接口成功调用后触发该状态机上报
          console.info('AVPlayer state stopped called.');
          avPlayer.reset(); // 调用reset接口初始化avplayer状态
          break;
        case 'released':
          console.info('AVPlayer state released called.');
          break;
        default:
          console.info('AVPlayer state unknown called.');
          break;
      }
    })
  }

  // 以下demo为使用资源管理接口获取打包在HAP内的媒体资源文件并通过fdSrc属性进行播放示例
  async avPlayerFdSrcDemo(file) {
    try {
      // 创建avPlayer实例对象
      let avPlayer: media.AVPlayer = await media.createAVPlayer();
      // 创建状态机变化回调函数
      this.setAVPlayerCallback(avPlayer);
      // 为fdSrc赋值触发initialized状态机上报
      this.avPlayer.fdSrc = file;
      this.avPlayer.loop = true;
      console.error(`${JSON.stringify(this.avPlayer)}`)
    } catch (e) {
      console.error(`${JSON.stringify(e)}`)
    }
  }
}

export default new AVPlayerDemo();

