import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../helpers/contrast.dart';

/// Rendered contrast of mounted controls, measured from painted pixels.
///
/// Token math misses what the user actually sees here: an empty checkbox only
/// exists in a mounted checkbox state, translucent strokes composite over the
/// real fill and surface, and a pressed button's colours depend on how its
/// press treatment is applied. Each scope renders real widgets on the page,
/// the solid panel and the translucent panel over the page, at 4x, and reads
/// runs of identical pixels along scanlines so every run is one composited
/// layer and consecutive runs are adjacent colours.
///
/// Thresholds follow WCAG 2.2 AA: 4.5:1 for button labels; 3:1 for the cue
/// that identifies a control or its state (the outline of an empty control,
/// the off track, the thumb's fill or ring, the focus ring). A pale selected
/// fill is not itself required to reach 3:1 when its mark carries the state.
void main() {
  const palettes = <String, FortalColorTheme>{
    'calcadao': calcadao,
    'mar': mar,
    'ceu': ceu,
    'serra': serra,
    'sol': sol,
    'duna': duna,
    'caju': caju,
    'fortalError': fortalError,
  };

  for (final dark in [false, true]) {
    for (final surface in _Surface.values) {
      final mode = dark ? 'dark' : 'light';
      testWidgets('$mode/${surface.name}: control cues reach WCAG contrast', (
        tester,
      ) async {
        final failures = <String>[];
        for (final MapEntry(key: name, value: palette) in palettes.entries) {
          final probes = _probes();
          final image = await _render(
            tester,
            palette: palette,
            dark: dark,
            surface: surface,
            probes: probes,
          );
          final scope = '$name/$mode/${surface.name}';
          for (final probe in probes) {
            final problem = probe.check(image, probe.rects(tester));
            if (problem != null) failures.add('$scope ${probe.id}: $problem');
          }
        }
        expect(failures, isEmpty, reason: failures.join('\n'));
      });
    }
  }

  testWidgets('pointer hover then press keeps the label readable', (
    tester,
  ) async {
    // A real hover followed by a press merges both state fragments; the
    // shared Button and IconButton recipes must build and keep 4.5:1.
    for (final palette in [ceu, caju, sol, mar]) {
      final probes = [
        _Probe.button(
          'button',
          FortalButton(label: 'Go', onPressed: () {}),
          focusRing: false,
        ),
        _Probe(
          'icon-button',
          FortalIconButton(
            icon: const IconData(0x41),
            semanticLabel: 'Go',
            onPressed: () {},
          ),
          (image, rects) => null,
        ),
      ];
      await _pump(
        tester,
        palette: palette,
        dark: false,
        surface: .page,
        probes: probes,
      );
      for (final probe in probes) {
        final center = tester.getCenter(find.byKey(probe.key));
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        await gesture.moveTo(center);
        await tester.pump(const Duration(milliseconds: 200));
        await gesture.down(center);
        await tester.pump(const Duration(milliseconds: 200));
        expect(tester.takeException(), isNull, reason: probe.id);
        if (probe.id == 'button') {
          final image = await _capture(tester);
          expect(
            probe.check(image, probe.rects(tester)),
            isNull,
            reason: 'hovered + pressed',
          );
        }
        await gesture.up();
        await gesture.removePointer();
        await tester.pump(const Duration(milliseconds: 200));
      }
    }
  });
}

enum _Surface { page, panel, translucent }

typedef _Rects = ({Rect cell, Rect child});

/// One mounted control and the check for its meaningful cue.
class _Probe {
  _Probe(this.id, this.child, this._check, {this.width = 96, this.height = 56});

  /// A solid button: label 4.5:1 on its painted fill and, when the state
  /// shows focus, a 3:1 ring against the unfiltered outside surface.
  factory _Probe.button(String id, Widget child, {required bool focusRing}) =>
      _Probe(id, child, (image, rects) {
        final row = image.row(rects.child.center.dy);
        // Sample the fill inside the left padding, clear of the label, and
        // search only a band through the label so rounded corners (which
        // blend in the outside surface) cannot stand in for the glyphs.
        final center = rects.child.center;
        final fill = image.pixel(rects.child.left + 3, center.dy);
        final label = image.mostContrasting(
          Rect.fromLTRB(
            rects.child.left + 6,
            center.dy - 4,
            rects.child.right - 6,
            center.dy + 4,
          ),
          fill,
        );
        final labelRatio = contrastRatio(label, fill);
        if (labelRatio < 4.5) {
          return 'label ${_hex(label)} on ${_hex(fill)} = $labelRatio';
        }
        if (!focusRing) return null;
        final runs = image.runs(row, rects.cell.left, rects.child.left + 2);
        if (runs.length < 3 || runs[1].length < 1.5) {
          return 'no focus ring: $runs';
        }
        final ring = contrastRatio(runs[1].color, runs[0].color);
        return ring < 3
            ? 'focus ring ${_hex(runs[1].color)} on '
                  '${_hex(runs[0].color)} = $ring'
            : null;
      }, width: 120);

