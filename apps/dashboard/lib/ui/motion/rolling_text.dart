import 'dart:math' as math;
import 'dart:ui' show FontFeature, ImageFilter, TileMode;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'timing.dart';

/// Shows [text] with every digit on a 0 to 9 wheel, so a value change rolls
/// each changed digit through the digits between, in the direction the
/// number moved (9 wraps to 0 going up).
///
/// Digits keep their place value: going from 950 to 1,000 the three low
/// places roll while the thousands digit and the separator grow in.
/// Characters that are not digits stay put, enter or leave. Digits are drawn
/// with tabular figures so every wheel has the same width.
///
/// Under reduced motion the new text shows at once.
class UiRollingText extends StatefulWidget {
  const UiRollingText(
    this.text, {
    super.key,
    this.style,
    this.timing = UiTiming.snappy,
  });

  final String text;
  final TextStyle? style;

  /// Drives the wheels.
  final UiTiming timing;

  @override
  State<UiRollingText> createState() => _UiRollingTextState();
}

/// The distance between two neighbouring digits on a wheel, in em.
const _wheelStep = 1.05;

/// How far an entering or leaving column travels, in em.
const _columnRise = 0.3;

/// The feathered band at the top and bottom of the line, in em.
const _feather = 0.2;

final class _Column {
  _Column(this.key, this.char);

  final String key;
  final String char;
  late final UiChannel wheel;
  late final UiChannel width;
  late final UiChannel fade;
  bool exiting = false;
  double riseSign = 1;

  bool get isDigit => _isDigit(char);
}

bool _isDigit(String char) =>
    char.codeUnitAt(0) >= 0x30 && char.codeUnitAt(0) <= 0x39;

/// Splits [text] into keyed columns: a digit by its place value relative to
/// the decimal point, anything else by its character and occurrence.
List<(String, String)> _columnsOf(String text) {
  final chars = text.characters.toList();
  final point = chars.indexOf('.');
  final digitsAfterPoint = point < 0
      ? 0
      : chars.skip(point + 1).where(_isDigit).length;
  final occurrences = <String, int>{};
  var digitsToRight = chars.where(_isDigit).length;

  return [
    for (final char in chars)
      if (_isDigit(char))
        ('d${--digitsToRight - digitsAfterPoint}', char)
      else
        ('$char#${occurrences[char] = (occurrences[char] ?? -1) + 1}', char),
  ];
}

double? _numberOf(String text) =>
    double.tryParse(text.replaceAll(RegExp(r'[^0-9.\-]'), ''));

