import { HeaderTarget } from '../components/HeaderTarget'
import { tabList, activeConfig, ColorConfig, punch_event_name, EventCode } from '../constants';
import { NewTaskType, SelectEnum, TargetPageType, TargetTabType } from "../types"
import { SwipeRefresher } from '@ohos.arkui.advanced.SwipeRefresher';
import DatabaseManager from '../services/DatabaseManager';
import router from '@ohos.router';
import emitter from '@ohos.events.emitter';

@Entry
@Component
export struct TargetPage {
  @State selectIndex: SelectEnum = SelectEnum.PROCESS;
  @State list: NewTaskType[] = [];
  @State setLoading: boolean = false;
  @State currentOpenMenuItem: NewTaskType | undefined = undefined;

  @Builder MenuBuilder() {
    Flex({ direction: FlexDirection.Column }) {
      Row() {
        Image($r("app.media.edit")).width(18).height(18)
        Text('编辑').fontSize(16).fontColor(ColorConfig.NORMAL_COLOR).margin({left: 5})
      }.alignItems(VerticalAlign.Center).padding({ left: 12, top: 12, bottom: 10 }).justifyContent(FlexAlign.Start).onClick(() => {
        this.goToTargetDataView();
      })

      Row() {
        Image($r("app.media.deleteAction")).width(18).height(18)
        Text('删除').fontSize(16).fontColor(ColorConfig.ERROR_COLOR).margin({left: 5})
      }.alignItems(VerticalAlign.Center).padding({ left: 12, top: 10, bottom: 12 }).justifyContent(FlexAlign.Start).onClick(() => {
        this.openDeleteModal();
      })
    }.borderRadius(5)
    .width(105)
  }

  isSelected(index: number) {
    return this.selectIndex === index;
  }

  async changeTabIndex(index: SelectEnum) {
    this.selectIndex = index;
    await this.changeTabWithData(index);
    this.setLoading = false;
  }

  async changeTabWithData(index: SelectEnum) {
    const getResult = await DatabaseManager.getAllPunchInData();
    const dataSet = this.handleData(getResult);
    this.list = dataSet[index];
  }

  goToTargetDataView() {
    if (this.currentOpenMenuItem) {
      router.pushUrl({
        url: "pages/EditTarget",
        params: {
          currentItem: this.currentOpenMenuItem
        }
      })
    }
  }

  openDeleteModal() {
    if (this.currentOpenMenuItem) {
      const data = this.currentOpenMenuItem;
      AlertDialog.show(
        {
          title: '删除提醒',
          message: `是否删除当前${data.title}计划? 关联打卡记录不会被删除`,
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
            value: '确认',
            action: () => {
              this.deleteAction();
            }
          },
          cancel: () => {
            console.info('Closed callbacks')
          }
        }
      )
    }
  }

  async deleteAction() {
    if (this.currentOpenMenuItem?.id) {
      const allPunchData = await DatabaseManager.getAllPunchInData();
      const temp = allPunchData.filter(item => item.id !== this.currentOpenMenuItem?.id);
      DatabaseManager.set(punch_event_name.PUNCH_IN_ALL_DATA, JSON.stringify(temp));
      this.changeTabIndex(this.selectIndex);
      emitter.emit({
        eventId: EventCode.DELETE_ACTION,
        priority: emitter.EventPriority.HIGH,
      }, {});
    }
  }

  aboutToAppear(): void {
    this.changeTabWithData(SelectEnum.PROCESS)
  }

  handleData(list: NewTaskType[]): TargetPageType {
    const process:  NewTaskType[] = [];
    const isOver:  NewTaskType[] = [];
    const unBegin:  NewTaskType[] = [];
    const currentDate = new Date().getTime();

    list.forEach((item) => {
        if (item.start_time > currentDate) {
          unBegin.push(item);
        }

        if ((item?.end_time && currentDate < item?.end_time) || currentDate >= item.start_time) {
          process.push(item)
        }

        if (item?.end_time && currentDate >= item?.end_time) {
          isOver.push(item);
        }
    });

    return {
      0: process,
      1: isOver,
      2: unBegin,
      3: list,
    }
  }

  renderText(item: NewTaskType) {
    if (this.selectIndex === SelectEnum.UN_START) {
      return '未开始';
    }
    if (item?.end_time) {
      const distance = Math.floor((item.end_time - item.start_time) / 86400000);

      if (distance < 1) {
        return '打卡已完成，恭喜你';
      }

      return `已坚持${item.punch_days}天，还剩${distance - item.punch_days}天！`
    } else {
      if (item?.punch_days === 0) {
        return '自律使人痛苦';
      } else {
        return `已坚持${item.punch_days}天`
      }
    }
  }

  build() {
    Column() {
      HeaderTarget()
      Column() {
        List() {
          ForEach(tabList, (item: TargetTabType) => {
            ListItem() {
              Column() {
                Text(item.str)
                  .fontSize(16)
                  .fontColor(this.isSelected(item.id) ? activeConfig.active : activeConfig.normal)
                  .fontWeight(this.isSelected(item.id) ? 600 : 400)
                  if (this.isSelected(item.id)) {
                    Column() {
                    }.width(20).height(4).backgroundColor(ColorConfig.THEME_ORANGE_COLOR).margin({ top: 10 }).borderRadius(10)
                  }
              }.justifyContent(FlexAlign.Center).onClick(() => {
                this.setLoading = true;
                this.changeTabIndex(item.id)
              })
            }.width("25%")
          })
        }.listDirection(Axis.Horizontal).margin({ top: 20 }).height(40)
      }.justifyContent(FlexAlign.Start)

      Row() {
        if (this.setLoading) {
          SwipeRefresher({
            content: '正在加载中',
            isLoading: true
          })
        }

        if (this.list.length) {
          List() {
            ForEach(this.list, (item: NewTaskType, idx: number) => {
              ListItem() {
                Row() {
                  Row() {
                    Row() {
                      Column() {
                        Image($r(item.icon)).width(45).height(45)
                      }

                      Column() {
                        Text(item.title)
                          .fontSize(18)
                          .fontWeight(600)
                          .maxLines(1)
                          .margin({ bottom: 5 })
                          .textOverflow({ overflow: TextOverflow.Clip })

                        Text(this.renderText(item)).fontColor(activeConfig.normal).fontSize(12)
                      }.alignItems(HorizontalAlign.Start).margin({ left: 10 }).width("65%")
                    }


                    Column() {
                      Image($r("app.media.moreoptions")).width(30).height(28).bindMenu(this.MenuBuilder,
                        {
                          preview: MenuPreviewMode.IMAGE,
                          previewAnimationOptions: {scale: [0.8, 1.0]}
                        }
                       ).onClick(() => {
                         this.currentOpenMenuItem = item;
                      })
                    }
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .width("90%")
                  .margin({ left: "5%", right: "5%" })
                  .backgroundColor(ColorConfig.BOARD_BG_COLOR)
                  .padding(20)
                  .borderRadius(20)
                }.margin({ top: idx === 0 ? 15 : 0, bottom: idx === (this.list.length - 1) ? 150 : 20 })

              }
            })
          }.scrollBar(BarState.Off)
        } else {
          Column() {
            Image($r("app.media.emptylist")).width(100).height(100)
            Text("当前状态列表为空").fontColor(activeConfig.normal).fontSize(16).margin({top: 5})
          }.margin({top: 50})
        }
      }
    }.width("100%").height("100%")
  }
}