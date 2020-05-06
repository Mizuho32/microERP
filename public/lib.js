/********************************************************
 *
 *  漢数字をアラビア数字にする
 *
 *  Copyright (c) 2005 AOK. All Rights Reserved.
 *  http://aok.blue.coocan.jp/jscript/kan2arb.html
 *
 ********************************************************/
var suuji = "〇一二三四五六七八九零壱弐参肆伍陸質捌玖零壹貳參";
var keta1 = "十百千拾佰仟十陌阡";
var keta2 = "万億兆萬";

var toArb = function(kanji) {
  if (kanji.match(/\d+/) !== null)
    return kanji;

  var i, r, a, b = 0, c, d, t = 0, f = false;
  for (i = 0; i < kanji.length; i++) {
    c = kanji.charAt(i);
    if ((r = suuji.indexOf(c)) != -1) {
      if (f == false) {
        b += r % 10;
        f = true;
      } else {
        b = b * 10 + r % 10;
      }
    } else if ((r = keta1.indexOf(c)) != -1) {
      t += b;
      d = t % 10;
      a = (d == 0 ? 1 : d) * Math.pow(10, r % 3 + 1);
      t += a - d;
      b = 0;
      f = false;
    } else if ((r = keta2.indexOf(c)) != -1) {
      t += b;
      d = t % 10000;
      a = d * Math.pow(10000, r % 3 + 1);
      t += a - d;
      b = 0;
      f = false;
    } else {
      console.log("解析不能：" + kanji);
      return false;
    }
  }
  return t + b;
};
