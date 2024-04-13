

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
        value: 'ok',
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


// @CustomDialog
// export struct DialogManager {
//   controller?: CustomDialogController
//   cancel: () => void = () => {}
//   confirm: () => void = () => {}
//   title: string = '';
//   desc: string = '';
//
//   build() {
//     Column() {
//       Text(this.title || '提示').fontSize(18).margin({ top: 15, bottom: 20 }).fontWeight(600)
//       Text(this.desc || '').fontSize(16).margin({ bottom: 10, left: 10, right: 10 })
//       Flex({ justifyContent: FlexAlign.SpaceAround }) {
//         Button('取消')
//           .onClick(() => {
//             this.cancel()
//           }).backgroundColor(0xffffff).fontColor(Color.Black)
//         Button('确认')
//           .onClick(() => {
//             this.confirm()
//           }).backgroundColor(0xffffff).fontColor(Color.Red)
//       }.margin({ bottom: 10, top: 5 })
//     }
//   }
// }

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