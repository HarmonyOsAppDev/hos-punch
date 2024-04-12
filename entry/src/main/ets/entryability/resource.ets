import { SingleEntity } from './singleEnity';

@Component
export struct PromiseImg {
  @Prop imgStr: string;
  @Prop _width: number;
  @Prop _height: number;
  @State PicUrl: string = "";

  aboutToAppear() {
    this.getResourceImg();
  }

  getResourceImg() {
    try {
      const resourceManager = SingleEntity.getInstance().getResourceManager();
      resourceManager.getMediaBase64ByName(this.imgStr).then(value => {
        this.PicUrl = value;
      }).catch((error: Error) => {
        console.error("getMediaContent promise error is " + JSON.stringify(error));
      });
    } catch (error) {
      console.error(`promise getMediaContent failed, error code: ${error.code}, message: ${error.message}.`)
    }
  }


  build() {
    Image(this.PicUrl).width(this._width).height(this._height)
  }
}
