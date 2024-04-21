import { activeConfig,
  AudioEvent,
  ChangeScale,
  ColorConfig, EventCode, OneMinute,
  punch_event_name,
  timeConfig, TomatoDefaultSetting } from '../constants';
import { CountStatusType, FocusSelectType, TimeConfigType,
  TimeRecordType,
  TomatoSettingInputKey, TomatoTaskItem, TomatoTaskType } from '../types';
import emitter from '@ohos.events.emitter';
import { showDialog, TypeDialogManager } from './Dialog';
import { SingleEntity } from '../entryability/singleEnity';
import router from '@ohos.router';
import { getYMD } from '../utils/helper';
import DatabaseManager from '../services/DatabaseManager';
import { generateNanoId } from '../utils/generate';
import { Icon_list } from '../statics';

@Component
export struct TomatoModule {

  @State timeConfigState: TimeConfigType[] = timeConfig;
  @State selectTimeIndex: number = timeConfig[1].id;
  scroller: Scroller = new Scroller();
  textTimerController: TextTimerController = new TextTimerController();
  @State format: string = "mm:ss"
  @StorageProp('TomatoDefaultSetting') @Watch('getTomatoTasks') tomatoDefaultSetting: TomatoSettingInputKey = TomatoDefaultSetting;
  @State countStatus: CountStatusType = CountStatusType.UN_START;
  private DialogInstance: CustomDialogController | undefined = undefined;
  @State tomatoTaskIndex: number = 0;
  @State isEndCycle: boolean = false;

  createTypeDialog() {
    const titleStr = `${new Date().getFullYear()}/${new Date().getMonth() + 1}/${new Date().getDate()}/${new Date().getHours()}/${new Date().getMinutes()}/${new Date().getSeconds()}`
    this.DialogInstance = new CustomDialogController({
      builder: TypeDialogManager({
        cancel: this.closeDialog.bind(this),
        confirm: this.dialogAccept.bind(this),
        title: "输入保存的番茄钟标题",
        oldVal: `番茄钟记录-${titleStr}`,
        inputType: InputType.Normal
      }),
      alignment: DialogAlignment.Center
    });
    this.DialogInstance.open();
  }

  sendMessageToInfrom() {
    emitter.emit({eventId: EventCode.REFRESH_RECORD});
  }

  aboutToAppear(): void {
    emitter.on({ eventId: EventCode.CLOSE_OTHER_RUNNING_CLOCK }, (value) => {
      if (value.data?.timeType !== FocusSelectType.POMODORO) {
        this.resetTimer();
      }
    });

    emitter.on({ eventId: EventCode.TOMATO_SETTING_DATA }, () => {
      this.resetTimer();
    })

    SingleEntity.getInstance().setTomatoSetting(TomatoDefaultSetting);
  }

  dialogAccept(str: string) {
    this.DialogInstance?.close();
    this.openSaveModal(str);
  }

  closeDialog() {
    this.DialogInstance?.close();
  }

  getTomatoTasks(): TomatoTaskItem[] {
    // 这里塞的这个参数没啥意义，只是为了让这个函数reactive起来，可以理解为运行基于bug
    return SingleEntity.getInstance().getTomatoSetting(this.tomatoDefaultSetting);
  }

  async openSaveModal(str: string) {
    const titleStr = getYMD().dateStr;
    const key = `${punch_event_name.RECORD_ALL}${titleStr}`;

    const currentRecordList = await DatabaseManager.getCurrentAllDataByKey<TimeRecordType>(key);

    const generateId = await generateNanoId(32);

    const allTomateCount = SingleEntity.getInstance().getTomatoSetting(this.tomatoDefaultSetting);


    let resultTime = 0;
    if (this.isEndCycle) {
       resultTime = allTomateCount.reduce((prev, cur) => {
        prev += (cur.minute * OneMinute)
        return prev;
      }, 0);
    } else {
      const r = allTomateCount.slice(0, this.tomatoTaskIndex || 1);
      resultTime = r.reduce((prev, cur) => {
        prev += (cur.minute * OneMinute)
        return prev;
      }, 0);
    }

      // 暂时先写死，非常具体的统计口径到时候再写
    const countTime = `共${this.getTomatoTasks()?.[this.tomatoTaskIndex].tomato_current}次，共${resultTime}`;

    const newData: TimeRecordType = {
      id: generateId,
      title: str,
      type: FocusSelectType.POMODORO,
      createTime: new Date().getTime(),
      focusTime: countTime,
      ownerKey: key
    }

    const insertData = currentRecordList.concat(newData);

    await DatabaseManager.set(key, JSON.stringify(insertData));

    showDialog("提示", `已成功保存当前专注记录 ㅤ    ㅤ     ㅤ`);

    this.sendMessageToInfrom();
  }

