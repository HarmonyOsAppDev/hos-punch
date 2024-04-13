import { activeConfig, timeConfig } from '../constants';
import {  TimeConfigType } from '../types';

@Component
export struct PositiveCounrModule {

  @State timeConfigState: TimeConfigType[] = timeConfig;



  build() {
    Column() {
      Row() {
        Row() {
          Image($r("app.media.historylist")).width(18).height(18).margin({right: 3})
          Text("历史记录").fontSize(14).fontColor("#ea8a4e")
        }
        .margin({top: 5, left: 5, right: 5}).padding({left: 8, right: 8, top: 4, bottom: 4})
        .backgroundColor("rgba(255, 185, 115, 0.26)")
        .borderRadius(15)

      }.justifyContent(FlexAlign.End).width("100%").margin({right: 15, top: 5})



      Column() {
        Text("00:00").fontSize(80).fontWeight(600).fontColor(activeConfig.active)


        Image($r("app.media.tabicon_xianhualvzhi")).width(60).height(60).margin({top: 30})

        Button("开始").backgroundColor("white").fontColor(activeConfig.active).border({
          width: 1,
          color: activeConfig.active,
        }).borderRadius(8).padding({left: 40, right: 40 }).type(ButtonType.Normal).fontSize(16).margin({top: 30})


      }.justifyContent(FlexAlign.Center).margin({ top: "20%"})


    }
  }
}