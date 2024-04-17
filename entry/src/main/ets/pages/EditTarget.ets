import router from '@ohos.router'
import { showDialog, TypeDialogManager } from '../components/Dialog';
import { activeConfig, ColorConfig, punch_event_name } from '../constants';
import DatabaseManager from '../services/DatabaseManager';
import { Icon_list } from '../statics';
import { CycleType, IconItemType, NewTaskType, TargetCycleSelectType, TaskStatus,
  EditTaskRouterParamsType,
  CycleRouterType} from '../types';
import { generateNanoId } from '../utils/generate';
import { getEndTimeInit, getYMD, monthChangeStr, weekDayChangeStr } from '../utils/helper';

@Entry
@Component
export struct EditTarget {
  @State formData: NewTaskType = {
    id: "0",
    title: "默认打卡主题",
    icon: Icon_list[0].url,
    cycle: [1, 2, 3, 4, 5, 6, 7],
    cycleType: CycleType.WEEK,
    punch_count: 1,
    allow_popcard:  false,
    start_time: new Date(getYMD().dateStr).getTime(),
    support_multi: false,
    end_time: undefined,
    status: TaskStatus.NORMAL,
    punch_days: 0,
  }

  @State currentEditKey: keyof NewTaskType = "title" ;
  @State needEndTime: boolean = false;
  private scroller: Scroller = new Scroller()
  private selectedDate: Date = new Date();
  private DialogInstance: CustomDialogController | undefined = undefined;

  onPageShow() {
    if (router.getParams()) {
      const params = router.getParams() as TargetCycleSelectType;
      if (params) {
        this.formData.cycle = params.currentSelectCycles;
        this.formData.cycleType = params.currentSelectCycleType;
      }

      const paramsWithEditMode = router.getParams() as EditTaskRouterParamsType;

      if (paramsWithEditMode?.currentItem ) {
        this.formData = paramsWithEditMode.currentItem;
      }
    }
  }


