import { activeConfig, AudioEvent, ColorConfig, EventCode, punch_event_name } from '../constants'
import { CycleType, NewTaskType, PersonalPunchInRecord, SelectDateType, SettingType } from '../types'
import { getDaysOfMonthWithFirstDayOfWeek, getYMD } from '../utils/helper'
import router from '@ohos.router'
import DatabaseManager from '../services/DatabaseManager'
import systemDateTime from '@ohos.systemDateTime'
import { PosterDialog, showDialog } from '../components/Dialog'
import { generateNanoId } from '../utils/generate'
import emitter from '@ohos.events.emitter'

@Entry
@Component
export struct HomePage {
  @State currentDayList: number[] = []
  @State currentDate: SelectDateType = {
    year: new Date().getFullYear(),
    month: new Date().getMonth() + 1,
    day: new Date().getDate(),
  }
  @State allPunchInData: NewTaskType[] = [];
  @State currentDatePunchInData: PersonalPunchInRecord[] = [];
  private isNeedAudio: boolean = false;
  selectedDate: Date = new Date();
  private scrollerForList: Scroller = new Scroller()
  private DialogInstance: CustomDialogController | undefined = undefined;

  async aboutToAppear() {
    this.initData();
    this.getPunchAuidoSetting();
    emitter.on({eventId: EventCode.DELETE_ACTION}, () => {
      this.initData();
    })
  }

  async getPunchAuidoSetting() {
    const data = await DatabaseManager.get(punch_event_name.SETTING);
    if (data !== '') {
      const params: SettingType = JSON.parse(data || "{}");
      this.isNeedAudio = params?.punchInAudio;
    }
  }

  async initData() {
    this.dateChange();
    await this.getPunchInData();
  }

  aboutToDisappear(): void {
    emitter.off(EventCode.DELETE_ACTION);
  }

  createTypeDialog(avatar: string) {
    this.DialogInstance = new CustomDialogController({
      builder: PosterDialog({
        avatar,
      }),
      alignment: DialogAlignment.Center,
      customStyle: true,
    });

    this.DialogInstance.open();
  }

  // 获取当前对应的打卡
  async getPunchInData() {
    await this.fetchCurrentDatePunchInData();

    const allPunchInData = await DatabaseManager.getAllPunchInData();

    const getMatchPunchData = this.getCurrentMatchPunch(allPunchInData);

    this.allPunchInData = getMatchPunchData;

  }

  async fetchCurrentDatePunchInData() {
    try {
      const selectDateStr = `${this.currentDate.year}-${this.currentDate.month}-${this.currentDate.day}`;
      const putKey = `${punch_event_name.PUNCH_IN_DAILY}${selectDateStr}}`;
      const currentData = await DatabaseManager.getCurrentAllDataByKey<PersonalPunchInRecord>(putKey);
      this.currentDatePunchInData = currentData;
    } catch (err) {
      console.info('Invoke pushUrl succeeded.');
    }
  }

  // 获取到当前可以打卡的任务
  getCurrentMatchPunch(taskList: NewTaskType[]) {
      const selectDateInt = new Date(`${this.currentDate.year}-${this.currentDate.month}-${this.currentDate.day}`).getTime();
      // 时间上，如果这个打卡任务有结束时间并且，还没有结束 ||  这个卡创建时间不高于现在
      const result = taskList.reduce((prev, cur) => {
      let tmp: NewTaskType | undefined = undefined;
      if (cur?.end_time && selectDateInt >= cur.start_time && cur.end_time > selectDateInt ) {
        tmp = cur;
      }

      if (!cur.end_time && cur.start_time <= selectDateInt) {
        tmp = cur;
      }

      if (tmp !== undefined) {
        if (cur.cycleType === CycleType.WEEK) {
          const index = this.currentDayList.findIndex((idx) => idx === this.currentDate.day);
          if (index !== -1) {
            const weekIndex =  (index + 1) % 7 || 7;
            if (!cur.cycle.includes(weekIndex)) {
              tmp = undefined;
            }
          }
        } else {
          if (!cur.cycle.includes(this.currentDate.day)) {
            tmp = undefined;
          }
        }
      }

      if (tmp !== undefined) {
        prev.push(tmp);
      }

      return prev;
    }, [] as NewTaskType[]);
    return result;
  }


  dateChange() {
    const result = getDaysOfMonthWithFirstDayOfWeek(this.currentDate);
    let step = 0;
    if (result.firstDayOfWeek === 0) {
      step += 6;
    } else {
      step = result.firstDayOfWeek - 1;
    }

    if (step > 0) {
      this.currentDayList = new Array(step).fill('').concat(result.daysArray);
    } else {
      this.currentDayList = result.daysArray;
    }
  }


  changeMonth() {
    DatePickerDialog.show({
      start: new Date("2024-1-1"),
      end: new Date("2050-12-31"),
      lunar: false,
      selected: this.selectedDate,
      onAccept: (value: DatePickerResult) => {
        // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
        if (value) {
          const year = value.year;
          const month =(value?.month || 0) + 1;
          const day = value?.day;
          this.currentDate = {
            year,
            month,
            day
          };
          this.dateChange();
        }
        this.selectedDate.setFullYear(value.year, value.month, value.day);
        this.getPunchInData();
      }
    })
  }