  changeTimeIndex(index: number) {
    this.selectTimeIndex = index;
  }

  goToTomatoSetting() {
    router.pushUrl({
      url: "pages/TomatoSetting",
    })
  }

  resetTimer() {
    this.textTimerController.reset();
    this.countStatus = CountStatusType.UN_START;
  }

  // 完全重置
  resetTimerAction() {
    this.resetTimer();
    this.tomatoTaskIndex = 0;
    emitter.emit({ eventId: EventCode.PLAY_AUDIO }, { data : {
      event: AudioEvent.PAUSE
    }})
  }

  pauseTimer() {
    this.textTimerController.pause();
    this.countStatus = CountStatusType.IN_STOP;
    emitter.emit({ eventId: EventCode.PLAY_AUDIO }, { data : {
      event: AudioEvent.PAUSE
    }})
  }

  startTomato() {
    this.textTimerController.start();
    // 设置状态
    this.isEndCycle = false;
    this.countStatus = CountStatusType.IN_PROCESS;
    // 发消息关掉其他倒计时(应该没这个需求需要2-3个倒计时)
    emitter.emit({ eventId: EventCode.CLOSE_OTHER_RUNNING_CLOCK }, {
      data: {
        timeType: FocusSelectType.POMODORO
      }
    })
    emitter.emit({ eventId: EventCode.PLAY_AUDIO }, { data : {
      event: AudioEvent.PLAY
    }})
  }


