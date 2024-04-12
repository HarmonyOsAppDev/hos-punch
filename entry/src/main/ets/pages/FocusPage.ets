import { activeConfig, bottomTabs } from '../constants';
import { FocusSelectType } from '../types';

@Entry
@Component
export struct FocusPage {
  @State selectIndex: FocusSelectType = FocusSelectType.RECORD;



  build() {
    Column() {
      Row() {
        Column() {
          Image($r('app.media.chart')).width(30).height(30).opacity(0)
        }

        Column() {
          Text("专注专区").fontSize(20).fontWeight(500)
        }

        Column() {
          Image($r('app.media.plus')).width(25).height(25).opacity(0)
        }
      }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5})


      Row() {
          Row() {
            ForEach(bottomTabs, (item: string, index: number) => {
              Column() {
                Text(item).fontSize(14).zIndex(2)
                  .fontColor(this.selectIndex - 1 === index ? "white": activeConfig.normal)
                  .fontWeight(this.selectIndex - 1 === index ? 600 : 400)
              }.padding({left: 15, right: 15, top: 8, bottom: 8}).margin({ left: 2 , right: 2  })
              .backgroundColor(this.selectIndex - 1 === index ? "#ff7f00" : undefined)
              .borderRadius(50).onClick(() => {
                this.selectIndex = index + 1;
              })
            })

            // Column() {
            //   Text("记录").fontSize(16).zIndex(2)
            // }.padding({left: 15, right: 15, top: 8, bottom: 8}).margin({ right: 5}).backgroundColor("#ff7f00").borderRadius(50).onClick(() => {
            //   this.selectIndex = FocusSelectType.RECORD
            // })
            //
            // Column() {
            //   Text("正计时").fontSize(16)
            // }.padding({left: 5, right: 5}).onClick(() => {
            //   this.selectIndex = FocusSelectType.POSITIVE_COUNT
            // })
            //
            // Column() {
            //   Text("倒计时").fontSize(16)
            // }.padding({left: 5, right: 5}).onClick(() => {
            //   this.selectIndex = FocusSelectType.NEGATIVE_COUNT
            // })
            //
            // Column() {
            //   Text("番茄钟").fontSize(16)
            // }.padding({left: 5, right: 5}).onClick(() => {
            //   this.selectIndex = FocusSelectType.POMODORO
            // })

          }.shadow({
            radius: 5,
            color: "#aba9a9"
          }).borderRadius(50).padding({left: 2, right: 2, top: 3, bottom: 3})
      }.position({x: 0, y: "90%"}).justifyContent(FlexAlign.Center).width("100%")


    }.width("100%").height("100%")
  }
}