  final String id;
  final Widget child;
  final String? Function(_Image image, _Rects rects) _check;
  final double width;
  final double height;
  final GlobalKey key = GlobalKey();

  String? check(_Image image, _Rects rects) => _check(image, rects);

  _Rects rects(WidgetTester tester) {
    final boundary = tester.renderObject<RenderBox>(find.byKey(_boundaryKey));
    Rect rect(RenderBox box) =>
        box.localToGlobal(Offset.zero, ancestor: boundary) & box.size;
    return (
      cell: rect(tester.renderObject<RenderBox>(find.byKey(key))),
      child: rect(
        tester.renderObject<RenderBox>(
          find
              .descendant(
                of: find.byKey(key),
                matching: find.byType(KeyedSubtree),
              )
              .first,
        ),
      ),
    );
  }
}

Widget _forced(Set<WidgetState> states, Widget child) =>
    WidgetStateStyleOverride(states: states, child: child);

void _changed(Object? _) {}

List<_Probe> _probes() {
  Widget button({bool highContrast = false}) =>
      FortalButton(label: 'Go', highContrast: highContrast, onPressed: () {});
  return [
    for (final highContrast in [false, true])
      for (final (name, states) in <(String, Set<WidgetState>)>[
        ('idle', {}),
        ('hovered', {WidgetState.hovered}),
        ('pressed', {WidgetState.pressed}),
        ('hovered+pressed', {WidgetState.hovered, WidgetState.pressed}),
        ('focused+pressed', {WidgetState.focused, WidgetState.pressed}),
        (
          'hovered+focused+pressed',
          {WidgetState.hovered, WidgetState.focused, WidgetState.pressed},
        ),
      ])
        _Probe.button(
          'button${highContrast ? '.highContrast' : ''}.$name',
          _forced(states, button(highContrast: highContrast)),
          focusRing: states.contains(WidgetState.focused),
        ),
    for (final soft in [false, true]) ...[
      _Probe(
        'checkbox${soft ? '.soft' : ''}.unchecked',
        FortalCheckbox(
          variant: soft ? .soft : .surface,
          selected: false,
          onChanged: _changed,
          semanticLabel: 'Agree',
        ),
        _emptyOutline,
      ),
      _Probe(
        'radio${soft ? '.soft' : ''}.unselected',
        RemixRadioGroup<String>(
          groupValue: 'other',
          onChanged: _changed,
          child: FortalRadio<String>(
            variant: soft ? .soft : .surface,
            value: 'option',
            semanticLabel: 'Option',
          ),
        ),
        _emptyOutline,
      ),
      _Probe(
        'switch${soft ? '.soft' : ''}.off',
        FortalSwitch(
          variant: soft ? .soft : .surface,
          selected: false,
          onChanged: _changed,
          semanticLabel: 'Alerts',
        ),
        (image, rects) => _switchCues(image, rects, selected: false),
      ),
      for (final highContrast in [false, true])
        _Probe(
          'switch${soft ? '.soft' : ''}${highContrast ? '.highContrast' : ''}'
          '.on',
          FortalSwitch(
            variant: soft ? .soft : .surface,
            highContrast: highContrast,
            selected: true,
            onChanged: _changed,
            semanticLabel: 'Alerts',
          ),
          (image, rects) => _switchCues(image, rects, selected: true),
        ),
    ],
    for (final (name, slider) in <(String, Widget)>[
      ('surface', FortalSlider(value: .5, onChanged: _changed)),
      ('soft', FortalSlider.soft(value: .5, onChanged: _changed)),
      (
        'highContrast',
        FortalSlider(value: .5, highContrast: true, onChanged: _changed),
      ),
    ])
      _Probe(
        'slider.$name',
        SizedBox(width: 120, child: slider),
        _sliderThumb,
        width: 144,
      ),
    _Probe(
      'textField',
      const SizedBox(width: 120, child: FortalTextField(hintText: 'Name')),
      _inputBorder,
      width: 144,
    ),
    _Probe(
      'textField.error',
      const SizedBox(
        width: 120,
        child: FortalTextField(hintText: 'Name', error: true),
      ),
      _inputBorder,
      width: 144,
    ),
    _Probe(
      'textArea',
      const SizedBox(width: 120, child: FortalTextArea(hintText: 'Notes')),
      _inputBorder,
      width: 144,
      height: 88,
    ),
    // A blank soft input with only a programmatic name has no visible text,
    // hint or label: its boundary is the only cue that it is there.
    _Probe(
      'textField.soft.empty',
      const SizedBox(
        width: 120,
        child: FortalTextField.soft(semanticLabel: 'Notes'),
      ),
      _emptyOutline,
      width: 144,
    ),
    _Probe(
      'textArea.soft.empty',
      const SizedBox(
        width: 120,
        child: FortalTextArea.soft(semanticLabel: 'Notes'),
      ),
      _emptyOutline,
      width: 144,
      height: 88,
    ),
    // Disabled inputs stay muted: the active soft ring must not carry over.
    for (final (name, input) in <(String, Widget)>[
      (
        'textField.soft.disabled',
        const FortalTextField.soft(semanticLabel: 'Notes', enabled: false),
      ),
      (
        'textArea.soft.disabled',
        const FortalTextArea.soft(semanticLabel: 'Notes', enabled: false),
      ),
    ])
      _Probe(
        name,
        SizedBox(width: 120, child: input),
        _withoutRing,
        width: 144,
        height: 88,
      ),
  ];
}

