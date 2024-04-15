import {  TargetTabType } from '../types'

export enum TAB_MENU {
  "INDEX" = 0,
  "TARGET" = 1,
  "FOCUS" = 2,
  "SETTING" = 3,
}

export const tabList: TargetTabType[] = [
  {str: "进行中", id: 0},
  {str: "已结束", id: 1},
  {str: "未开始", id: 2},
  {str: "全部", id: 3}
]

export const cycleList: TargetTabType[] = [
  {str: "按周选择", id: 0},
  {str: "按月选择", id: 1},
]

export const activeConfig = {
  normal: "#8a8a8a",
  active: "#2c2c2c"
}

export const bottomTabs:  string[] = [
 " 记录 ",
 "正计时",
 "倒计时",
 "番茄钟",
]

export const ColorConfig = {
  THEME_ORANGE_COLOR: "#ff7f00",
  ERROR_COLOR: "#fe4d4d",
  NORMAL_COLOR: "#1296db",
}

export const timeConfig = [
  {
    id: 1,
    time: 0,
    str: "其他"
  },
  {
    id: 2,
    time: 10 * 60 * 1000,
    str: "10分钟"
  },
  {
    id: 3,
    time: 25 * 60 * 1000,
    str: "25分钟"
  },
  {
    id: 4,
    time: 30 * 60 * 1000,
    str: "30分钟"
  },
  {
    id: 5,
    time: 60 * 60 * 1000,
    str: "1小时"
  },
  {
    id: 6,
    time: 90 * 60 * 1000,
    str: "1小时30分"
  },
  {
    id: 7,
    time: 120 * 60 * 1000,
    str: "2小时"
  },
]

export const weekDayMap = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];


export const weekKeyMap = {
  "1": "一",
  "2": "二",
  "3": "三",
  "4": "四",
  "5": "五",
  "6": "六",
  "7": "日",
}

export const period_types_map =  ['日目标', '周目标', '月目标', '年目标', '永久目标'];

export const music_config = ['白噪音', '海边', '山上清风'];

export enum punch_event_name {
  PUNCH_IN_ALL_DATA = "punch_in_all_data",
  PUNCH_IN_DAILY = "punch_in_daily_"
};

