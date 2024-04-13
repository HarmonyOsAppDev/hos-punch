import router from '@ohos.router';
import { activeConfig, cycleList, weekDayMap } from '../constants';
import { TargetCycleSelectType, TargetTabType, CurrentSelectedDataType, CycleType } from '../types';


@Entry
@Component
export struct TargetCycleSelect {
  @State currentSelectCycles: number[] = [];

  @State currentSelectCycleType: CycleType = CycleType.WEEK;
  @State selectIndex: CycleType = CycleType.WEEK;

  private originWeekAllDate: number[] = [1, 2, 3, 4, 5, 6, 7]
  private originMonthAllDate: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]

  @State CurrentSelectedData: CurrentSelectedDataType = {
    weekData: this.originWeekAllDate,
    monthData: this.originMonthAllDate,
  }

  // tab
  isSelected(index: number) {
    return this.selectIndex === index;
  }

  onPageShow() {
    if (router.getParams()) {
      const params = router.getParams() as TargetCycleSelectType;
      if (params) {
        this.currentSelectCycles = params.currentSelectCycles;
        this.currentSelectCycleType = params.currentSelectCycleType;

        if (params.currentSelectCycleType === CycleType.MONTH) {
          this.selectIndex = CycleType.MONTH;
          this.CurrentSelectedData.monthData = params.currentSelectCycles;
        } else {
          this.CurrentSelectedData.weekData = params.currentSelectCycles;
        }
      }
    }
  }

  changeTabIndex(index: number) {
    this.selectIndex = index;
    this.currentSelectCycleType = index;
  }


  goBack() {
      let result = this.currentSelectCycles ;
    // if (getMatchItemCollect) {
    //   const path = this.enterType === PageType.ADD ? "pages/WriteDaily" : "pages/EditDaily";
      if (this.currentSelectCycleType === CycleType.WEEK) {
        result = this.CurrentSelectedData.weekData.sort((a, b) => a - b);
      } else {
        result = this.CurrentSelectedData.monthData.sort((a, b) => a - b);
      }

      router.back({
        url: "pages/AddTarget",
        params: {
          currentSelectCycles: result,
          currentSelectCycleType: this.currentSelectCycleType
        }
      })
    // }
  }

  build() {
    Column() {
      Row() {
        Column() {
          Image($r('app.media.back')).width(25).height(25).onClick(() => {
            this.goBack();
          })
        }

        Column() {
          Text("选择打卡周期").fontSize(20).fontWeight(500)
        }

        Text("保存").fontSize(16).fontWeight(400).onClick(() => {
          this.goBack();
        })

      }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5, bottom: 10})

      Column() {
        List() {
          ForEach(cycleList, (item: TargetTabType) => {
            ListItem() {
              Column() {
                Text(item.str)
                  .fontSize(16)
                  .fontColor(this.isSelected(item.id) ? activeConfig.active : activeConfig.normal)
                  .fontWeight(this.isSelected(item.id) ? 600 : 400)
                if (this.isSelected(item.id)) {
                  Column() {
                  }.width(20).height(3).backgroundColor("#ff7f00").margin({ top: 10 }).borderRadius(10)
                }
              }.justifyContent(FlexAlign.Center).onClick(() => this.changeTabIndex(item.id))
            }.padding({ left: 20, right: 20 })
          })
        }.listDirection(Axis.Horizontal).margin({ top: 10 }).height(40)
      }.justifyContent(FlexAlign.Start)

      if (this.selectIndex === CycleType.WEEK) {

        GridRow({
          columns: 4,
          breakpoints: { value: ["400vp", "600vp", "800vp"],
            reference: BreakpointsReference.WindowSize },
          direction: GridRowDirection.Row
        }) {


          ForEach(this.originWeekAllDate, (val: number) => {
            GridCol() {
              Row() {
                Text(weekDayMap[String(val - 1)]).textAlign(TextAlign.Center).fontWeight(600).zIndex(2)
                .fontColor(this.CurrentSelectedData.weekData.includes(val) ? "white" : activeConfig.active)
                if (this.CurrentSelectedData.weekData.includes(val)) {
                  Column().backgroundColor("#ff7f00").borderRadius(50).width("70%").height("50%").position({x: "15%", y: "25%"}).zIndex(1)
                }
              }.height(50).justifyContent(FlexAlign.Center).width("100%").onClick(() => {

                  if (this.CurrentSelectedData.weekData.includes(val)) {
                    this.CurrentSelectedData.weekData = this.CurrentSelectedData.weekData.filter((v) => v !== val);
                  } else {
                    this.CurrentSelectedData.weekData = this.CurrentSelectedData.weekData.concat(val)
                  }
              })
            }
          })
        }
        .padding({left: "1%", right: "1%"})
        .margin({top: 10})

      } else {

        GridRow({
          columns: 7,
          breakpoints: { value: ["400vp", "600vp", "800vp"],
            reference: BreakpointsReference.WindowSize },
            direction: GridRowDirection.Row
        }) {


          ForEach(this.originMonthAllDate, (val: number) => {
            GridCol() {
              Row() {
                Text(String(val)).textAlign(TextAlign.Center).fontWeight(600).zIndex(2)
                  .fontColor(this.CurrentSelectedData.monthData.includes(val) ? "white" : activeConfig.active)
                if (this.CurrentSelectedData.monthData.includes(val)) {
                  Column().backgroundColor("#ff7f00").borderRadius(50).width("50%").height("50%").position({x: "25%", y: "25%"}).zIndex(1)
                }
              }.height(50).justifyContent(FlexAlign.Center).width("100%")
              .onClick(() => {
                if (this.CurrentSelectedData.monthData.includes(val)) {
                  this.CurrentSelectedData.monthData = this.CurrentSelectedData.monthData.filter((v) => v !== val);
                } else {
                  this.CurrentSelectedData.monthData =  this.CurrentSelectedData.monthData.concat(val)
                }
              })
            }
          })
        }
        .padding({left: "1%", right: "1%"})
        .margin({top: 10})
      }


    }.width("100%").height("100%")
  }
}