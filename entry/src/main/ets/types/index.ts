import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import distributedKVStore from '@ohos.data.distributedKVStore';

export enum SelectEnum {
    "PROCESS" = 0,
    "OVER" = 1,
    "UN_START" = 2,
    "ALL" = 3,
}

export type TargetTabType = { str: string, id: number };

export type SelectDateType = { year: number, month: number, day: number }

export type CurrentMonthDayListAndFirstDayOfWeekType = { daysArray: number[];  firstDayOfWeek: number }

export enum FocusSelectType {
    RECORD = 0,
    POSITIVE_COUNT = 1,
    NEGATIVE_COUNT = 2,
    POMODORO = 3,
}

export type TimeConfigType = {
    id: number,
    time: number,
    str: string,
    minute: number,
}

export type TimeRecordType = {
    id: string,
    title: string,
    type: FocusSelectType,
    createTime: number,
    focusTime: string,
    ownerKey: string,
}

export enum CycleType {
    "WEEK" = 0,
    "MONTH" = 1,
}

export enum TaskStatus {
    "NORMAL" = 1,
    "END" = 2,
}

export type ErrorType =  { code: number, message: string }

// 打卡任务类型
export type NewTaskType = {
    id: string;
    title: string;             // 打卡标题
    icon: string;              // 打卡图标
    cycle: number[];           // 限制一个月哪天打卡，或者一个星期内哪天打卡，cycleType week类型的时候，1-7表示周一-周日
    cycleType: CycleType;     // 循环类型，这个配合cycle使用，看
    punch_count: number;      // 打卡数量
    // target_type: PeriodType;  // 任务类型，周卡，日卡，月卡
    support_multi: boolean;   // 是否允许一天多打
    allow_popcard: boolean;  // 是否打卡后弹出仪式感弹窗
    status: TaskStatus;
    start_time: number;  // 打卡设置开始时间
    end_time?: number; // 打卡设置结束时间
    punch_days: number; // 用户打卡的天数
}

// 用户个人打卡记录
export type PersonalPunchInRecord = {
    id: string;
    createTime: number; // 打卡具体时间，可能未来有用
    punchInCollectIn: string; // 打的哪个任务的卡
    punchInCount: number;
}

export enum PeriodType {
    "DAY" = 0,
    "WEEK" = 1,
    "MONTH" = 2,
    "YEAR" = 3,
    "PERPETUAL" = 4,
}

export type IconItemType = {
    id: string;
    url: string;
}

export enum CycleRouterType {
    EDIT = "1",
    ADD = "2",
}

export type TargetCycleSelectType = {
    currentSelectCycles: number[];
    currentSelectCycleType: CycleType;
    currentDate: SelectDateType;
    mode: CycleRouterType;
}

export type EditTaskRouterParamsType = {
    currentItem: NewTaskType;
}

export type CurrentSelectedDataType = {
    weekData: number[];
    monthData: number[];
}


export type TargetPageType = {
    [SelectEnum.PROCESS]: NewTaskType[],
    [SelectEnum.OVER]:  NewTaskType[],
    [SelectEnum.UN_START]:  NewTaskType[],
    [SelectEnum.ALL]:  NewTaskType[],
}

export type MusicRepoType = {
    str: string;
    id: number;
    src: string;
}

export type PunchDaysType = {
    punch_days: NewTaskType['punch_days'];
}

export enum CountStatusType {
    "UN_START" = 1,
    "IN_PROCESS" = 2,
    "IN_STOP" = 3,
    "IN_PAUSE" = 4,
}

export type RunningClockType = {
    timeType: FocusSelectType,
    status: CountStatusType
}

export type TomatoSettingInputKey = {
    count: number; // 番茄数量
    every_time_len: number; // 每个番茄时间的时长
    rest_time_len: number; // 每个番茄时长
    auto_to_next: boolean;
}

export enum TomatoTaskType {
    "UN_START" = 1,
    "REST" = 2,
    "PROCESS" = 3,
    "FINISHED" = 4,
}

export type TomatoTaskItem = {
    minute: number;
    type: TomatoTaskType;
    tomato_current: number;
}


export type SettingType = {
    punchInAudio: boolean
}
