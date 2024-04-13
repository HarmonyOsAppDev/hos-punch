import { activeConfig } from '../constants';

@Component
export struct RecordModule {
  @State fakeArr: string[] = new Array(10).fill('1');

  build() {
    Column() {
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

                      Text(`共1次，共3244秒`).fontColor(activeConfig.normal).fontSize(12)
                    }.alignItems(HorizontalAlign.Start).margin({ left: 10 }).width("65%")
                  }


                  Column() {
                    Image($r("app.media.delete")).width(25).height(25)
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

    }.height("100%").width("100%")
  }
}