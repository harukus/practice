#!/usr/bin/env node
const inquirer = require('inquirer');

const drinks = {
  スターバックスラテ: 340,
  カフェモカ: 400,
  ホワイトモカ: 400,
  カフェミスト: 340,
  カプチーノ: 340,
};
const drinksName = Object.keys(drinks);
const milkCustoms = {
  豆乳: 50,
  アーモンドミルク: 50,
  無脂肪ミルク: 0,
  低脂肪ミルク: 0,
  スターバックスミルク: 0,
};
const milkName = Object.keys(milkCustoms);
const RandomMilk = milkName[Math.floor(Math.random() * milkName.length)];

const syropCustoms = {
  バニラシロップ: 50,
  キャラメルシロップ: 50,
  クラシックシロップ: 50,
  アーモンドトフィーシロップ: 50,
  カスタムなし: 0,
};
const syropName = Object.keys(syropCustoms);
const RandomSyrop = syropName[Math.floor(Math.random() * syropName.length)];

const sourceCustoms = {
  チョコレートソース: 0,
  キャラメルソース: 0,
  カスタムなし: 0,
};
const sourceName = Object.keys(sourceCustoms);
const RandomSource = sourceName[Math.floor(Math.random() * sourceName.length)];

const size = ['Short', 'Tall', 'Grande', 'Venti'];

const selectDrink = [{
  type: 'list',
  name: 'drink',
  message: '飲みたいホットドリンクを選んでね！ランダムでカスタマイズを提案するよ！',
  choices: drinksName,
},
{
  type: 'list',
  name: 'size',
  message: 'サイズを選んでね！',
  choices: size,
}];

const Run = () => {
  inquirer
    .prompt(selectDrink)
    .then((answer) => {
      const drinkPrice = drinks[answer.drink] + size.indexOf(answer.size) * 40;
      const total = drinkPrice + milkCustoms[RandomMilk] + syropCustoms[RandomSyrop] + sourceCustoms[RandomSource];
      console.log(`選んだドリンク: ${answer.drink} ${drinkPrice}円
      ミルク変更：${RandomMilk} ${milkCustoms[RandomMilk]}円
      シロップの追加：${RandomSyrop} ${syropCustoms[RandomSyrop]}円
      ソースの追加：${RandomSource} ${sourceCustoms[RandomSource]}円
      合計 ${total}円(+tax)`);
    })
    .catch(console.error);
};

Run();
