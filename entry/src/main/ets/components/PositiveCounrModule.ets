import { activeConfig, AudioEvent, ColorConfig, EventCode, punch_event_name, timeConfig } from '../constants';
import DatabaseManager from '../services/DatabaseManager';
import { CountStatusType, FocusSelectType, TimeConfigType, TimeRecordType } from '../types';
import { showDialog, TypeDialogManager } from './Dialog';
import emitter from '@ohos.events.emitter';
import { generateNanoId } from '../utils/generate';
import { getYMD } from '../utils/helper';

@Component
export struct PositiveCounrModule {
  @State timeConfigState: TimeConfigType[] = timeConfig;
  textTimerController: TextTimerController = new TextTimerController();
  scroller: Scroller = new Scroller();
  @State format: string = 'HH:mm:ss'
  @State countStatus: CountStatusType = CountStatusType.UN_START;
  @State countTime: number = 0;
  private DialogInstance: CustomDialogController | undefined = undefined;

  createTypeDialog() {
    const titleStr = `${new Date().getFullYear()}-${new Date().getMonth() + 1}-${new Date().getDate()} ${new Date().getHours()}: ${new Date().getMinutes()}`
    this.DialogInstance = new CustomDialogController({
      builder: TypeDialogManager({
        cancel: this.closeDialog.bind(this),
        confirm: this.dialogAccept.bind(this),
        title: "输入保存的专注标题",
        oldVal: `正计时-${titleStr}`,
        inputType: InputType.Normal
      }),
      alignment: DialogAlignment.Center
    });
    this.DialogInstance.open();
  }

  dialogAccept(str: string) {
    this.DialogInstance?.close();
    this.openSaveModal(str);
  }

  closeDialog() {
    this.DialogInstance?.close();
  }

  async openSaveModal(str: string) {
    const titleStr = getYMD().dateStr;
    const key = `${punch_event_name.RECORD_ALL}${titleStr}`;

    const currentRecordList = await DatabaseManager.getCurrentAllDataByKey<TimeRecordType>(key);

    const generateId = await generateNanoId(32);

    const newData: TimeRecordType = {
      id: generateId,
      title: str,
      type: FocusSelectType.POSITIVE_COUNT,
      createTime: new Date().getTime(),
      focusTime: this.countTime.toString(),
      ownerKey: key
    }

    const insertData = currentRecordList.concat(newData);

    await DatabaseManager.set(key,  JSON.stringify(insertData));

    showDialog("提示", `已成功保存当前专注记录 ㅤ    ㅤ     ㅤ`);

    this.sendMessageToInfrom();
  }

  sendMessageToInfrom() {
    emitter.emit({eventId: EventCode.REFRESH_RECORD});
  }

  aboutToAppear(): void {
    emitter.on({ eventId: EventCode.CLOSE_OTHER_RUNNING_CLOCK }, (value) => {
      if (value.data?.timeType !== FocusSelectType.POSITIVE_COUNT) {
        this.resetTimer();
      }
    })
  }

  resetTimer() {
    this.textTimerController.reset();
    this.countStatus = CountStatusType.UN_START;
    emitter.emit({ eventId: EventCode.PLAY_AUDIO }, { data : {
      event: AudioEvent.PAUSE
    }})
  }

  build() {
    Column() {
      Column() {
        Column() {
          TextTimer({ isCountDown: false, controller: this.textTimerController })
            .format(this.format)
            .fontSize(75).fontWeight(600).fontColor(activeConfig.active)
            .onTimer((utc: number, elapsedTime: number) => {
              this.countTime = elapsedTime;
            })

          Image($r("app.media.tabicon_xianhualvzhi")).width(60).height(60).margin({top: 30})


          Row() {
            if ([CountStatusType.UN_START, CountStatusType.IN_STOP].includes(this.countStatus)) {
              Button(`${this.countStatus === CountStatusType.UN_START ? "开始" : "继续"}`).fontColor("white").borderRadius(20).padding({left: 35, right: 35 }).type(ButtonType.Normal).fontSize(16).margin({left: 5, right: 5, top: 30}).backgroundColor(ColorConfig.THEME_ORANGE_COLOR).onClick(() => {
                this.textTimerController.start();
                this.countStatus = CountStatusType.IN_PROCESS;
                emitter.emit({eventId: EventCode.CLOSE_OTHER_RUNNING_CLOCK}, { data : {
                  timeType: FocusSelectType.POSITIVE_COUNT
                }})

                emitter.emit({ eventId: EventCode.PLAY_AUDIO }, { data : {
                  event: AudioEvent.PLAY
                }})
              })
            }

            if ([CountStatusType.IN_PROCESS].includes(this.countStatus)) {
                Button("暂停")
                  .fontColor("white")
                  .borderRadius(20)
                  .padding({ left: 35, right: 35 })
                  .type(ButtonType.Normal)
                  .fontSize(16)
                  .margin({ left: 5, right: 5, top: 30 })
                  .onClick(() => {
                    this.textTimerController.pause();
                    this.countStatus = CountStatusType.IN_STOP;
                    emitter.emit({ eventId: EventCode.PLAY_AUDIO }, { data : {
                      event: AudioEvent.PAUSE
                    }})
                  })

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
            this.resetTimer();
          })
        }.justifyContent(FlexAlign.Center)

      }.justifyContent(FlexAlign.Center).margin({top: "25%"})


    }.height("100%").width("100%")
  }
}