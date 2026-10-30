import 'package:flutter/widgets.dart';
import 'polish_board.dart';
import 'ui/ui.dart';

void main() {
  final query = Uri.base.queryParameters;
  final accent =
      FortalAccentColor.values
          .where((value) => value.name == query['accent'])
          .firstOrNull ??
      FortalAccentColor.calcadao;
  runApp(
    FortalPolishBoard(
      initialAccent: accent,
      initialGroup: query['group'] ?? 'All',
    ),
  );
}
