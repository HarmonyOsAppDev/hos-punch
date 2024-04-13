import router from '@ohos.router'

@Entry
@Component
export struct SettingPage {
  build() {
    Column() {
      Row() {
        Column() {
          Image($r('app.media.chart')).width(30).height(30).opacity(0)
        }

        Column() {
          Text("设置").fontSize(20).fontWeight(500)
        }

        Column() {
          Image($r('app.media.plus')).width(25).height(25).opacity(0)
        }
      }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5})




      Row() {
        Row() {
          Text("每日打卡提醒 ").fontSize(16)
          Text("(统一推送一次)").fontSize(12)
        }.alignItems(VerticalAlign.Center)

        Row() {
          Toggle({ type: ToggleType.Switch, isOn: false })
            .selectedColor('#ff7f00')
            .switchPointColor('#FFFFFF')
            .onChange((isOn: boolean) => {
              // this.isTop = isOn;
            })
        }
      }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 10, left: 15, right: 15, top: 10 }).width("90%").backgroundColor("#f6f8fa").borderRadius(15).margin({top: 20})


      Row() {
        Row() {
          Text("打卡完成声音 ").fontSize(16)
        }.alignItems(VerticalAlign.Center)

        Row() {
          Toggle({ type: ToggleType.Switch, isOn: false })
            .selectedColor('#ff7f00')
            .switchPointColor('#FFFFFF')
            .onChange((isOn: boolean) => {
              // this.isTop = isOn;
            })
        }
      }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 10, left: 15, right: 15, top: 10 }).width("90%").backgroundColor("#f6f8fa").borderRadius(15).margin({top: 20})


      Row() {
        Row() {
          Text("隐私政策 ").fontSize(16)
        }.alignItems(VerticalAlign.Center)

        Row() {
          Column() {
            Image($r('app.media.right_circle_arrow')).width(25).height(25)
          }
        }
      }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 10, left: 15, right: 15, top: 10 }).width("90%").backgroundColor("#f6f8fa").borderRadius(15).margin({top: 20}).onClick(() => {
        router.pushUrl({
          url: "pages/Privacy"
        })
      })

      Row() {
        Row() {
          Text("建议反馈 ").fontSize(16)
        }.alignItems(VerticalAlign.Center)

        Row() {
          Column() {
            Image($r('app.media.right_circle_arrow')).width(25).height(25)
          }
        }
      }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 10, left: 15, right: 15, top: 10 }).width("90%").backgroundColor("#f6f8fa").borderRadius(15).margin({top: 20}).onClick(() => {
        router.pushUrl({
          url: "pages/Privacy"
        })
      })



    }.width("100%").height("100%")
  }
}