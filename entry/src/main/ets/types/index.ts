

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