  createTypeDialog(oldVal: string | number, title: string, key: keyof NewTaskType, inputType?: InputType) {
    this.currentEditKey = key;
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

  closeDialog() {
    this.DialogInstance?.close();
  }

  routerBack() {
    router.back();
  }

  dialogAccept(str: string) {
    this.formData[this.currentEditKey.toString()]= str;
    this.DialogInstance?.close();
  }

  goToSelectCyclePage() {
    router.pushUrl({
      url: "pages/TargetCycleSelect",
      params: {
        currentSelectCycles: this.formData.cycle,
        currentSelectCycleType: this.formData.cycleType,
        mode: CycleRouterType.EDIT,
      }
    })
  }

  async submitResult(): Promise<void> {
    if (this.formData.title === '') {
      return showDialog("错误提示", `打卡目标不能为空！ ㅤ    ㅤ     ㅤ  `);
    }

    if (this.formData?.end_time && (this.formData?.end_time < new Date().getTime() || this.formData?.end_time < this.formData.start_time)) {
      return showDialog("错误提示", `结束时间不能小于当前时间且不能小于开始时间！(譬如不能设置当天为结束时间) ㅤ    ㅤ     ㅤ`);
    }

    const currentPunchInList = await DatabaseManager.getAllPunchInData();

    const newData = currentPunchInList.map(item => {
       if (item.id === this.formData.id) {
         item = this.formData;
       }
      return item;
    })

    DatabaseManager.set(punch_event_name.PUNCH_IN_ALL_DATA, JSON.stringify(newData));

    router.replaceUrl({
      url: "pages/Index",
    });
  }

  build() {
    Column() {
      Row() {
      Column() {
        Image($r('app.media.back')).width(30).height(30).onClick(() => {
          this.routerBack();
        })
      }

      Row() {
        Text("编辑打卡目标").fontSize(20).fontWeight(500)
      }

        Text("保存").fontSize(16).fontWeight(400).onClick(() => {
          this.submitResult();
        })

    }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5}).margin({bottom: 15})


      Scroll(this.scroller) {
      Column() {
          Row() {
            Row() {
              Text("打卡目标").fontSize(18)
            }

            Row() {
              Text(this.formData.title || '--')
                .fontSize(18)
                .maxLines(1)
                .width("66%")
                .onClick(() => {
                  this.createTypeDialog(
                    this.formData.title,
                    "打卡目标",
                    "title"
                  );
                })
                .fontColor("#777")
                .textAlign(TextAlign.End)
                .margin({right: 5})

              Image($r("app.media.right_arrow")).width(15).height(15)
            }
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ bottom: 20, left: 15, right: 15, top: 20 })
          .width("95%")
          .backgroundColor(ColorConfig.BOARD_BG_COLOR)
          .margin({ left: "2.5%", right: "2.5%" })
          .borderRadius(30)
          .margin({ top: 10 })


          Row() {
            Row() {
              Text("挑选图标").fontSize(18)
            }

            Row() {
              Image($r(this.formData.icon)).width(40).height(40)
            }
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ bottom: 20, left: 15, right: 15, top: 20 })
          .width("95%")
          .backgroundColor(ColorConfig.BOARD_BG_COLOR)
          .margin({ left: "2.5%", right: "2.5%" })
          .borderRadius(30)
          .margin({ top: 10 })


          GridRow({
            columns: 6,
            breakpoints: {
              value: ["400vp", "600vp", "800vp"],
              reference: BreakpointsReference.WindowSize
            },
            direction: GridRowDirection.Row
          }) {

            ForEach(Icon_list, (item: IconItemType) => {
              GridCol() {
                Row() {
                  Image($r(item.url)).width(40).height(40).zIndex(2)
                  if (this.formData.icon === item.url) {
                    Column()
                      .backgroundColor(ColorConfig.THEME_ORANGE_COLOR)
                      .borderRadius(50)
                      .width("30%")
                      .height("10%")
                      .position({ x: "35%", y: "90%" })
                      .zIndex(1)
                  }
                }
                .height(60)
                .justifyContent(FlexAlign.Center)
                .width("100%")
                .onClick(() => {
                  this.formData.icon = item.url;
                })
                .key(item.id)
              }
            })
          }
          .padding({ left: "1%", right: "1%" })
          .margin({ top: 10 })


        Row() {
          Row() {
            Text("打卡周期").fontSize(18)
          }

          Row() {
            Text(this.formData.cycleType === CycleType.WEEK ? weekDayChangeStr(this.formData.cycle) : monthChangeStr(this.formData.cycle))
              .fontSize(18)
              .maxLines(1)
              .width("66%")
              .onClick(() => {
                this.goToSelectCyclePage();
              })
              .fontColor(activeConfig.normal)
              .textAlign(TextAlign.End)
              .padding({ right: 8 })

              Image($r("app.media.right_arrow")).width(15).height(15)
          }
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ bottom: 20, left: 15, right: 15, top: 20 })
        .width("95%")
        .backgroundColor(ColorConfig.BOARD_BG_COLOR)
        .margin({ left: "2.5%", right: "2.5%" })
        .borderRadius(30)
        .margin({ top: 10 })


