import router from '@ohos.router'
import { ColorConfig, punch_event_name } from '../constants'
import { SettingType } from '../types';
import DatabaseManager from '../services/DatabaseManager';
import { getData } from '../services/SettingDataManager';

@Entry
@Component
export struct SettingPage {
  @State setting: SettingType|undefined = undefined;
  private settingKey = punch_event_name.SETTING;

  async aboutToAppear() {
    const data = await DatabaseManager.get(this.settingKey);
    if (data !== '') {
      const params: SettingType = JSON.parse(data || "{}");
      this.setting = params;
    }
  }

  async punchData(val: boolean) {
      const originData = this.setting;
      const newData: SettingType = {
        punchInAudio: val,
      }
      const data = getData<SettingType, SettingType>(originData, newData);
      await DatabaseManager.set(this.settingKey, JSON.stringify(data));
  }


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
          Toggle({ type: ToggleType.Switch, isOn: this.setting?.punchInAudio ? true : false })
            .selectedColor(ColorConfig.THEME_ORANGE_COLOR)
            .switchPointColor('#FFFFFF')
            .onChange((isOn: boolean) => {
              this.punchData(isOn);
            })
        }
      }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 10, left: 15, right: 15, top: 10 }).width("90%").backgroundColor(ColorConfig.BOARD_BG_COLOR).borderRadius(15).margin({top: 20})


      Row() {
        Row() {
          Text("隐私政策 ").fontSize(16).fontWeight(500)
        }.alignItems(VerticalAlign.Center)

        Row() {
          Column() {
            Image($r('app.media.right_arrow')).width(20).height(20)
          }.height(30).justifyContent(FlexAlign.Center)
        }
      }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 10, left: 15, right: 15, top: 10 }).width("90%").backgroundColor(ColorConfig.BOARD_BG_COLOR).borderRadius(15).margin({top: 20}).onClick(() => {
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
      }.justifyContent(FlexAlign.SpaceBetween).padding({ bottom: 10, left: 15, right: 15, top: 10 }).width("90%").backgroundColor(ColorConfig.BOARD_BG_COLOR).borderRadius(15).margin({top: 20}).onClick(() => {
        router.pushUrl({
          url: "pages/Advice"
        })
      })



    }.width("100%").height("100%")
  }
}