/// A muted control: one fill between the outside runs, no inset ring.
String? _withoutRing(_Image image, _Rects rects) {
  final runs = image.runs(
    image.row(rects.child.center.dy),
    rects.cell.left,
    rects.cell.right,
  );
  return runs.length == 3 ? null : 'expected no ring, got $runs';
}

/// An empty checkbox or radio: no mark inside, and an outer boundary that
/// reaches 3:1 against the surface it sits on.
String? _emptyOutline(_Image image, _Rects rects) {
  final runs = image.runs(
    image.row(rects.child.center.dy),
    rects.cell.left,
    rects.cell.right,
  );
  // surface | [outline] | fill | [outline] | surface, with no mark inside.
  final inner = runs.sublist(1, runs.length - 1);
  final symmetric =
      inner.length == 1 ||
      (inner.length == 3 && inner.first.color == inner.last.color);
  if (runs.length < 3 || !symmetric) {
    return 'expected an empty control, got $runs';
  }
  final ratio = contrastRatio(inner.first.color, runs.first.color);
  return ratio < 3
      ? 'boundary ${_hex(inner.first.color)} on ${_hex(runs.first.color)} '
            '= $ratio'
      : null;
}

/// The thumb (its fill or its ring) contrasts with the track; when off, the
/// track's boundary also contrasts with the outside surface.
String? _switchCues(_Image image, _Rects rects, {required bool selected}) {
  final runs = image.runs(
    image.row(rects.child.center.dy),
    rects.cell.left,
    rects.cell.right,
  );
  final outside = runs.first.color;
  final inner = runs.sublist(1, runs.length - 1);
  // The thumb sits at the start (off) or end (on); the track fills the rest.
  final wide = [
    for (var i = 0; i < inner.length; i++)
      if (inner[i].length >= 6) i,
  ];
  if (wide.length < 2) return 'unexpected switch runs $runs';
  final thumbIndex = selected ? wide.last : wide.first;
  final trackIndex = selected ? wide[wide.length - 2] : wide[1];
  final track = inner[trackIndex].color;
  final between = inner.sublist(
    thumbIndex < trackIndex ? thumbIndex : trackIndex + 1,
    thumbIndex < trackIndex ? trackIndex : thumbIndex + 1,
  );
  final thumb = [
    for (final run in between) contrastRatio(run.color, track),
  ].reduce((a, b) => a > b ? a : b);
  if (thumb < 3) return 'thumb on track ${_hex(track)} = $thumb ($runs)';
  if (selected) return null;
  // The off track's end, away from the thumb, against the surface. Light mode
  // needs it for WCAG (the white thumb is close to the track); in dark mode
  // the white thumb already identifies the control, so there this holds
  // Fortal's controlBorder contract rather than a WCAG minimum.
  final edge = contrastRatio(inner.last.color, outside);
  return edge < 3
      ? 'off track edge ${_hex(inner.last.color)} on ${_hex(outside)} = $edge'
      : null;
}

/// Above the 8px track the 16px thumb meets the surface directly; its white
/// fill or its ring must reach 3:1 there.
String? _sliderThumb(_Image image, _Rects rects) {
  final runs = image.runs(
    image.row(rects.child.center.dy - 6),
    rects.cell.left,
    rects.cell.right,
  );
  if (runs.length < 3) return 'thumb not found: $runs';
  final outside = runs.first.color;
  final best = [
    for (final run in runs.sublist(1, runs.length - 1))
      contrastRatio(run.color, outside),
  ].reduce((a, b) => a > b ? a : b);
  return best < 3 ? 'thumb against ${_hex(outside)} = $best ($runs)' : null;
}

/// A surface text input's border against the surface outside it.
String? _inputBorder(_Image image, _Rects rects) {
  final runs = image.runs(
    image.row(rects.child.center.dy),
    rects.cell.left,
    rects.child.left + 8,
  );
  if (runs.length < 2) return 'border not found: $runs';
  final ratio = contrastRatio(runs[1].color, runs[0].color);
  return ratio < 3
      ? 'border ${_hex(runs[1].color)} on ${_hex(runs[0].color)} = $ratio'
      : null;
}

