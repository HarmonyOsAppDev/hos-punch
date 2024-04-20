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
  BOARD_BG_COLOR: "#f6f8fa",
  SAVE_BTN_COLOR: "#ff4d4f"
}

export const timeConfig = [
  {
    id: 1,
    time: -1,
    str: "自定义",
    minute: -1,
  },
  {
    id: 2,
    time: 1 * 60 * 1000,
    str: "1分钟",
    minute: 1,
  },
  {
    id: 3,
    time: 5 * 60 * 1000,
    str: "5分钟",
    minute: 5,
  },
  {
    id: 4,
    time: 10 * 60 * 1000,
    str: "10分钟",
    minute: 10,
  },
  {
    id: 5,
    time: 25 * 60 * 1000,
    str: "25分钟",
    minute: 25,
  },
  {
    id: 6,
    time: 30 * 60 * 1000,
    str: "30分钟",
    minute: 30,
  },
  {
    id: 7,
    time: 60 * 60 * 1000,
    str: "1小时",
    minute: 60,
  },
  {
    id: 8,
    time: 90 * 60 * 1000,
    str: "1小时30分",
    minute: 90,
  },
  {
    id: 9,
    time: 120 * 60 * 1000,
    str: "2小时",
    minute: 120,
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

export const music_config = [
  { str: "海边", id: 1, src: "test1.mp3" },
  { str: "山上清风", id: 2, src: "test2.mp3" },
  { str: "溪流", id: 3, src: "test3.mp3" },
  { str: "鸟鸣", id: 4, src: "test4.mp3" },
];

export const remindAudio = "ding.mp3"

export enum punch_event_name {
  PUNCH_IN_ALL_DATA = "punch_in_all_data",
  PUNCH_IN_DAILY = "punch_in_daily_",
  RECORD_ALL = "focus_record_",
  SETTING = "punchin_setting"
};


export const jiTang = [
  "每一次打卡，都是向目标迈进的坚实一步！",
  "坚持不易，但每打卡一次，你就更接近成功。",
  "今日已打卡，明日更卓越，点滴积累，铸就辉煌。",
  "打卡不只是习惯，更是对自我承诺的坚守。",
  "恭喜你，又完成了一天的任务，明天会更好！",
  "连续打卡记录，映照着你不屈不挠的坚持。",
  "点滴进步，源于每日的坚持打卡，你正闪闪发光。",
  "打卡瞬间，见证你的毅力与成长，未来可期。",
  "又一次成功打卡，每一天的努力都无比珍贵。",
  "打卡不仅标记时间，更在累积你的成就与自信。"
];

export enum EventCode {
  "DELETE_ACTION" = 1,
  "CLOSE_OTHER_RUNNING_CLOCK" = 2,
  "TOMATO_SETTING_DATA" = 3,
  "REFRESH_RECORD" = 4,
  "PLAY_AUDIO" = 5,
  "PLAY_REMIND_AUDIO" = 6
}


export const TomatoDefaultSetting = {
  count: 3,
  every_time_len: 5,
  rest_time_len: 2,
  auto_to_next: true
}

export const OneMinute = 60;

export const ChangeScale = 99;

export enum AudioEvent {
  PLAY = 1,
  PAUSE = 2,
}

export type AudioEventParams = {
   event: AudioEvent,
}