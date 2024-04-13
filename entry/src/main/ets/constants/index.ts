import { TargetTabType } from '../types'

export enum TAB_MENU {
  "INDEX" = 0,
  "TARGET" = 1,
  "FOCUS" = 2,
  "SETTING" = 3,
}

export const tabList: TargetTabType[] = [
  {str: "进行中", id: 0},
  {str: "已结束", id: 1},
  {str: "全部", id: 2}
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