          Row() {
            Row() {
              Text(`打卡总量`).fontSize(18)
            }

            Row() {
              Text(String(this.formData.punch_count))
                .fontSize(18)
                .maxLines(1)
                .width("50%")
                .onClick(() => {
                  this.createTypeDialog(
                    this.formData.punch_count,
                    "目标打卡数量",
                    "punch_count",
                    InputType.Number
                  );
                })
                .fontColor(activeConfig.normal)
                .textAlign(TextAlign.End)
                .padding({ right: 10 })
              Image($r("app.media.right_arrow")).width(15).height(15)
            }.margin({ right: 2 })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ bottom: 20, left: 15, right: 15, top: 20 })
          .width("95%")
          .backgroundColor(ColorConfig.BOARD_BG_COLOR)
          .margin({ left: "2.5%", right: "2.5%" })
          .borderRadius(30)
          .margin({ top: 10 })

          // Row() {
          //   Row() {
          //     Text("允许多次打卡 ").fontSize(18)
          //   }.alignItems(VerticalAlign.Center)
          //
          //   Row() {
          //     Toggle({ type: ToggleType.Switch, isOn: this.formData.support_multi })
          //       .selectedColor(ColorConfig.THEME_ORANGE_COLOR)
          //       .switchPointColor('#FFFFFF')
          //       .onChange((isOn: boolean) => {
          //         this.formData.support_multi = isOn;
          //       })
          //   }
          // }
          // .justifyContent(FlexAlign.SpaceBetween)
          // .padding({ bottom: 20, left: 15, right: 15, top: 20 })
          // .width("95%")
          // .backgroundColor("#f6f8fa")
          // .borderRadius(30)
          // .margin({ top: 10 })

          Row() {
            Row() {
              Text("打卡弹出卡片 ").fontSize(18)
            }.alignItems(VerticalAlign.Center)

            Row() {
              Toggle({ type: ToggleType.Switch, isOn: this.formData.allow_popcard })
                .selectedColor(ColorConfig.THEME_ORANGE_COLOR)
                .switchPointColor('#FFFFFF')
                .onChange((isOn: boolean) => {
                  this.formData.allow_popcard = isOn;
                })
            }
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ bottom: 20, left: 15, right: 15, top: 20 })
          .width("95%")
          .backgroundColor(ColorConfig.BOARD_BG_COLOR)
          .borderRadius(30)
          .margin({ top: 10 })


        Row() {
          Row() {
            Text("开始日期").fontSize(18)
          }

          Row() {
            Text(getYMD(this.formData.start_time).dateStr).fontColor("#328dff").fontSize(16).onClick(() => {
              DatePickerDialog.show({
                start: new Date("2000-1-1"),
                end: new Date("2100-12-31"),
                lunar: false,
                selected: this.selectedDate,
                onAccept: (value: DatePickerResult) => {
                  // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
                  if (value) {
                    const year = value.year;
                    const month =(value?.month || 0) + 1;
                    const day = value?.day;
                    this.formData.start_time = new Date(`${year}-${month}-${day}}`).getTime();
                    // this.dateStartChange();
                  }
                  this.selectedDate.setFullYear(value.year, value.month, value.day)
                },
              })
            }).margin({right: 5})
            Image($r("app.media.right_arrow")).width(15).height(15)
          }
        }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 20, left: 15, right: 15, top: 20 }).width("95%").backgroundColor(ColorConfig.BOARD_BG_COLOR).margin({left: "2.5%", right: "2.5%"}).borderRadius(30).margin({top: 10})


        Row() {
          Row() {
            Text("是否设置结束日期 ").fontSize(18)
          }.alignItems(VerticalAlign.Center)

          Row() {
            Toggle({ type: ToggleType.Switch, isOn: this.needEndTime })
              .selectedColor(ColorConfig.THEME_ORANGE_COLOR)
              .switchPointColor('#FFFFFF')
              .onChange((isOn: boolean) => {
                this.needEndTime = isOn;
                if (isOn) {
                  // 打开的时候把结束时间默认设为下个月
                  this.formData.end_time = getEndTimeInit(new Date(this.formData.start_time).getTime()).originFormat.getTime();
                }
              })
          }
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ bottom: 20, left: 15, right: 15, top: 20 })
        .width("95%")
        .backgroundColor(ColorConfig.BOARD_BG_COLOR)
        .borderRadius(30)
        .margin({ top: 10 })



        if (this.needEndTime) {
          Row() {
            Row() {
              Text("结束时间").fontSize(18)
            }

            Row() {
              Text(getYMD(this.formData.end_time).dateStr).fontColor("#328dff").fontSize(16).onClick(() => {
                DatePickerDialog.show({
                  start: new Date("2000-1-1"),
                  end: new Date("2100-12-31"),
                  lunar: false,
                  selected: new Date(this.formData.end_time),
                  onAccept: (value: DatePickerResult) => {
                    // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
                    if (value) {
                      const year = value.year;
                      const month =(value?.month || 0) + 1;
                      const day = value?.day;
                      this.formData.end_time = new Date(`${year}-${month}-${day}}`).getTime();
                      // this.dateStartChange();
                    }
                    new Date(this.formData.end_time).setFullYear(value.year, value.month, value.day)
                  },
                })
              }).margin({right: 5})
              Image($r("app.media.right_arrow")).width(15).height(15)
            }
          }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 20, left: 15, right: 15, top: 20 }).width("95%").backgroundColor(ColorConfig.BOARD_BG_COLOR).margin({left: "2.5%", right: "2.5%"}).borderRadius(30).margin({top: 10})


        }


        Column() {
          Button({ type: ButtonType.Capsule, stateEffect: false }) {
            Row() {
              Image($r("app.media.send")).width(20).height(20)
              Text("创建").fontSize(18).fontColor("white").margin({ left: 5 })
            }.alignItems(VerticalAlign.Center)
          }.height(50).width("90%").onClick(() => {
            this.submitResult();
          })
        }.margin({ top: 20 })


        }.margin({ bottom: 70 })
      }

    }.width("100%").height("100%")
  }
}