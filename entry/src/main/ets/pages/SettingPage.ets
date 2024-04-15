import router from '@ohos.router'
import { ColorConfig } from '../constants'

@Entry
@Component
export struct SettingPage {
  build() {
    Column() {
      Row() {
        Column() {}.width(25)

        Column() {
          Text("设置").fontSize(20).fontWeight(500)
        }

        Column() {}.width(25)
      }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5})


      Row() {
        Row() {
          Text("打卡完成声音 ").fontSize(16).fontWeight(500)
        }.alignItems(VerticalAlign.Center)

        Row() {
          Toggle({ type: ToggleType.Switch, isOn: false })
            .selectedColor(ColorConfig.THEME_ORANGE_COLOR)
            .switchPointColor('#FFFFFF')
            .onChange((isOn: boolean) => {
              // this.isTop = isOn;
            })
        }
      }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 10, left: 15, right: 15, top: 10 }).width("90%").backgroundColor("#f6f8fa").borderRadius(15).margin({top: 20})


      Row() {
        Row() {
          Text("隐私政策 ").fontSize(16).fontWeight(500)
        }.alignItems(VerticalAlign.Center)

        Row() {
          Column() {
            Image($r('app.media.right_arrow')).width(20).height(20)
          }.height(30).justifyContent(FlexAlign.Center)
        }
      }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 10, left: 15, right: 15, top: 10 }).width("90%").backgroundColor("#f6f8fa").borderRadius(15).margin({top: 20}).onClick(() => {
        router.pushUrl({
          url: "pages/Privacy"
        })
      })

      Row() {
        Row() {
          Text("建议反馈 ").fontSize(16).fontWeight(500)
        }.alignItems(VerticalAlign.Center)

        Row() {
          Column() {
            Image($r('app.media.right_arrow')).width(20).height(20)
          }.height(30).justifyContent(FlexAlign.Center)
        }
      }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 10, left: 15, right: 15, top: 10 }).width("90%").backgroundColor("#f6f8fa").borderRadius(15).margin({top: 20}).onClick(() => {
        router.pushUrl({
          url: "pages/Advice"
        })
      })



    }.width("100%").height("100%")
  }
}