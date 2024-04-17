import { activeConfig, ColorConfig, EventCode, timeConfig } from '../constants';
import { SingleEntity } from '../entryability/singleEnity';
import { CountStatusType, FocusSelectType, TimeConfigType } from '../types';
import { TypeDialogManager } from './Dialog';
import emitter from '@ohos.events.emitter';

@Component
export struct CountDownModule {
  @State timeConfigState: TimeConfigType[] = timeConfig;
  @State selectTimeIndex: number = timeConfig[1].id;
  @State format: string = 'mm:ss'
  @State countStatus: CountStatusType = CountStatusType.UN_START;
  @State targetTime: number = timeConfig[1].time;
  scroller: Scroller = new Scroller();
  textTimerController: TextTimerController = new TextTimerController();
  private DialogInstance: CustomDialogController | undefined = undefined;

  createTypeDialog(oldVal: string | number, title: string, inputType?: InputType) {
    this.DialogInstance = new CustomDialogController({
      builder: TypeDialogManager({
        cancel: this.closeDialog.bind(this),
        confirm: this.dialogAccept.bind(this),
        title,
        oldVal,
        inputType
      }),
      alignment: DialogAlignment.Center
    });

    this.DialogInstance.open();
  }

  aboutToAppear(): void {
    emitter.on({ eventId: EventCode.CLOSE_OTHER_RUNNING_CLOCK }, (value) => {
      if (value.data?.timeType !== FocusSelectType.NEGATIVE_COUNT) {
        this.resetTimer();
      }
    })
  }

  closeDialog() {
    this.DialogInstance?.close();
  }

  dialogAccept(time: string) {
    // 如果输入一个有的值
    const getResult = timeConfig.find(item => Number(time) === item.minute);
    if (getResult && getResult.minute) {
        this.changeTimeIndex(getResult)
    } else {
      const intTime = Number(time);
      const arrFirstItem = timeConfig[0];
      const restArr = timeConfig.slice(1);
      const setData: TimeConfigType = {
        id: restArr[restArr.length - 1].id + 1,
        time: intTime * 60 * 1000,
        str: `${intTime}分钟`,
        minute: intTime,
      };
      restArr.unshift(setData);
      const lastTime = [arrFirstItem].concat(restArr);
      this.timeConfigState = lastTime;
      this.changeTimeIndex(setData);
    }
    this.DialogInstance?.close();
  }

  changeTimeIndex(item: TimeConfigType) {
    this.selectTimeIndex = item.id;
    this.resetTimer();
    this.countStatus = CountStatusType.UN_START;
    if (item.time >= 60 * 60 * 1000) {
      this.format = 'HH:mm:ss'
    } else {
      this.format = 'mm:ss'
    }
    this.targetTime = item.time;
  }


  openDeleteModal() {
      AlertDialog.show(
        {
          title: '提醒',
          message: `是否保存当前的专注记录？ ㅤ    ㅤ     `,
          autoCancel: true,
          alignment: DialogAlignment.Bottom,
          gridCount: 4,
          offset: { dx: 0, dy: -20 },
          primaryButton: {
            value: '取消',
            action: () => {
              console.info('Callback when the first button is clicked')
            }
          },
          secondaryButton: {
            enabled: true,
            defaultFocus: true,
            style: DialogButtonStyle.HIGHLIGHT,
            backgroundColor: ColorConfig.NORMAL_COLOR,
            value: '保存',
            action: () => {
             console.error("hello")
            }
          },
          cancel: () => {
            console.info('Closed callbacks')
          }
        }
      )
  }

  resetTimer() {
    this.textTimerController.reset();
    this.countStatus = CountStatusType.UN_START;
  }

  startTimer() {
    this.textTimerController.start();
    this.countStatus = CountStatusType.IN_PROCESS;
    emitter.emit({eventId: EventCode.CLOSE_OTHER_RUNNING_CLOCK}, { data : {
      timeType: FocusSelectType.NEGATIVE_COUNT
    }})
  }

  pauseTimer() {
    this.textTimerController.pause();
    this.countStatus = CountStatusType.IN_STOP;
  }


  build() {
    Column() {
      Scroll(this.scroller) {
        Row() {
          ForEach(this.timeConfigState, (item: TimeConfigType, index: number) => {
            Column() {
              Text(item.str)
                .height(30)
                .fontSize(14)
                .textAlign(TextAlign.Center)
                .fontColor(this.selectTimeIndex === item.id ? ColorConfig.THEME_ORANGE_COLOR : activeConfig.normal)


            }.padding({left: 15, right: 15}).backgroundColor(this.selectTimeIndex === item.id ? "#f1f3f4" : undefined).borderRadius(20).onClick(() => {
              if (index === 0) {
                this.createTypeDialog(
                  item.minute,
                  "自定义时间（单位/分钟）",
                  InputType.Number
                );
                return;
              }
              this.scroller.scrollToIndex(index)
              this.changeTimeIndex(item);
            })
          })
        }.padding({left: 15, right: 15}).margin({ top: 5 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)  // 滚动条常驻显示
      .edgeEffect(EdgeEffect.None)

      Column() {
        Column() {
          TextTimer({ isCountDown: true, count: this.targetTime, controller: this.textTimerController })
            .format(this.format)
            .fontSize(75).fontWeight(600).fontColor(activeConfig.active)
            .onTimer((utc: number, elapsedTime: number) => {
              if ((elapsedTime * 1000) === this.targetTime) {
                  this.resetTimer();
                  this.openDeleteModal();
              }
            })

          Image($r("app.media.tabicon_xianhualvzhi")).width(60).height(60).margin({top: 30})

          Row() {
            if ([CountStatusType.UN_START, CountStatusType.IN_STOP].includes(this.countStatus)) {
              Button(`${this.countStatus === CountStatusType.UN_START ? "开始" : "继续"}`).fontColor("white").borderRadius(20).padding({left: 35, right: 35 }).type(ButtonType.Normal).fontSize(16).margin({left: 5, right: 5, top: 30}).backgroundColor(ColorConfig.THEME_ORANGE_COLOR).onClick(() => {
                this.startTimer();
              })
            }

            if (this.countStatus === CountStatusType.IN_PROCESS) {
              Button("暂停").fontColor("white").borderRadius(20).padding({left: 35, right: 35 }).type(ButtonType.Normal).fontSize(16).margin({left: 5, right: 5,top: 30}).onClick(() => {
                this.pauseTimer();
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

      }.justifyContent(FlexAlign.Center).margin({top: "20%"})


    }.height("100%").width("100%")
  }
}