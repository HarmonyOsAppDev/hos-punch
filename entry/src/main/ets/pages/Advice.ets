import web_webview from '@ohos.web.webview';
import router from '@ohos.router';
import { activeConfig } from '../constants';

@Entry
@Component
struct Advice {
  webviewController: web_webview.WebviewController = new web_webview.WebviewController();

  private backToLastPage() {
    router.back();
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.back'))
            .width(25).height(25).margin(20).onClick(this.backToLastPage)
          Text("建议反馈").fontSize(18).fontColor(activeConfig.active).fontWeight(600)
        }.alignItems(VerticalAlign.Center)
      }.width("100%").justifyContent(FlexAlign.SpaceBetween)
      Web({ src: "https://yuanzi-inno.feishu.cn/share/base/form/shrcnTFPxA86CGXIzqcYxZGdi5b", controller: this.webviewController }).darkMode(WebDarkMode.Off)
    }
  }
}