import { CountDownModule } from '../components/CountDownModule';
import { PositiveCounrModule } from '../components/PositiveCounrModule';
import { RecordModule } from '../components/RecordModule';
import { TomatoModule } from '../components/TomatoModule';
import { activeConfig, bottomTabs, ColorConfig, music_config } from '../constants';
import { FocusSelectType } from '../types';

@Entry
@Component
export struct FocusPage {
  @State selectIndex: FocusSelectType = FocusSelectType.RECORD;
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State musicRepo: string[]  = music_config;
  @State currentMusicIndex: number = 0;

  private tabController: TabsController = new TabsController();

  @Builder TabBuilder(index: FocusSelectType) {
    Column() {
      Text(bottomTabs[index]).fontSize(14).zIndex(2)
        .fontColor(this.selectIndex === index ? "white": activeConfig.normal)
        .fontWeight(this.selectIndex  === index ? 600 : 400)
        .onClick(() => {
          this.selectIndex = index;
          this.tabController.changeIndex(this.selectIndex);
        })
    }.padding({left: 15, right: 15, top: 12, bottom: 12})
    .backgroundColor(this.selectIndex  === index ? ColorConfig.THEME_ORANGE_COLOR : undefined)
    .borderRadius(50)
  }


  build() {
    Column() {
      Row() {
        Column() {}.width(25)

        Column() {
          Text("专注专区").fontSize(20).fontWeight(500)
        }

        Column() {}.width(25)
      }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5, bottom: 10})



      Row() {
          Row() {
            Tabs({ barPosition: BarPosition.Start, controller: this.tabController,  index: this.selectIndex }) {
              TabContent() {
                RecordModule();
              }.tabBar(this.TabBuilder(FocusSelectType.RECORD))

              TabContent() {
                PositiveCounrModule()
              }.tabBar(this.TabBuilder(FocusSelectType.POSITIVE_COUNT))

              TabContent() {
                CountDownModule();
              }.tabBar(this.TabBuilder(FocusSelectType.NEGATIVE_COUNT))

              TabContent() {
                TomatoModule();
              }.tabBar(this.TabBuilder(FocusSelectType.POMODORO))
            }
            .vertical(false)
            .animationDuration(400)
            .onChange((index: number) => {
              this.selectIndex = index;
            })
          }
      }.justifyContent(FlexAlign.Center).width("100%")


      Row() {
        Row() {
          Row() {
            Row() {
              Image($r("app.media.tabicon_shousifantuan")).width(60).height(60).borderRadius(50)

              Column() {
                Text("下雨白噪音").fontSize(16).fontWeight(400).fontColor(activeConfig.active)
                Blank().height(3)
                Text("正在播放").fontSize(12).fontWeight(400).fontColor(activeConfig.normal).opacity(0.6);
              }.alignItems(HorizontalAlign.Start)
            }

            Row() {
              Image($r('app.media.playBtn')).width(25).height(25).opacity(0.6)
              Blank().width(15)
              Image($r('app.media.chooseSong')).width(25).height(25).opacity(0.6).onClick(() => {
                TextPickerDialog.show({
                  range: this.musicRepo,
                  selected: this.currentMusicIndex,
                  onAccept: (value: TextPickerResult) => {
                    this.currentMusicIndex = value.index[0];
                    console.info("TextPickerDialog:onAccept()" + JSON.stringify(value))
                  },
                })
              })
            }.margin({right: 15})
          }.justifyContent(FlexAlign.SpaceBetween).width("100%")
        }.width("85%").borderRadius(25).backgroundColor("white")
        .shadow({
          radius: 15,
          color: "#d4d4d4"
        })

      }.position({ x: 0, y: "88%" }).width("100%").justifyContent(FlexAlign.Center)

    }.width("100%").height("100%")
  }
}