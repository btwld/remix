import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix_sheets/mix_sheets.dart';
import 'package:remix/remix.dart';

/// Presents a component sheet as compact scenario stories.
///
/// The generic engine keeps its canonical row-by-scenario [SheetView]. This
/// Fortal-owned viewer uses the same declared data but pivots the final row
/// axis into adjacent cells, which makes size comparisons easier to scan in
/// the live catalog without changing golden-sheet semantics.
class FortalSheetCanvas extends StatelessWidget {
  const FortalSheetCanvas({
    super.key,
    required this.sheet,
    required this.theme,
    this.compact = false,
  });

  final ComponentSheet sheet;
  final SheetTheme theme;
  final bool compact;

  static double minimumWidth(ComponentSheet sheet, {required bool compact}) {
    final groups = _groupRows(sheet);
    final columns = groups.fold<int>(
      1,
      (current, group) => math.max(current, group.rows.length),
    );
    final labelWidth = _showsGroupLabels(sheet) ? (compact ? 104.0 : 128.0) : 0;
    final minimumCellWidth = _minimumCellWidth(sheet);
    return labelWidth + (columns * minimumCellWidth) + 48;
  }

  @override
  Widget build(BuildContext context) {
    sheet.validate();
    final groups = _groupRows(sheet);
    final border = _color(context, FortalTokens.gray6);

    return Container(
      key: const ValueKey('sheet-story-canvas'),
      decoration: BoxDecoration(
        color: theme.background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < sheet.scenarios.length; index++) ...[
            if (index > 0)
              ColoredBox(
                color: _color(context, FortalTokens.gray2),
                child: const SizedBox(height: 12),
              ),
            _ScenarioStory(
              sheet: sheet,
              scenario: sheet.scenarios[index],
              groups: groups,
              compact: compact,
            ),
          ],
        ],
      ),
    );
  }
}

class _ScenarioStory extends StatelessWidget {
  const _ScenarioStory({
    required this.sheet,
    required this.scenario,
    required this.groups,
    required this.compact,
  });

  final ComponentSheet sheet;
  final SheetScenario scenario;
  final List<_RowGroup> groups;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final divider = _color(context, FortalTokens.gray6);
    return Column(
      key: ValueKey('scenario-story-${scenario.id}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  scenario.label ?? _humanize(scenario.id),
                  style: _textStyle(
                    context,
                    color: _color(context, FortalTokens.gray12),
                    fontSize: 12,
                    weight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  _scenarioMeta(sheet, groups),
                  style: _textStyle(
                    context,
                    color: _color(context, FortalTokens.gray10),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(height: 1, color: divider),
        for (var index = 0; index < groups.length; index++) ...[
          _StoryRow(
            sheet: sheet,
            scenario: scenario,
            group: groups[index],
            compact: compact,
          ),
          if (index < groups.length - 1) Container(height: 1, color: divider),
        ],
      ],
    );
  }
}

class _StoryRow extends StatelessWidget {
  const _StoryRow({
    required this.sheet,
    required this.scenario,
    required this.group,
    required this.compact,
  });

  final ComponentSheet sheet;
  final SheetScenario scenario;
  final _RowGroup group;
  final bool compact;

  @override
  Widget build(BuildContext context) => Container(
    key: ValueKey('story-row-${scenario.id}-${group.key}'),
    constraints: const BoxConstraints(minHeight: 88),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_showsGroupLabels(sheet))
          SizedBox(
            width: compact ? 104 : 128,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                group.label ?? '',
                style: _textStyle(
                  context,
                  color: _color(context, FortalTokens.gray11),
                  fontSize: 12,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
        for (final row in group.rows)
          Expanded(
            child: _StoryCell(sheet: sheet, row: row, scenario: scenario),
          ),
      ],
    ),
  );
}

class _StoryCell extends StatelessWidget {
  const _StoryCell({
    required this.sheet,
    required this.row,
    required this.scenario,
  });

  final ComponentSheet sheet;
  final SheetRow row;
  final SheetScenario scenario;

