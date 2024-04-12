import { TAB_MENU } from '../constants'

export const menu_index = {
  [TAB_MENU.INDEX]: {
    active: "app.media.home_active",
    normal: "app.media.home",
    name: "打卡",
  },
  [TAB_MENU.TARGET]: {
    active: "app.media.target_active",
    normal: "app.media.target",
    name: "目标"
  },
  [TAB_MENU.FOCUS]: {
    active: "app.media.focus_active",
    normal: "app.media.focus",
    name: "专注"
  },
  [TAB_MENU.SETTING]: {
    active: "app.media.setting_active",
    normal: "app.media.setting",
    name: "设置"
  }
}


export const BottomText = {
  activeColor: "#2c2c2c",
  textColor: "#8a8a8a",
}