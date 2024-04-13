import { activeConfig } from '../constants'
import { SelectDateType } from '../types'
import { getDaysOfMonthWithFirstDayOfWeek } from '../utils/helper'
import router from '@ohos.router'

@Entry
@Component
export struct HomePage {
  @State currentDayList: number[] = []
  @State currentDate: SelectDateType = {
    year: new Date().getFullYear(),
    month: new Date().getMonth() + 1,
    day: new Date().getDate(),
  }
  @State fakeArr: string[] = new Array(2).fill('1');
  selectedDate: Date = new Date();

  aboutToAppear() {
    this.dateChange();
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
        this.selectedDate.setFullYear(value.year, value.month, value.day)
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

  build() {
    Column() {
      Row() {
        Column() {
          Image($r('app.media.chart')).width(30).height(30).opacity(0)
        }

        if (this.currentDate) {
          Row() {
            Text(`${this.currentDate?.year}年${this.currentDate?.month}月`).fontSize(20).fontWeight(500)
            Image($r('app.media.caret_down')).width(15).height(15).margin({left: 5})
          }.onClick(() => this.changeMonth())
        }

        Column() {
          Image($r('app.media.plus')).width(25).height(25)
        }.onClick(() => {
          this.toAddTarget();
        })

      }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5})


      GridRow({
        columns: 7,
        breakpoints: { value: ["400vp", "600vp", "800vp"],
          reference: BreakpointsReference.WindowSize },
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
                Column().backgroundColor("#ff7f00").borderRadius(50).width("50%").height("50%").position({x: "25%", y: "25%"}).zIndex(1)
                Column().backgroundColor("#ff7f00").borderRadius(50).width("10%").height("10%").position({x: "45%", y: "85%"}).zIndex(1)
              }
            }.height(50).justifyContent(FlexAlign.Center).width("100%").onClick(() => {
              if (index === '') return;
              this.currentDate.day = Number(index);
            })
          }
        })
      }
      .padding({left: "1%", right: "1%"})
      .margin({top: 10})



      Row() {
        List() {
          ForEach(this.fakeArr, (item: string, idx: number) => {
            ListItem() {
              Row() {
                Row() {
                  Row() {
                    Column() {
                      Image($r("app.media.tabicon_zhongcanchaocai")).width(45).height(45)
                    }

                    Column() {
                      Text("劳烦广大旅客将考虑到是否快乐的实力开发商的洛克菲勒宽松短款礼服")
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
                  }
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
              }.margin({ top: idx === 0 ? 15 : 0, bottom: idx === (this.fakeArr.length - 1) ? 150 : 20 })

            }
          })
        }.scrollBar(BarState.Off)
      }









    }.width("100%").height("100%")
  }
}