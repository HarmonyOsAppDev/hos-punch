import { activeConfig, ColorConfig } from '../constants'
import { CycleType, NewTaskType, SelectDateType } from '../types'
import { getDaysOfMonthWithFirstDayOfWeek, getYMD } from '../utils/helper'
import router from '@ohos.router'
import DatabaseManager from '../services/DatabaseManager'
import systemDateTime from '@ohos.systemDateTime'
import { showDialog } from '../components/Dialog'

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
  selectedDate: Date = new Date();
  private scrollerForList: Scroller = new Scroller()

  async aboutToAppear() {
    this.dateChange();
    await this.getPunchInData();
  }

  // 获取当前对应的打卡
  async getPunchInData() {
    const allPunchInData = await DatabaseManager.getAllPunchInData();
    const getMatchPunchData = this.getCurrentMatchPunch(allPunchInData);
    this.allPunchInData = getMatchPunchData;
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
  async punchInAction() {
    const systemTime = await systemDateTime.getCurrentTime(false);
    const selectDateStr = `${this.currentDate.year}-${this.currentDate.month}-${this.currentDate.day}`;
    if (selectDateStr !== getYMD(systemTime).dateStr) {
        showDialog("打卡失败", "未到可打卡时间 ㅤ    ㅤ    ")
    }
  }

  fetchPunchData(index: string) {
    this.currentDate.day = Number(index);
    this.getPunchInData();
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

                            Text(`已坚持4天，还剩27天！`).fontColor(activeConfig.normal).fontSize(12)
                          }.alignItems(HorizontalAlign.Start).margin({ left: 10 }).width("65%")
                        }

                        Column() {
                          Image($r(idx === 0 ? "app.media.punchin" : "app.media.punchin_ok")).width(25).height(25)
                        }.onClick(() => {
                            this.punchInAction();
                        })
                      }
                      .justifyContent(FlexAlign.SpaceBetween)
                      .width("90%")
                      .margin({ left: "5%", right: "5%" })
                      .backgroundColor("#f6f8fa")
                      .padding(20)
                      .borderRadius(20)
                      .onClick(() => {
                        // this.goToTargetDataView()
                      })
                    }.margin({ top: idx === 0 ? 15 : 0, bottom: idx === (this.allPunchInData.length - 1) ? 100 : 20 })

                  }
                })
              }.scrollBar(BarState.Off).height("55%")
            }.margin({top: 10}).alignItems(HorizontalAlign.Start)
        } else {
          Column() {
            Image($r("app.media.emptylist")).width(100).height(100)
            Text("当天没有打卡任务").fontColor(activeConfig.normal).fontSize(16).margin({top: 5})
            Text("自律使人痛苦，点击右上角创建打卡吧").fontColor(activeConfig.normal).fontSize(12).margin({top: 5})
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