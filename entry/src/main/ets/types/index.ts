

export enum SelectEnum {
    "PROCESS" = 0,
    "OVER" = 1,
    "ALL" = 2,
}


export type TargetTabType = { str: string, id: number };

export type SelectDateType = { year: number, month: number, day: number }

export type CurrentMonthDayListAndFirstDayOfWeekType = { daysArray: number[];  firstDayOfWeek: number }

export enum FocusSelectType {
    RECORD = 1,
    POSITIVE_COUNT = 2,
    NEGATIVE_COUNT = 3,
    POMODORO = 4,
}

export type TimeConfigType = {
    id: number,
    time: number,
    str: string
}

export enum PeriodType {
    "DAY" = 1,
    "WEEK" = 2,
    "MONTH" = 3,
    "YEAR" = 4,
    "PERPETUAL" = 5,
}

export enum CycleType {
    "WEEK" = 0,
    "MONTH" = 1,
}

export type NewTaskType = {
    id: number;
    title: string;
    icon: string;
    period: PeriodType;
    cycle: number[];
    cycleType: CycleType;
    punch_count: number;
    allow_surpass: boolean;
    allow_popcard: boolean;
    start_time: number;
    end_time?: number;
}

export type IconItemType = {
    id: string;
    url: string;
}

export type TargetCycleSelectType = {
    currentSelectCycles: number[];
    currentSelectCycleType: CycleType;
    currentDate: SelectDateType;
}

export type CurrentSelectedDataType = {
    weekData: number[];
    monthData: number[];
}
