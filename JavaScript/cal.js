#! /usr/bin/env node
const today = new Date();
const ThisYear = today.getFullYear();
const ThisMonth = today.getMonth() + 1;
const DayOfTheWeekJa = '日 月 火 水 木 金 土\n';

const date = require('minimist')(process.argv.slice(2), {
  default: {
    y: ThisYear,
    m: ThisMonth,
  },
});

const year = date.y;
const month = date.m;
const FirstDay = new Date(year, month - 1, 1);
const LastDay = new Date(year, month, 0).getDate();
const youbi = FirstDay.getDay();
const ary = [];
for (let day = 1; day <= LastDay; day += 1) {
  ary.push(day);
}

for (let i = 0; i < youbi; i += 1) {
  ary.unshift('  ');
}

process.stdout.write(`      ${month}月${year}\n`);
process.stdout.write(DayOfTheWeekJa);
for (let i = 0; i < ary.length; i += 1) {
  const n = (`  ${String(ary[i])}`).slice(-2);
  process.stdout.write(`${n} `);
  if (new Date(year, month - 1, ary[i]).getDay() === 6) {
    process.stdout.write('\n');
  }
}
process.stdout.write('\n');
