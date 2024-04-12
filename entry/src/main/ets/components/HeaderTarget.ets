

@Component
export struct HeaderTarget {
  build() {
    Row() {
      Column() {
        Image($r('app.media.chart')).width(30).height(30)
      }
      Column() {
        Text("目标管理").fontSize(20).fontWeight(500)
      }
      Column() {
        Image($r('app.media.plus')).width(25).height(25)
      }
    }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5})
  }
}