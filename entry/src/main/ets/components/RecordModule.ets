import { activeConfig, ColorConfig, EventCode } from '../constants';
import DatabaseManager from '../services/DatabaseManager';
import { TimeRecordType } from '../types';
import { getYMD } from '../utils/helper';
import emitter from '@ohos.events.emitter';
import { Icon_list } from '../statics';

@Component
export struct RecordModule {
  @State fakeArr: string[] = new Array(10).fill('1');
  @State records: TimeRecordType[] = [];

  aboutToAppear(): void {
    this.getRecordInData();

    emitter.on({eventId: EventCode.REFRESH_RECORD}, () => {
        this.getRecordInData();
    });
  }

  aboutToDisappear(): void {
    emitter.off(EventCode.REFRESH_RECORD);
  }

  // 获取当前对应的打卡
  async getRecordInData() {
    const allPunchInData = await DatabaseManager.getAllFocusRecord();
    this.records = allPunchInData;
  }

  openDeleteModal(item: TimeRecordType) {
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
          value: '删除',
          action: () => {
            this.deleteDispatch(item);
          }
        },
        cancel: () => {
          console.info('Closed callbacks')
        }
      }
    )
  }

  async deleteDispatch(data: TimeRecordType) {
    const key = data.ownerKey;
    const allData = await DatabaseManager.getCurrentAllDataByKey<TimeRecordType>(key);
    const temp = allData.filter(item => item.id !== data?.id);
    await DatabaseManager.set(key, JSON.stringify(temp));
    this.getRecordInData();
  }


  build() {
    Column() {
      Row() {
        if (this.records.length) {
          List() {
            ForEach(this.records, (item: TimeRecordType, idx: number) => {
              ListItem() {
                Row() {
                  Row() {
                    Row() {
                      Column() {
                        Image($r(Icon_list[8].url)).width(45).height(45)
                      }
                      Column() {
                        Text(item.title)
                          .fontSize(16)
                          .fontWeight(600)
                          .maxLines(1)
                          .margin({ bottom: 5 })

                        Row() {
                          Text(`${item.focusTime.toString()}秒`).fontColor(activeConfig.normal).fontSize(12)
                          Divider().vertical(true).height(12).color('#182431').opacity(0.6).margin({ left: 8, right: 8 })
                          Text(getYMD(item.createTime).dateStrHHMM).fontColor(activeConfig.normal).fontSize(12)
                        }
                      }.alignItems(HorizontalAlign.Start).margin({ left: 10 }).width("75%")
                    }


                    Column() {
                      Image($r("app.media.delete")).width(25).height(25)
                    }.onClick(() => {
                       this.openDeleteModal(item);
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