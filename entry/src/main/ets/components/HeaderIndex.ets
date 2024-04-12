

@Component
export struct HeaderIndex {
  build() {
    Row() {
      Column() {
        Image($r('app.media.chart')).width(30).height(30).opacity(0)
      }
      Row() {
        Text("2024年4月").fontSize(20).fontWeight(500)
        Image($r('app.media.caret_down')).width(15).height(15).margin({left: 5})
      }
      Column() {
        Image($r('app.media.plus')).width(25).height(25)
      }
    }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5})
  }
}