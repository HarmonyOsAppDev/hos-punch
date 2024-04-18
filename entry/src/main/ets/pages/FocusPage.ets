import { CountDownModule } from '../components/CountDownModule';
import { PositiveCounrModule } from '../components/PositiveCounrModule';
import { RecordModule } from '../components/RecordModule';
import { TomatoModule } from '../components/TomatoModule';
import { activeConfig, bottomTabs, ColorConfig } from '../constants';
import { FocusSelectType } from '../types';
import { AudioPlayer } from '../components/AudioPlayer';

@Entry
@Component
export struct FocusPage {
  @State selectIndex: FocusSelectType = FocusSelectType.RECORD;
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
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


      AudioPlayer()

    }.width("100%").height("100%")
  }
}