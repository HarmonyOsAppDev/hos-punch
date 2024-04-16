import { activeConfig, jiTang } from '../constants'

export const showDialog = (title: string, message: string) => {
  AlertDialog.show(
    {
      title,
      message,
      autoCancel: true,
      alignment: DialogAlignment.Center,
      offset: { dx: 0, dy: -20 },
      gridCount: 3,
      confirm: {
        value: '知道了',
        enabled: true,
        defaultFocus: true,
        style: DialogButtonStyle.HIGHLIGHT,
        action: () => {
          console.info('Button-clicking callback')
        }
      },
      cancel: () => {
        console.info('Closed callbacks')
      }
    }
  )
}


@CustomDialog
export struct PosterDialog {
  controller?: CustomDialogController
  title: string = '';
  desc: string = '';

  build() {
    Column() {
          Image($r("app.media.tabicon_pijiujingniang")).width(100).height(100).margin({bottom: 15})
          Text("打卡成功，已坚持了1天").fontSize(18).fontColor(activeConfig.active).fontWeight(500).opacity(0.5)
          Text(`“${jiTang[Math.floor(Math.random() * 9)]}”`).fontSize(18).fontColor(activeConfig.active).fontWeight(500).opacity(0.5).margin({top: 10})
    }.width("70%").height("40%").linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      repeating: false, // 渐变颜色是否重复
      colors: [["#f2efe0", 0.0], ["#f8f2cf", 0.5], ["#faf8f0", 0.8]] // 数组末尾元素占比小于1时满足重复着色效果
    }).border({width: 12, color: "#ffffff", radius: 20}).shadow({
      radius: 15,
      color: "#d4d4d4"
    }).padding({left: 15, right: 15, top: 15 })
  }
}

@CustomDialog
export struct TypeDialogManager {
  controller?: CustomDialogController
  cancel: () => void = () => {}
  confirm: (typeStr: string) => void = () => {}
  oldVal: string | number = '';
  title: string = '';
  inputType: InputType = InputType.Normal

  @State typeStr: string | number = '';


  aboutToAppear() {
    if (this.oldVal) {
      this.typeStr = this.oldVal;
    }
  }


  build() {
    Column() {
      Text(this.title || '提示').fontSize(18).margin({ top: 15, bottom: 20 }).fontWeight(600)
      TextInput({ text: String(this.typeStr), placeholder: '输入事件名称' }).width("90%").onChange((v) => this.typeStr = v).margin({bottom: 10, top: 10}).type(this.inputType)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.cancel()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确认')
          .onClick(() => {
            this.confirm(String(this.typeStr))
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10, top: 5 })
    }
  }
}