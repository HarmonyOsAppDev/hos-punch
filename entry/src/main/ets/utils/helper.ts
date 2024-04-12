import { SelectDateType } from '../types';

export function getDaysOfMonthWithFirstDayOfWeek({year, month}: SelectDateType ) {
  // 计算该月总天数
  const totalDays = getDaysInMonth(year, month);

  // 生成从1到总天数的数组
  const daysArray = Array.from({ length: totalDays }, (_, index) => index + 1);

  // 计算当月1号是星期几，返回值0-6分别对应周日到周六
  const firstDayOfWeek = Math.ceil(calculateFirstDayOfMonth(year, month));

  // 返回包含天数数组以及1号星期几的数组
  return { daysArray, firstDayOfWeek };
}

// 计算指定年月1号是星期几的函数
function calculateFirstDayOfMonth(year, month) {
  if (month < 3) {
    month += 12;
    year--;
  }
  const century = Math.floor(year / 100);
  const yearInCentury = year % 100;
  const weekDay = (dayOfYear(year, month, 1) + century / 4 - century * 2 + yearInCentury + yearInCentury / 4 + 5) % 7;
  return (weekDay + 7) % 7; // 确保返回值为0-6，0表示周日
}

// 计算一年中某一天的序号（即一年中的第几天）
function dayOfYear(year, month, day) {
  let sum = 0;
  for (let i = 1; i < month; i++) {
    sum += getDaysInMonth(year, i);
  }
  sum += day;
  return sum;
}

// 原始的getDaysInMonth函数保持不变
function getDaysInMonth(year, month) {
  month -= 1; // 调整月份
  const isLeapYear = year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
  return [
    31,
    isLeapYear ? 29 : 28,
    31, 30, 31, 30,
    31, 31, 30, 31,
    30, 31
  ][month];
}
