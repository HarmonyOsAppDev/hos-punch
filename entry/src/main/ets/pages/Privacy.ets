import web_webview from '@ohos.web.webview';
import router from '@ohos.router';

@Entry
@Component
struct Privacy {
  webviewController: web_webview.WebviewController = new web_webview.WebviewController();

  private backToLastPage() {
    router.back();
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.routerback'))
            .width(25).height(25).margin(20).onClick(this.backToLastPage)
          Text("隐私政策").fontSize(18).fontColor("white").fontWeight(600)
        }
      }.width("100%").justifyContent(FlexAlign.SpaceBetween)
      Web({ src: $rawfile('privacy.html'), controller: this.webviewController }).darkMode(WebDarkMode.Off)
    }.backgroundColor("#ff7f00")
  }
}