  @override
  Widget build(BuildContext context) {
    final caption = _cellCaption(sheet, row);
    return Padding(
      key: ValueKey('story-cell-${scenario.id}-${row.id}'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IgnorePointer(
            child: WidgetStateProvider(
              states: scenario.states,
              child: Builder(
                builder: (context) =>
                    row.builder(context, SheetCellContext(scenario)),
              ),
            ),
          ),
          if (caption != null) ...[
            const SizedBox(height: 4),
            Text(
              caption,
              style: _textStyle(
                context,
                color: _color(context, FortalTokens.gray10),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RowGroup {
  const _RowGroup({required this.key, required this.label, required this.rows});

  final String key;
  final String? label;
  final List<SheetRow> rows;
}

List<_RowGroup> _groupRows(ComponentSheet sheet) {
  if (sheet.rowAxes.isEmpty) {
    if (sheet.rows.length <= 1) {
      return [_RowGroup(key: 'default', label: null, rows: sheet.rows)];
    }
    return [
      for (final row in sheet.rows)
        _RowGroup(
          key: row.id,
          label: row.label ?? _humanize(row.id),
          rows: [row],
        ),
    ];
  }

  if (sheet.rowAxes.length == 1) {
    return [
      _RowGroup(key: sheet.rowAxes.first.id, label: null, rows: sheet.rows),
    ];
  }

  final groupingAxes = sheet.rowAxes.take(sheet.rowAxes.length - 1).toList();
  final result = <_RowGroup>[];
  var currentKey = '';
  var currentLabel = '';
  var currentRows = <SheetRow>[];

  for (final row in sheet.rows) {
    final values = [for (final axis in groupingAxes) row.values[axis.id]!];
    final key = values.map((value) => value.id).join('\u0000');
    if (currentRows.isNotEmpty && key != currentKey) {
      result.add(
        _RowGroup(key: currentKey, label: currentLabel, rows: currentRows),
      );
      currentRows = <SheetRow>[];
    }
    currentKey = key;
    currentLabel = values.map((value) => value.label).join(' / ');
    currentRows.add(row);
  }

  if (currentRows.isNotEmpty) {
    result.add(
      _RowGroup(key: currentKey, label: currentLabel, rows: currentRows),
    );
  }
  return result;
}

bool _showsGroupLabels(ComponentSheet sheet) =>
    sheet.rowAxes.length > 1 ||
    (sheet.rowAxes.isEmpty && sheet.rows.length > 1);

double _minimumCellWidth(ComponentSheet sheet) {
  if (sheet.rowAxes.isEmpty) return 480;
  return switch (sheet.id) {
    'menu' || 'select' => 248,
    'callout' || 'card' => 248,
    'text-field' => 224,
    'divider' || 'slider' => 192,
    'avatar' ||
    'badge' ||
    'button' ||
    'checkbox' ||
    'icon-button' ||
    'progress' ||
    'radio' ||
    'spinner' ||
    'switch' ||
    'toggle' => 180,
    _ => 248,
  };
}

String? _cellCaption(ComponentSheet sheet, SheetRow row) {
  if (sheet.rowAxes.isEmpty) return null;
  return row.values[sheet.rowAxes.last.id]!.label;
}

String _scenarioMeta(ComponentSheet sheet, List<_RowGroup> groups) {
  if (sheet.rowAxes.isEmpty) {
    return '${sheet.rows.length} ${sheet.rows.length == 1 ? 'row' : 'rows'}';
  }
  final count = groups.fold<int>(
    0,
    (current, group) => math.max(current, group.rows.length),
  );
  final axis = sheet.rowAxes.last;
  final noun = axis.id == 'size'
      ? (count == 1 ? 'size' : 'sizes')
      : (count == 1
            ? axis.label.toLowerCase()
            : '${axis.label.toLowerCase()} values');
  return '$count $noun';
}

String _humanize(String value) => value
    .split('-')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');

Color _color(BuildContext context, ColorToken token) =>
    MixScope.tokenOf(token, context);

TextStyle _textStyle(
  BuildContext context, {
  required Color color,
  required double fontSize,
  FontWeight weight = FontWeight.w400,
}) => TextStyle(
  color: color,
  fontFamily: 'Roboto',
  fontSize: fontSize,
  fontWeight: weight,
  height: 1.35,
);
