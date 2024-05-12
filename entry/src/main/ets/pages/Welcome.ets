import router from '@ohos.router';
import { common } from '@kit.AbilityKit';


@Entry
@Component
struct Welcome {

  // Get current theme from storage
  @StorageLink('isFirst') isFirst: number | string = -1;

  build() {
    Column() {
      Column() {
        Image($r("app.media.startIcon")).width(64).alt("Logo").borderRadius(16)

        Text($r("app.string.welcome_welcome"))
          .fontColor($r("app.color.foreground_color"))
          .fontSize(18)
          .fontWeight(FontWeight.Normal)
          .margin({top: 24})

        Text($r("app.string.welcome_appname"))
          .fontColor($r("app.color.foreground_color"))
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .margin({top: 10, bottom: 4})

        Text($r("app.string.welcome_appdes"))
          .fontColor($r("app.color.foreground_color"))
          .fontSize(16)
          .opacity(.75)
          .fontWeight(FontWeight.Normal)
          .margin({top: 4, bottom: 10})
      }
      .width('100%')
      .height('45%')

      Column() {
        Text($r("app.string.welcome_terms_detail"))
          .fontColor($r("app.color.foreground_color"))
          .fontSize(16)
          .fontWeight(FontWeight.Normal)
          .textAlign(TextAlign.Start)

        Text($r("app.string.welcome_privacy_policy"))
          .fontColor($r("app.color.foreground_focus_color"))
          .fontSize(16)
          .onClick(() => this.ToPrivacyPolicy())
          .fontWeight(FontWeight.Normal)
          .margin({top: 16, bottom: 16})
          .textAlign(TextAlign.Start)

        Button($r("app.string.welcome_privacy_start"))
          .fontColor($r("app.color.background_color"))
          .backgroundColor($r("app.color.foreground_focus_color"))
          .onClick(() => this.StartApp())
          .width("48%")
          .height(44)
          .margin({top: 12})

        Button($r("app.string.welcome_privacy_refuse"))
          .fontColor($r("app.color.foreground_cancel_color"))
          .backgroundColor($r("app.color.floating_element_l1"))
          .onClick(() => this.ExitApp())
          .width("48%")
          .height(44)
          .margin({top: 16})
      }
      .margin({top: 80, bottom: 14})
    }
    .padding({left: 12, right: 12})
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .backgroundColor($r('app.color.background_color'))
  }

  // to theme
  private StartApp(): void {
    this.isFirst = 1;

    router.replaceUrl({
      url: 'pages/Index' // 目标url
    }, router.RouterMode.Standard, (err) => {
      if (err) {
        console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('Invoke pushUrl succeeded.');
    });
  }

  private ExitApp(): void {
    router.back();
  }

  // to theme
  private ToPrivacyPolicy(): void {
    router.pushUrl({
      url: 'pages/Privacy' // 目标url
    }, router.RouterMode.Standard, (err) => {
      if (err) {
        console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('Invoke pushUrl succeeded.');
    });
  }
}