  playRestAudio() {
    emitter.emit({ eventId: EventCode.PLAY_AUDIO }, { data : {
      event: AudioEvent.PAUSE
    }});
    setTimeout(() => {
      emitter.emit({ eventId: EventCode.PLAY_REMIND_AUDIO });
    }, 30)
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image($r("app.media.settingentry")).width(18).height(18).margin({ right: 3 })
          Text("番茄钟设置").fontSize(14).fontColor("#ea8a4e").onClick(() => {
            this.goToTomatoSetting();
          })
        }
        .margin({ top: 5, left: 5, right: 5 }).padding({ left: 8, right: 8, top: 4, bottom: 4 })
        .backgroundColor("rgba(255, 185, 115, 0.26)")
        .borderRadius(15)

      }.justifyContent(FlexAlign.End).width("100%").margin({ right: 15, top: 5 })

      Column() {
        Column() {
          TextTimer({
                isCountDown: true,
                count: this.getTomatoTasks()?.[this.tomatoTaskIndex].minute * (OneMinute * 1000),
                controller: this.textTimerController
             })
            .format(Number(this.tomatoDefaultSetting.every_time_len) > ChangeScale || Number(this.tomatoDefaultSetting.rest_time_len) > ChangeScale? 'HH:mm:ss' : "mm:ss")
            .fontSize(75)
            .fontWeight(600)
            .fontColor(activeConfig.active)
            .onTimer((utc: number, elapsedTime: number) => {
              if (elapsedTime === (this.getTomatoTasks()?.[this.tomatoTaskIndex]?.minute * OneMinute)) {
                 // 结束，开启新一段
                 const tmpIndex = this.tomatoTaskIndex + 1;

                 // if (this.getTomatoTasks()?.[tmpIndex] && this.getTomatoTasks()?.[tmpIndex].type === TomatoTaskType.REST) {
                 //   console.error("进入休息")
                 // }
                //
                // 如果不是自动进入下一个番茄钟，这里阻断一下
                if (this.getTomatoTasks()?.[this.tomatoTaskIndex] && this.getTomatoTasks()?.[this.tomatoTaskIndex].type === TomatoTaskType.REST && !this.tomatoDefaultSetting.auto_to_next) {
                  return;
                }

                if (this.getTomatoTasks()?.[tmpIndex]) {
                  this.resetTimer();
                  this.playRestAudio();
                  this.tomatoTaskIndex += 1;
                  setTimeout(() => {
                    this.startTomato();
                  }, 100)
                } else {
                  this.isEndCycle = true;
                  this.resetTimerAction();
                  this.createTypeDialog();
                }
              }
            })

          Image($r(Icon_list[8].url)).width(60).height(60).margin({ top: 30, bottom: 30 })

          if (this.getTomatoTasks()?.[this.tomatoTaskIndex].type === TomatoTaskType.REST) {
            Text(`正在休息～`).fontSize(16).fontColor(ColorConfig.THEME_ORANGE_COLOR).margin({ top: 2});
          } else {
            Text(`第${this.getTomatoTasks()?.[this.tomatoTaskIndex].tomato_current}个番茄钟，加油～`).fontSize(16).fontColor(ColorConfig.THEME_ORANGE_COLOR).margin({ top: 2});
          }

          Row() {
            if ([CountStatusType.UN_START, CountStatusType.IN_STOP].includes(this.countStatus)) {
              Button(`${this.countStatus === CountStatusType.UN_START ? "开始" : "继续"}`)
                .fontColor("white")
                .borderRadius(20)
                .padding({ left: 35, right: 35 })
                .type(ButtonType.Normal)
                .fontSize(16)
                .margin({ left: 5, right: 5, top: 30 })
                .backgroundColor(ColorConfig.THEME_ORANGE_COLOR)
                .onClick(() => {
                    this.startTomato();
                })
            }

            Row() {
              if ([CountStatusType.IN_PROCESS].includes(this.countStatus)) {
                Button("暂停")
                  .fontColor("white")
                  .borderRadius(20)
                  .padding({ left: 35, right: 35 })
                  .type(ButtonType.Normal)
                  .fontSize(16)
                  .margin({ left: 5, right: 5, top: 30 })
                  .onClick(() => {
                   this.pauseTimer();
                  })
              }

              if (this.getTomatoTasks()?.[this.tomatoTaskIndex] && this.getTomatoTasks()?.[this.tomatoTaskIndex].type === TomatoTaskType.REST) {
                Button("结束休息")
                  .backgroundColor(ColorConfig.SAVE_BTN_COLOR)
                  .fontColor("white")
                  .borderRadius(20)
                  .padding({ left: 35, right: 35 })
                  .type(ButtonType.Normal)
                  .fontSize(16)
                  .margin({ left: 5, right: 5, top: 30 })
                  .onClick(() => {
                    const tmpIndex = this.tomatoTaskIndex + 1;
                    if (this.getTomatoTasks()[tmpIndex]) {
                      this.tomatoTaskIndex += 1;
                      this.resetTimer();
                      this.startTomato();
                    }
                  })
              }

              if (this.countStatus === CountStatusType.IN_STOP) {
                Button("保存")
                  .backgroundColor(ColorConfig.SAVE_BTN_COLOR)
                  .fontColor("white")
                  .borderRadius(20)
                  .padding({ left: 35, right: 35 })
                  .type(ButtonType.Normal)
                  .fontSize(16)
                  .margin({ left: 5, right: 5, top: 30 })
                  .onClick(() => {
                    this.createTypeDialog();
                  })
              }
            }.justifyContent(FlexAlign.Center)
          }

          Blank().height(20)

          Row() {
            Text("放弃本次 / 重置").fontColor(activeConfig.normal).fontSize(14).onClick(() => {
              this.resetTimerAction();
            })
          }.justifyContent(FlexAlign.Center)

        }.justifyContent(FlexAlign.Center).margin({ top: "20%" })

      }.height("100%").width("100%")
    }
  }
}