class _UiRollingTextState extends State<UiRollingText>
    with SingleTickerProviderStateMixin {
  late final UiMotionClock _clock = UiMotionClock(this, _handleFrame);
  List<_Column> _columns = [];
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _columns = [
      for (final (key, char) in _columnsOf(widget.text)) _create(key, char, 1),
    ];
  }

  _Column _create(String key, String char, double presence) {
    final column = _Column(key, char);
    column.wheel = _clock.channel(
      column.isDigit ? int.parse(char).toDouble() : 0,
    );
    column.width = _clock.channel(presence);
    column.fade = _clock.channel(presence);

    return column;
  }

  @override
  void didUpdateWidget(UiRollingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) _retarget(oldWidget.text);
  }

  void _retarget(String oldText) {
    final before = _numberOf(oldText);
    final after = _numberOf(widget.text);
    final up = before == null || after == null || after >= before;
    final byKey = {for (final column in _columns) column.key: column};
    final next = <_Column>[];
    for (final (key, char) in _columnsOf(widget.text)) {
      final existing = byKey.remove(key);
      final column = existing ?? _create(key, char, 0);
      if (existing == null) column.riseSign = up ? 1 : -1;
      if (column.isDigit) _roll(column, int.parse(char), up: up);
      column.exiting = false;
      _show(column, entering: true);
      next.add(column);
    }
    for (final column in byKey.values) {
      column
        ..exiting = true
        ..riseSign = up ? -1 : 1;
      _show(column, entering: false);
    }
    _columns = _merge(_columns, next);
    _dropExited();
  }

  void _roll(_Column column, int digit, {required bool up}) {
    final target = column.wheel.target.round();
    final current = target % 10;
    final steps = up ? (digit - current) % 10 : -((current - digit) % 10);
    _clock.animate(
      column.wheel,
      (target + steps).toDouble(),
      widget.timing,
      jump: _reduceMotion,
    );
  }

  void _show(_Column column, {required bool entering}) {
    final to = entering ? 1.0 : 0.0;
    _clock
      ..animate(
        column.width,
        to,
        entering ? UiTiming.morph : UiTiming.smooth,
        jump: _reduceMotion,
      )
      ..animate(
        column.fade,
        to,
        entering ? UiTiming.morph : UiTiming.instant,
        jump: _reduceMotion,
      );
  }

  /// [next] in order, with each leaving column of [previous] kept after the
  /// column it followed.
  List<_Column> _merge(List<_Column> previous, List<_Column> next) {
    final merged = [...next];
    var insertAt = 0;
    for (final column in previous) {
      if (column.exiting) {
        merged.insert(insertAt++, column);
      } else {
        insertAt = merged.indexOf(column) + 1;
      }
    }

    return merged;
  }

  void _dropExited() {
    final exited = _columns.where(
      (column) =>
          column.exiting &&
          !column.width.isAnimating &&
          !column.fade.isAnimating,
    );
    for (final column in exited.toList()) {
      _clock
        ..remove(column.wheel)
        ..remove(column.width)
        ..remove(column.fade);
      _columns.remove(column);
    }
  }

  void _handleFrame() => setState(_dropExited);

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RemixReducedMotionBuilder(
      builder: (context, reduceMotion) {
        _reduceMotion = reduceMotion;
        final style = DefaultTextStyle.of(context).style
            .merge(widget.style)
            .copyWith(
              fontFeatures: [
                ...?widget.style?.fontFeatures,
                const FontFeature.tabularFigures(),
              ],
            );
        final scaler = MediaQuery.textScalerOf(context);
        final em = scaler.scale(style.fontSize ?? 14);
        final digit = _measure('0', style, scaler);
        final feather = _feather * em / digit.height;

        return ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              Color(0x00000000),
              Color(0xFF000000),
              Color(0xFF000000),
              Color(0x00000000),
            ],
            stops: [0, feather, 1 - feather, 1],
          ).createShader(bounds),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final column in _columns)
                _buildColumn(
                  column,
                  style: style,
                  size: column.isDigit
                      ? digit
                      : _measure(column.char, style, scaler),
                  em: em,
                ),
            ],
          ),
        );
      },
    );
  }

  Size _measure(String text, TextStyle style, TextScaler scaler) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout();
    final size = painter.size;
    painter.dispose();

    return size;
  }

  Widget _buildColumn(
    _Column column, {
    required TextStyle style,
    required Size size,
    required double em,
  }) {
    final width = column.width.value.clamp(0.0, 1.0);
    final fade = column.fade.value.clamp(0.0, 1.0);
    final hidden = 1 - fade;
    final blur = hidden * (column.exiting ? 2 : 4);

    return ClipRect(
      key: ValueKey(column.key),
      child: Align(
        widthFactor: width,
        child: Opacity(
          opacity: fade,
          child: Transform.translate(
            offset: Offset(0, hidden * _columnRise * em * column.riseSign),
            child: Transform.scale(
              scale: 0.6 + 0.4 * width,
              child: _blurred(
                blur,
                SizedBox.fromSize(
                  size: size,
                  child: column.isDigit
                      ? _buildWheel(column.wheel.value, style, em)
                      : Text(column.char, style: style),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWheel(double position, TextStyle style, double em) {
    final base = position.floor();

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        for (var slot = base - 1; slot <= base + 2; slot++)
          if (_slotOpacity(slot - position) > 0)
            Transform.translate(
              offset: Offset(0, (slot - position) * _wheelStep * em),
              child: Opacity(
                opacity: _slotOpacity(slot - position),
                child: _blurred(
                  (slot - position).abs() * 3,
                  Text('${slot % 10}', style: style),
                ),
              ),
            ),
      ],
    );
  }

  double _slotOpacity(double distance) =>
      math.max(0, 1 - math.pow(distance.abs(), 1.5) * 1.1);

  Widget _blurred(double sigma, Widget child) => ImageFiltered(
    imageFilter: ImageFilter.blur(
      sigmaX: sigma,
      sigmaY: sigma,
      tileMode: TileMode.decal,
    ),
    enabled: sigma > 0.01,
    child: child,
  );
}