const _scale = 4.0;
final _boundaryKey = GlobalKey();

Future<void> _pump(
  WidgetTester tester, {
  required FortalColorTheme palette,
  required bool dark,
  required _Surface surface,
  required List<_Probe> probes,
}) async {
  tester.view.devicePixelRatio = 1;
  await tester.binding.setSurfaceSize(const Size(1000, 1400));
  addTearDown(() async {
    tester.view.resetDevicePixelRatio();
    await tester.binding.setSurfaceSize(null);
  });
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(
    () => FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.automatic,
  );
  await tester.pumpWidget(
    FortalTheme(
      mode: dark ? .dark : .light,
      child: FortalTheme(
        accentPalette: palette,
        child: WidgetsApp(
          color: const Color(0xFFFFFFFF),
          builder: (context, _) {
            final colors = resolveFortalTokens(FortalTheme.of(context));
            Widget content = Wrap(
              children: [
                for (final probe in probes)
                  SizedBox(
                    key: probe.key,
                    width: probe.width,
                    height: probe.height,
                    child: Center(child: KeyedSubtree(child: probe.child)),
                  ),
              ],
            );
            content = switch (surface) {
              .page => ColoredBox(
                color: colors.colorBackground,
                child: content,
              ),
              .panel => ColoredBox(
                color: colors.colorPanelSolid,
                child: content,
              ),
              .translucent => ColoredBox(
                color: colors.colorBackground,
                child: ColoredBox(
                  color: colors.colorPanelTranslucent,
                  child: content,
                ),
              ),
            };
            return Align(
              alignment: Alignment.topLeft,
              child: RepaintBoundary(
                key: _boundaryKey,
                child: SizedBox(width: 1000, child: content),
              ),
            );
          },
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
  expect(tester.takeException(), isNull);
}

Future<_Image> _render(
  WidgetTester tester, {
  required FortalColorTheme palette,
  required bool dark,
  required _Surface surface,
  required List<_Probe> probes,
}) async {
  await _pump(
    tester,
    palette: palette,
    dark: dark,
    surface: surface,
    probes: probes,
  );
  return _capture(tester);
}

Future<_Image> _capture(WidgetTester tester) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_boundaryKey),
  );
  late _Image result;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: _scale);
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    result = _Image(data!.buffer.asUint8List(), image.width, image.height);
    image.dispose();
  });
  return result;
}

typedef _Run = ({Color color, double length});

/// Raw RGBA pixels of the rendered boundary at [_scale].
class _Image {
  _Image(this._bytes, this._width, this._height);

  final Uint8List _bytes;
  final int _width;
  final int _height;

  Color _at(int x, int y) {
    final i = (y.clamp(0, _height - 1) * _width + x.clamp(0, _width - 1)) * 4;
    return Color.fromARGB(255, _bytes[i], _bytes[i + 1], _bytes[i + 2]);
  }

  /// Device row through the middle of the logical pixel row at [y].
  int row(double y) => (y * _scale).floor() + 1;

  Color pixel(double x, double y) => _at((x * _scale).round(), row(y));

  /// Runs of identical pixels at least 3 device pixels long, so every run is
  /// one fully covered layer; antialiased transitions are dropped.
  List<_Run> runs(int y, double fromX, double toX) {
    final start = (fromX * _scale).round();
    final end = (toX * _scale).round();
    final runs = <_Run>[];
    var runStart = start;
    var color = _at(start, y);
    for (var x = start + 1; x <= end; x++) {
      final next = x == end ? null : _at(x, y);
      if (next == color) continue;
      if (x - runStart >= 3) {
        if (runs.isNotEmpty && runs.last.color == color) {
          final last = runs.removeLast();
          runs.add((
            color: color,
            length: last.length + (x - runStart) / _scale,
          ));
        } else {
          runs.add((color: color, length: (x - runStart) / _scale));
        }
      }
      runStart = x;
      if (next != null) color = next;
    }
    return runs;
  }

  /// The pixel in [rect] with the highest contrast against [background].
  Color mostContrasting(Rect rect, Color background) {
    var best = background;
    var bestRatio = 1.0;
    for (var y = (rect.top * _scale).round(); y < rect.bottom * _scale; y++) {
      for (var x = (rect.left * _scale).round(); x < rect.right * _scale; x++) {
        final color = _at(x, y);
        final ratio = contrastRatio(color, background);
        if (ratio > bestRatio) {
          bestRatio = ratio;
          best = color;
        }
      }
    }
    return best;
  }
}

String _hex(Color color) =>
    '#${(color.toARGB32() & 0xffffff).toRadixString(16).padLeft(6, '0')}';
