import router from '@ohos.router';

@Component
export struct HeaderTarget {

  toAddTarget() {
    router.pushUrl({
      url: "pages/AddTarget", // 目标url
    }, router.RouterMode.Standard, (err) => {
      if (err) {
        console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('Invoke pushUrl succeeded.');
    });
  }


  build() {
    Row() {
      Column() {}.width(25)
      Column() {
        Text("目标管理").fontSize(20).fontWeight(500)
      }
      Column() {
        Image($r('app.media.plus')).width(25).height(25).onClick(() => {
          this.toAddTarget();
        })
      }
    }.justifyContent(FlexAlign.SpaceBetween).width("100%").padding({left: 15, right: 15, top: 15})
  }
}