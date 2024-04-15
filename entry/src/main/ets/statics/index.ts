import { TAB_MENU } from '../constants'

// 这里本来用TAB_MENU枚举做key，但是会报错，莫名其妙
export const menu_index = {
  0: {
    active: "app.media.home_active",
    normal: "app.media.home",
    name: "打卡",
  },
  1: {
    active: "app.media.target_active",
    normal: "app.media.target",
    name: "目标"
  },
  2: {
    active: "app.media.focus_active",
    normal: "app.media.focus",
    name: "专注"
  },
  3: {
    active: "app.media.setting_active",
    normal: "app.media.setting",
    name: "设置"
  }
}


export const BottomText = {
  activeColor: "#2c2c2c",
  textColor: "#8a8a8a",
}

export const Icon_list = [
  {
    id: "1",
    url: "app.media.tabicon_hanbaokuaican"
  },
  {
    id: "2",
    url: "app.media.tabicon_jituizhaji"
  },
  {
    id: "3",
    url: "app.media.tabicon_kafei"
  },
  {
    id: "4",
    url: "app.media.tabicon_maocaichuanchuan"
  },
  {
    id: "5",
    url: "app.media.tabicon_mianbao"
  },
  {
    id: "6",
    url: "app.media.tabicon_mianbaotusi"
  },
  {
    id: "7",
    url: "app.media.tabicon_mifenmiantiao"
  },
  {
    id: "8",
    url: "app.media.tabicon_naichaguozhi"
  },
  {
    id: "9",
    url: "app.media.tabicon_naichanaigai"
  },
  {
    id: "10",
    url: "app.media.tabicon_naiyoudangao"
  },
  {
    id: "11",
    url: "app.media.tabicon_pijiujingniang"
  },
  {
    id: "12",
    url: "app.media.tabicon_pisaxican"
  },
  {
    id: "13",
    url: "app.media.tabicon_shaguobaozifan"
  },
  {
    id: "14",
    url: "app.media.tabicon_shalaqingshi"
  },
  {
    id: "15",
    url: "app.media.tabicon_shaokaochuanchuan"
  },
  {
    id: "16",
    url: "app.media.tabicon_shousifantuan"
  },
  {
    id: "17",
    url: "app.media.tabicon_xianhualvzhi"
  },
  {
    id: "18",
    url: "app.media.tabicon_xuegaobingbang"
  },
  {
    id: "19",
    url: "app.media.tabicon_zhongcanchaocai"
  }
]