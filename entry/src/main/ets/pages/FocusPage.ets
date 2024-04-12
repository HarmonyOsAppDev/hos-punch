import { activeConfig, bottomTabs, timeConfig } from '../constants';
import { FocusSelectType, TimeConfigType } from '../types';

@Entry
@Component
export struct FocusPage {
  @State selectIndex: FocusSelectType = FocusSelectType.RECORD;
  @State timeConfigState: TimeConfigType[] = timeConfig;
  @State selectTimeIndex: number = timeConfig[0].id;
  scroller: Scroller = new Scroller()


  changeTimeIndex(index: number) {
    this.selectTimeIndex = index;
  }

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


      Scroll(this.scroller) {
        Row() {
          ForEach(this.timeConfigState, (item: TimeConfigType, index: number) => {
            Column() {
              Text(item.str)
                .height(30)
                .fontSize(14)
                .textAlign(TextAlign.Center)
                .fontColor(this.selectTimeIndex === item.id ? "#ff7f00" : activeConfig.normal)


            }.padding({left: 15, right: 15}).backgroundColor(this.selectTimeIndex === item.id ? "#f1f3f4" : undefined).borderRadius(20).onClick(() => {
              this.scroller.scrollToIndex(index)
              this.changeTimeIndex(item.id);
            })
          })
        }.padding({left: 15, right: 15}).margin({ top: 15 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)  // 滚动条常驻显示
      .edgeEffect(EdgeEffect.None)

      Row() {
        Row() {
          Image($r("app.media.historylist")).width(18).height(18).margin({right: 3})
          Text("历史记录").fontSize(14).fontColor("#ea8a4e")
        }
        .margin({top: 5, left: 5, right: 5}).padding({left: 8, right: 8, top: 4, bottom: 4})
        .backgroundColor("rgba(255, 185, 115, 0.26)")
        .borderRadius(15)

        Row() {
          Image($r("app.media.settingentry")).width(18).height(18).margin({right: 3})
          Text("设置").fontSize(14).fontColor("#ea8a4e")
        }
        .margin({top: 5, left: 5, right: 5}).padding({left: 8, right: 8, top: 4, bottom: 4})
        .backgroundColor("rgba(255, 185, 115, 0.26)")
        .borderRadius(15)

      }.justifyContent(FlexAlign.End).width("100%").margin({right: 15, top: 5})



      Column() {
        Text("10:00").fontSize(80).fontWeight(600).fontColor(activeConfig.active)


        Image($r("app.media.tabicon_xianhualvzhi")).width(60).height(60).margin({top: 30})

        Button("开始").backgroundColor("white").fontColor(activeConfig.active).border({
          width: 1,
          color: activeConfig.active,
        }).borderRadius(8).padding({left: 40, right: 40 }).type(ButtonType.Normal).fontSize(16).margin({top: 30})


      }.justifyContent(FlexAlign.Center).margin({ top: "20%"})




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

          }.shadow({
            radius: 5,
            color: "#aba9a9"
          }).borderRadius(50).padding({left: 2, right: 2, top: 3, bottom: 3})
      }.position({x: 0, y: "90%"}).justifyContent(FlexAlign.Center).width("100%")


    }.width("100%").height("100%")
  }
}