import { TAB_MENU } from '../constants';
import { BottomText, menu_index } from '../statics/index';
import { FocusPage } from './FocusPage';
import { HomePage } from './HomePage';
import { SettingPage } from './SettingPage';
import { TargetPage } from './TargetPage';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World2223';
  private tabsController : TabsController = new TabsController()
  @State currentIndex: number = TAB_MENU.INDEX;

  @Builder TabBuilder(targetIndex: TAB_MENU) {
    Column() {
      Image($r(this.currentIndex === targetIndex ? menu_index[this.currentIndex].active : menu_index[targetIndex].normal)).width(30).height(30).onClick(() => {
        this.currentIndex = targetIndex;
        this.tabsController.changeIndex(this.currentIndex);
      })
      Text(menu_index[targetIndex].name).fontSize(12).margin({top: 2}).fontColor(this.currentIndex === targetIndex ? BottomText.activeColor : BottomText.textColor)
    }
  }


  build() {
    Row() {
      Tabs({ barPosition: BarPosition.End, controller: this.tabsController, index: this.currentIndex }) {
        TabContent(){
          HomePage()
        }.tabBar(this.TabBuilder(TAB_MENU.INDEX))

        TabContent(){
          TargetPage()
        }.tabBar(this.TabBuilder(TAB_MENU.TARGET))

        TabContent(){
          FocusPage();
        }.tabBar(this.TabBuilder(TAB_MENU.FOCUS))

        TabContent(){
          SettingPage();
        }.tabBar(this.TabBuilder(TAB_MENU.SETTING))


      }.margin({bottom: 5}).onChange((index) => {
        this.currentIndex = index
      })
    }.height('100%')
  }
}