  toAddTarget() {
    router.pushUrl({
      url: "pages/AddTarget", // 目标url
    }, router.RouterMode.Standard, (err) => {
      if (err) {
        console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('Invoke pushUrl succeeded.');
    });
  }

  // 打卡操作
  async punchInAction(item: NewTaskType) {
    try {
      const selectDateStr = `${this.currentDate.year}-${this.currentDate.month}-${this.currentDate.day}`;
      const putKey = `${punch_event_name.PUNCH_IN_DAILY}${selectDateStr}}`;
      const currentDatePunchInList = await DatabaseManager.getCurrentAllDataByKey<PersonalPunchInRecord>(putKey);
      const systemTime = await systemDateTime.getCurrentTime(false);
      if (selectDateStr !== getYMD(systemTime).dateStr) {
        showDialog("打卡失败", "未到可打卡时间 ㅤ    ㅤ    ");
        return;
      }

      const insertId = await generateNanoId(32);

      let punchData: PersonalPunchInRecord = {
        id: insertId,
        createTime: new Date().getTime(),
        punchInCollectIn: item.id,
        punchInCount: 1,
      };

      let newDataArr = currentDatePunchInList;

      if (currentDatePunchInList.length && currentDatePunchInList.find(v => v.punchInCollectIn === item.id)) {
        newDataArr = currentDatePunchInList.map(data => {
          if (data.punchInCollectIn === item.id) {
            data.punchInCount += 1;
            punchData.punchInCount = data.punchInCount;
          }
          return data;
        });
      } else {
        newDataArr = currentDatePunchInList.concat(punchData);
      }


      await DatabaseManager.set(putKey, JSON.stringify(newDataArr));
      if (punchData.punchInCount >= item.punch_count) {
        await this.addPunchInCount(item);
      }

      await this.getPunchInData();

      if (item.allow_popcard) {
        this.createTypeDialog(item.icon);
      }

      if (this.isNeedAudio) {
        this.playPunchInAudio();
      }

    } catch (err) {
      showDialog("打卡失败", "发生错误！！！ ㅤ    ㅤ    ");
    }
  }

  playPunchInAudio() {
    emitter.emit({ eventId: EventCode.PLAY_AUDIO }, { data : {
      event: AudioEvent.PAUSE
    }});
    setTimeout(() => {
      emitter.emit({ eventId: EventCode.PLAY_REMIND_AUDIO });
    }, 30)
  }

  computeProcess(item: NewTaskType) {
    if (!this.currentDatePunchInData.length) return undefined;
    const getItem = this.getCurrentPunchInMatchItem(item.id);
    return ((getItem?.punchInCount || 0) / item.punch_count) * 100;
  }


  getCurrentPunchInMatchItem(id: string) {
    if (!this.currentDatePunchInData.length) return undefined;
    return this.currentDatePunchInData.filter(item => item.punchInCollectIn === id)[0];
  }

  async addPunchInCount(taskItem: NewTaskType) {
    const currentPunchInList = await DatabaseManager.getAllPunchInData();
    const newData = currentPunchInList.map((item: NewTaskType) => {
      if (item.id === taskItem.id) {
          item.punch_days += 1;
      }
      return item;
    });
    DatabaseManager.set(punch_event_name.PUNCH_IN_ALL_DATA, JSON.stringify(newData));
  }

  fetchPunchData(index: string) {
    this.currentDate.day = Number(index);
    this.getPunchInData();
  }

  renderText(item: NewTaskType) {
    if (item?.end_time) {
      const distance = Math.floor((item.end_time - item.start_time) / 86400000);

      if (distance < 1) {
        return '打卡完成';
      }

      if (distance - item.punch_days < 1) {
        return `已坚持${item.punch_days}天`
      }

      return `已坚持${item.punch_days}天，还剩${distance - item.punch_days}天！`
    } else {
      if (item?.punch_days === 0) {
        return '自律使人进步';
      } else {
        return `已坚持${item.punch_days}天`
      }
    }
  }


  build() {
    Column() {
      Row() {
        Column() {}.width(25)

        if (this.currentDate) {
          Row() {
            Text(`${this.currentDate?.year}年${this.currentDate?.month}月`).fontSize(20).fontWeight(500)
            Image($r('app.media.caret_down')).width(15).height(15).margin({left: 5})
          }.onClick(() => this.changeMonth())
        }

        Column() {}

      }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5})


      Row() {
        GridRow({
          columns: 7,
          breakpoints: {
            value: ["400vp", "600vp", "800vp"],
            reference: BreakpointsReference.WindowSize
          },
          direction: GridRowDirection.Row
        }) {

          ForEach(['一', '二', '三', '四', '五', '六', '日'], (index: string) => {
            GridCol() {
              Row() {
                Text(index).textAlign(TextAlign.Center).fontColor(activeConfig.normal).fontSize(14).opacity(0.6)
              }.height(40)
            }
          })


          ForEach(this.currentDayList, (index: string) => {
            GridCol() {
              Row() {
                Text(index.toString()).textAlign(TextAlign.Center).fontWeight(600).zIndex(2)
                  .fontColor(this.currentDate.day === Number(index) ? "white" : activeConfig.active)
                if (index !== '' && this.currentDate.day === Number(index)) {
                  Column()
                    .backgroundColor(ColorConfig.THEME_ORANGE_COLOR)
                    .borderRadius(50)
                    .width("50%")
                    .height("50%")
                    .position({ x: "25%", y: "25%" })
                    .zIndex(1)
                  Column()
                    .backgroundColor(ColorConfig.THEME_ORANGE_COLOR)
                    .borderRadius(50)
                    .width("10%")
                    .height("10%")
                    .position({ x: "45%", y: "85%" })
                    .zIndex(1)
                }
              }.height(50).justifyContent(FlexAlign.Center).width("100%").onClick(() => {
                if (index === '') return;
                this.fetchPunchData(index);
              })
            }
          })
        }
        .padding({ left: "1%", right: "1%" })
        .margin({ top: 10 })
      }

      Row() {
        if (this.allPunchInData.length) {
          Column() {
              Row() {
                Image($r("app.media.tagfill")).width(18).height(18)
                Text("今日打卡").fontColor(activeConfig.normal).fontSize(16).margin({left: 3})
              }.alignItems(VerticalAlign.Center).margin({bottom: 3, left: "5.5%", right: "5%" , top: 10 })

              List({ scroller: this.scrollerForList}) {

                ForEach(this.allPunchInData, (item: NewTaskType, idx: number) => {
                  ListItem() {
                    Column() {
                      Row() {
                        Row() {
                          Row() {
                            Column() {
                              Image($r(item.icon)).width(45).height(45)
                            }

                            Column() {
                              Text(item.title)
                                .fontSize(18)
                                .fontWeight(600)
                                .maxLines(1)
                                .margin({ bottom: 5 })
                                .textOverflow({ overflow: TextOverflow.Clip })

                              Row() {
                                Text(this.renderText(item))
                                  .fontColor(activeConfig.normal)
                                  .fontSize(12)
                                  .margin({ right: 3 })
                                Text(`(${this.getCurrentPunchInMatchItem(item.id)?.punchInCount || 0 }/${item.punch_count})`).fontColor(activeConfig.normal).fontSize(12)
                              }.alignItems(VerticalAlign.Center)
                            }.alignItems(HorizontalAlign.Start).margin({ left: 10 }).width("53%")
                          }

                          Column() {
                            // 完成打卡
                            if ((this.getCurrentPunchInMatchItem(item.id)?.punchInCount || 0) >= item.punch_count) {
                              Image($r("app.media.punchin_ok")).width(25).height(25)
                            } else {
                              Button({ type: ButtonType.Capsule, stateEffect: true }) {
                                Row() {
                                  Image($r("app.media.calendar")).width(20).height(20).margin({ left: 15 })
                                  Text(`打卡`).fontSize(14).fontColor(0xffffff).margin({ left: 5, right: 15 })
                                }.alignItems(VerticalAlign.Center).height(38)
                              }.backgroundColor(ColorConfig.THEME_ORANGE_COLOR)
                            }
                          }.onClick(() => {
                            if ((this.getCurrentPunchInMatchItem(item.id)?.punchInCount || 0) >= item.punch_count) {
                              return;
                            }
                            this.punchInAction(item);
                          })
                        }
                        .justifyContent(FlexAlign.SpaceBetween)
                        .width("95%")
                        .margin({ left: "2.5%", right: "2.5%" })
                        .backgroundColor(ColorConfig.BOARD_BG_COLOR)
                        .padding(20)
                        .borderRadius(20)
                      }

                      Progress({ value: this.computeProcess(item), type: ProgressType.Linear })
                        .width("82%").height(2).color(ColorConfig.THEME_ORANGE_COLOR)
                        .backgroundColor(ColorConfig.BOARD_BG_COLOR)
                        .margin({bottom: -2})

                    }.margin({ top: idx === 0 ? 15 : 0, bottom: idx === (this.allPunchInData.length - 1) ? 100 : 20 })

                  }
                })
              }.scrollBar(BarState.Off).height("55%")
            }.margin({top: 10}).alignItems(HorizontalAlign.Start)
        } else {
          Column() {
            Image($r("app.media.emptylist")).width(100).height(100)
            Text("当天没有打卡任务").fontColor(activeConfig.normal).fontSize(16).margin({top: 5})
            Text("自律使人进步，点击右上角创建打卡吧").fontColor(activeConfig.normal).fontSize(12).margin({top: 5})
          }.margin({top: 50})
        }

      }
      Row() {
        Image($r('app.media.plusWhite')).width(55).height(55).opacity(0.9).padding({ left: 10, right: 10, top: 10, bottom: 10 })
      }.onClick(() => {
        this.toAddTarget();
      }).position({x: "78%", y: "85%"}).backgroundColor(ColorConfig.THEME_ORANGE_COLOR).borderRadius(50).shadow({
        radius: 15,
        color: "#d4d4d4"
      })
    }.width("100%").height("100%")
  }
}