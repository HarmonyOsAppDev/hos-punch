import { CountDownModule } from '../components/CountDownModule';
import { PositiveCounrModule } from '../components/PositiveCounrModule';
import { RecordModule } from '../components/RecordModule';
import { TomatoModule } from '../components/TomatoModule';
import { activeConfig, bottomTabs } from '../constants';
import { FocusSelectType } from '../types';

@Entry
@Component
export struct FocusPage {
  @State selectIndex: FocusSelectType = FocusSelectType.RECORD;


  private controller: TabsController = new TabsController();
  @State currentIndex: number = 0
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'

  @Builder TabBuilder(index: FocusSelectType) {
    Column() {
      Text(bottomTabs[index - 1]).fontSize(14).zIndex(2)
        .fontColor(this.selectIndex === index ? "white": activeConfig.normal)
        .fontWeight(this.selectIndex  === index ? 600 : 400)
    }.padding({left: 15, right: 15, top: 12, bottom: 12})
    .backgroundColor(this.selectIndex  === index ? "#ff7f00" : undefined)
    .borderRadius(50).onClick(() => {
      this.selectIndex = index;
    })
  }


  build() {
    Column() {
      Row() {
        Column() {
          Image($r('app.media.sound')).width(25).height(25)
        }

        Column() {
          Text("专注专区").fontSize(20).fontWeight(500)
        }

        Column() {
          Image($r('app.media.musicbtn')).width(25).height(25)
        }
      }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5, bottom: 20})


      if (this.selectIndex === FocusSelectType.RECORD) {
        RecordModule();
      } else if (this.selectIndex === FocusSelectType.NEGATIVE_COUNT) {
        CountDownModule();
      } else if (this.selectIndex === FocusSelectType.POSITIVE_COUNT) {
        PositiveCounrModule();
      } else {
        TomatoModule();
      }


      Row() {
          Row() {
            Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
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
                Column()
              }.tabBar(this.TabBuilder(FocusSelectType.POMODORO))
            }
            .vertical(false)
            .barMode(BarMode.Fixed)
            .animationDuration(400)
            .onChange((index: number) => {
              this.selectIndex = index;
            }).shadow({
              radius: 10,
              color: "#aba9a9"
            }).borderRadius(35).backgroundColor("white")
          }
      }.position({x: 0, y: "90%"}).justifyContent(FlexAlign.Center).width("100%")


    }.width("100%").height("100%")
  }
}