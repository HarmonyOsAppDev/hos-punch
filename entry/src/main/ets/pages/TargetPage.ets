import { HeaderTarget } from '../components/HeaderTarget'
import { tabList, activeConfig } from '../constants';
import { SelectEnum, TargetTabType } from "../types"


@Entry
@Component
export struct TargetPage {
  @State selectIndex: SelectEnum = SelectEnum.PROCESS;
  @State fakeArr: string[] = new Array(10).fill('1');

  isSelected(index: number) {
    return this.selectIndex === index;
  }

  changeTabIndex(index: number) {
    this.selectIndex = index;
  }

  goToTargetDataView() {

  }

  build() {
    Column() {
      HeaderTarget()
      Column() {
        List() {
          ForEach(tabList, (item: TargetTabType, index: number) => {
            ListItem() {
              Column() {
                Text(item.str)
                  .fontSize(16)
                  .fontColor(this.isSelected(index) ? activeConfig.active : activeConfig.normal)
                  .fontWeight(this.isSelected(index) ? 600 : 400)
                if (this.isSelected(index)) {
                  Column() {
                  }.width(20).height(3).backgroundColor("#ff7f00").margin({ top: 10 }).borderRadius(10)
                }
              }.justifyContent(FlexAlign.Center).onClick(() => this.changeTabIndex(index))
            }.padding({ left: 20, right: 20 })
          })
        }.listDirection(Axis.Horizontal).margin({ top: 15 }).height(40)
      }.justifyContent(FlexAlign.Start)

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
                    Image($r("app.media.right_circle_arrow")).width(25).height(25)
                  }
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width("90%")
                .margin({ left: "5%", right: "5%" })
                .backgroundColor("#f6f8fa")
                .padding(20)
                .borderRadius(20)
                .onClick(() => {
                  this.goToTargetDataView()
                })
              }.margin({ top: idx === 0 ? 15 : 0, bottom: idx === (this.fakeArr.length - 1) ? 150 : 20 })

            }
          })
        }.scrollBar(BarState.Off)
      }
    }.width("100%").height("100%")
  }
}