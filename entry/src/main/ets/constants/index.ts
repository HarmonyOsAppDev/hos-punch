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

export const activeConfig = {
  normal: "#8a8a8a",
  active: "#2c2c2c"
}
export const bottomTabs:  string[] = [
 "记录",
 "正计时",
 "倒计时",
 "番茄钟",
]
