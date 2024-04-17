import { activeConfig, ColorConfig } from '../constants';

@Component
export struct RecordModule {
  @State fakeArr: string[] = new Array(10).fill('1');

  openDeleteModal() {
    AlertDialog.show(
      {
        title: '提醒',
        message: `是否删除当前的专注记录？ ㅤ    ㅤ     `,
        autoCancel: true,
        alignment: DialogAlignment.Bottom,
        gridCount: 4,
        offset: { dx: 0, dy: -20 },
        primaryButton: {
          value: '取消',
          action: () => {
            console.info('Callback when the first button is clicked')
          }
        },
        secondaryButton: {
          enabled: true,
          defaultFocus: true,
          style: DialogButtonStyle.HIGHLIGHT,
          backgroundColor: ColorConfig.ERROR_COLOR,
          value: '保存',
          action: () => {
            console.error("hello")
          }
        },
        cancel: () => {
          console.info('Closed callbacks')
        }
      }
    )
  }

  deleteAction() {
    this.openDeleteModal();
  }

  build() {
    Column() {
      Row() {
        if (this.fakeArr.length) {
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

                        Row() {
                          Text(`3244秒`).fontColor(activeConfig.normal).fontSize(12)
                          Divider().vertical(true).height(12).color('#182431').opacity(0.6).margin({ left: 8, right: 8 })
                          Text(`2024-03-15 15:43`).fontColor(activeConfig.normal).fontSize(12)
                        }
                      }.alignItems(HorizontalAlign.Start).margin({ left: 10 }).width("65%")
                    }


                    Column() {
                      Image($r("app.media.delete")).width(25).height(25)
                    }.onClick(() => {
                       this.openDeleteModal();
                    })
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .width("90%")
                  .margin({ left: "5%", right: "5%" })
                  .backgroundColor(ColorConfig.BOARD_BG_COLOR)
                  .padding(20)
                  .borderRadius(20)
                }.margin({ top: idx === 0 ? 15 : 0, bottom: idx === (this.fakeArr.length - 1) ? 150 : 20 })

              }
            })
          }.scrollBar(BarState.Off)
        } else {
          Column() {
            Image($r("app.media.emptylist")).width(100).height(100)
            Text("没有专注记录").fontColor(activeConfig.normal).fontSize(16).margin({top: 5})
          }.margin({top: 100})
        }
      }

    }.height("100%").width("100%")
  }
}