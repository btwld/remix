library radix_colors; // moved to radix/colors/

import 'package:flutter/painting.dart';

part 'black_white.dart';
part 'dark.dart';
part 'light.dart';

class RadixColors {
  final ColorSwatch<int> swatch;
  final ColorSwatch<int> alphaSwatch;

  static const amber = RadixColors(_amber, _amberAlpha);
  static const amberDark = RadixColors(_amberDark, _amberDarkAlpha);
  // ignore: unused_field
  static const blackAlpha = RadixColors(_blackAlpha, _blackAlpha);
  static const blue = RadixColors(_blue, _blueAlpha);
  static const blueDark = RadixColors(_blueDark, _blueDarkAlpha);
  static const bronze = RadixColors(_bronze, _bronzeAlpha);
  static const bronzeDark = RadixColors(_bronzeDark, _bronzeDarkAlpha);
  static const brown = RadixColors(_brown, _brownAlpha);
  static const brownDark = RadixColors(_brownDark, _brownDarkAlpha);
  static const crimson = RadixColors(_crimson, _crimsonAlpha);
  static const crimsonDark = RadixColors(_crimsonDark, _crimsonDarkAlpha);
  static const cyan = RadixColors(_cyan, _cyanAlpha);
  static const cyanDark = RadixColors(_cyanDark, _cyanDarkAlpha);
  static const gold = RadixColors(_gold, _goldAlpha);
  static const goldDark = RadixColors(_goldDark, _goldDarkAlpha);
  static const grass = RadixColors(_grass, _grassAlpha);
  static const grassDark = RadixColors(_grassDark, _grassDarkAlpha);
  static const gray = RadixColors(_gray, _grayAlpha);
  static const grayDark = RadixColors(_grayDark, _grayDarkAlpha);
  static const green = RadixColors(_green, _greenAlpha);
  static const greenDark = RadixColors(_greenDark, _greenDarkAlpha);
  static const indigo = RadixColors(_indigo, _indigoAlpha);
  static const indigoDark = RadixColors(_indigoDark, _indigoDarkAlpha);
  static const iris = RadixColors(_iris, _irisAlpha);
  static const irisDark = RadixColors(_irisDark, _irisDarkAlpha);
  static const jade = RadixColors(_jade, _jadeAlpha);
  static const jadeDark = RadixColors(_jadeDark, _jadeDarkAlpha);
  static const lime = RadixColors(_lime, _limeAlpha);
  static const limeDark = RadixColors(_limeDark, _limeDarkAlpha);
  static const mauve = RadixColors(_mauve, _mauveAlpha);
  static const mauveDark = RadixColors(_mauveDark, _mauveDarkAlpha);
  static const mint = RadixColors(_mint, _mintAlpha);
  static const mintDark = RadixColors(_mintDark, _mintDarkAlpha);
  static const orange = RadixColors(_orange, _orangeAlpha);
  static const orangeDark = RadixColors(_orangeDark, _orangeDarkAlpha);
  static const pink = RadixColors(_pink, _pinkAlpha);
  static const pinkDark = RadixColors(_pinkDark, _pinkDarkAlpha);
  static const plum = RadixColors(_plum, _plumAlpha);
  static const plumDark = RadixColors(_plumDark, _plumDarkAlpha);
  static const purple = RadixColors(_purple, _purpleAlpha);
  static const purpleDark = RadixColors(_purpleDark, _purpleDarkAlpha);
  static const red = RadixColors(_red, _redAlpha);
  static const redDark = RadixColors(_redDark, _redDarkAlpha);
  static const ruby = RadixColors(_ruby, _rubyAlpha);
  static const rubyDark = RadixColors(_rubyDark, _rubyDarkAlpha);
  static const sand = RadixColors(_sand, _sandAlpha);
  static const sandDark = RadixColors(_sandDark, _sandDarkAlpha);
  static const sky = RadixColors(_sky, _skyAlpha);
  static const skyDark = RadixColors(_skyDark, _skyDarkAlpha);
  static const slate = RadixColors(_slate, _slateAlpha);
  static const slateDark = RadixColors(_slateDark, _slateDarkAlpha);
  static const teal = RadixColors(_teal, _tealAlpha);
  static const tealDark = RadixColors(_tealDark, _tealDarkAlpha);
  static const tomato = RadixColors(_tomato, _tomatoAlpha);
  static const tomatoDark = RadixColors(_tomatoDark, _tomatoDarkAlpha);
  static const violet = RadixColors(_violet, _violetAlpha);
  static const violetDark = RadixColors(_violetDark, _violetDarkAlpha);
  static const yellow = RadixColors(_yellow, _yellowAlpha);
  static const yellowDark = RadixColors(_yellowDark, _yellowDarkAlpha);
  static const olive = RadixColors(_olive, _oliveAlpha);
  static const oliveDark = RadixColors(_oliveDark, _oliveDarkAlpha);
  // ignore: unused_field
  static const whiteAlpha = RadixColors(_whiteAlpha, _whiteAlpha);
  static const sage = RadixColors(_sage, _sageAlpha);
  static const sageDark = RadixColors(_sageDark, _sageDarkAlpha);

  const RadixColors(this.swatch, this.alphaSwatch);
}
