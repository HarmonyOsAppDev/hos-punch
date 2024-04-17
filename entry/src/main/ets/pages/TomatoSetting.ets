import { TypeDialogManager } from '../components/Dialog';
import { ColorConfig, TomatoDefaultSetting } from '../constants';
import { TomatoSettingInputKey } from '../types';
import router from '@ohos.router';
import { SingleEntity } from '../entryability/singleEnity';

@Entry
@Component
export struct TomatoSetting {
  private DialogInstance: CustomDialogController | undefined = undefined;
  @State currentEditKey: keyof TomatoSettingInputKey = "count" ;
  @State formData: TomatoSettingInputKey = TomatoDefaultSetting

  createTypeDialog(oldVal: string | number, title: string, key: keyof TomatoSettingInputKey,  inputType = InputType.Number) {
    this.currentEditKey = key;
    this.DialogInstance = new CustomDialogController({
      builder: TypeDialogManager({
        cancel: this.closeDialog.bind(this),
        confirm: this.dialogAccept.bind(this),
        title,
        oldVal,
        inputType
      }),
      alignment: DialogAlignment.Center
    });

    this.DialogInstance.open();
  }

  dialogAccept(str: string) {
    this.formData[this.currentEditKey.toString()]= str;
    this.DialogInstance?.close();
  }

  closeDialog() {
    this.DialogInstance?.close();
  }

  submitResult() {
    SingleEntity.getInstance().setTomatoSetting(this.formData);
    AppStorage.setOrCreate('TomatoDefaultSetting', this.formData);
    router.back();
  }

  build() {
    Column() {

      Row() {
        Column() {
          Image($r('app.media.back')).width(30).height(30).onClick(() => {
            this.submitResult();
          })
        }

        Row() {
          Text("设置番茄时钟").fontSize(20).fontWeight(500)
        }

        Column() {}.width(25)

      }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 5}).margin({bottom: 15})


      Row() {
        Row() {
          Text("番茄数量").fontSize(18)
        }
        Row() {
          Text(String(this.formData.count))
            .fontSize(18)
            .maxLines(1)
            .width("50%")
            .onClick(() => {
              this.createTypeDialog(
                this.formData.count,
                "番茄数量",
                "count"
              );
            })
            .fontColor("#777")
            .textAlign(TextAlign.End)
            .margin({right: 5})

          Image($r("app.media.right_arrow")).width(15).height(15)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ bottom: 20, left: 15, right: 15, top: 20 })
      .width("95%")
      .backgroundColor(ColorConfig.BOARD_BG_COLOR)
      .margin({ left: "2.5%", right: "2.5%" })
      .borderRadius(30)
      .margin({ top: 10 })

    Row() {
      Row() {
        Text("单个番茄时长").fontSize(18)
      }

      Row() {
        Text(String(this.formData.every_time_len))
          .fontSize(18)
          .maxLines(1)
          .width("50%")
          .onClick(() => {
            this.createTypeDialog(
              this.formData.every_time_len,
              "单个番茄时长",
              "every_time_len"
            );
          })
          .fontColor("#777")
          .textAlign(TextAlign.End)
          .margin({right: 5})

        Image($r("app.media.right_arrow")).width(15).height(15)
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ bottom: 20, left: 15, right: 15, top: 20 })
    .width("95%")
    .backgroundColor(ColorConfig.BOARD_BG_COLOR)
    .margin({ left: "2.5%", right: "2.5%" })
    .borderRadius(30)
    .margin({ top: 10 })



      Row() {
        Row() {
          Text("休息时长").fontSize(18)
        }

        Row() {
          Text(String(this.formData.rest_time_len))
            .fontSize(18)
            .maxLines(1)
            .width("50%")
            .onClick(() => {
              this.createTypeDialog(
                this.formData.rest_time_len,
                "休息时长",
                "rest_time_len"
              );
            })
            .fontColor("#777")
            .textAlign(TextAlign.End)
            .margin({right: 5})

          Image($r("app.media.right_arrow")).width(15).height(15)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ bottom: 20, left: 15, right: 15, top: 20 })
      .width("95%")
      .backgroundColor(ColorConfig.BOARD_BG_COLOR)
      .margin({ left: "2.5%", right: "2.5%" })
      .borderRadius(30)
      .margin({ top: 10 })




      Row() {
        Row() {
          Text("休闲结束自动进入下一个番茄 ").fontSize(18)
        }.alignItems(VerticalAlign.Center)

        Row() {
          Toggle({ type: ToggleType.Switch, isOn: this.formData.auto_to_next })
            .selectedColor(ColorConfig.THEME_ORANGE_COLOR)
            .switchPointColor('#FFFFFF')
            .onChange((isOn: boolean) => {
              this.formData.auto_to_next = isOn;
            })
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ bottom: 20, left: 15, right: 15, top: 20 })
      .width("95%")
      .backgroundColor(ColorConfig.BOARD_BG_COLOR)
      .borderRadius(30)
      .margin({ top: 10 })

      Column() {
        Button({ type: ButtonType.Capsule, stateEffect: false }) {
          Row() {
            Text("保存").fontSize(18).fontColor("white").margin({ left: 5 })
          }.alignItems(VerticalAlign.Center)
        }.height(50).width("90%").onClick(() => {
          this.submitResult();
        })
      }.margin({ top: 20 })
    }
  }
}