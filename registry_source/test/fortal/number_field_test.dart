import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedButton;
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';
// ignore: invalid_use_of_internal_member
import 'package:remix/src/rendering/remix_box_effects.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../helpers/test_helpers.dart';

class _Host extends StatefulWidget {
  const _Host({
    this.initial = 4,
    this.enabled = true,
    this.size = .size2,
    this.highContrast = false,
    this.helperText,
  });

  final double initial;
  final bool enabled;
  final FortalNumberFieldSize size;
  final bool highContrast;
  final String? helperText;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late double? value = widget.initial;

  @override
  Widget build(BuildContext context) => FortalNumberField(
    label: 'Guests',
    helperText: widget.helperText,
    size: widget.size,
    highContrast: widget.highContrast,
    enabled: widget.enabled,
    value: value,
    min: 0,
    max: 10,
    onChanged: (next) => setState(() => value = next),
  );
}

BuildContext _context(WidgetTester tester) =>
    tester.element(find.byType(RemixNumberField));

Color _token(WidgetTester tester, ColorToken token) =>
    token.resolve(_context(tester));

Finder get _editor => find.byType(EditableText);

/// The shell: the nearest decorated box around the editor and a step.
Finder get _shell => find
    .ancestor(
      of: find.byIcon(RemixIcons.plus),
      matching: find.ancestor(of: _editor, matching: find.byType(DecoratedBox)),
    )
    .first;

BoxDecoration _shellDecoration(WidgetTester tester) =>
    tester.widget<DecoratedBox>(_shell).decoration as BoxDecoration;

Color _shellBorder(WidgetTester tester) =>
    (_shellDecoration(tester).border! as Border).top.color;

NumberFieldStepSpec _step(WidgetTester tester, IconData icon) => tester
    .widget<StyleSpecBuilder<NumberFieldStepSpec>>(
      find
          .ancestor(
            of: find.byIcon(icon),
            matching: find.byType(StyleSpecBuilder<NumberFieldStepSpec>),
          )
          .first,
    )
    .styleSpec
    .spec;

double? _opacityAbove(WidgetTester tester, Finder finder) {
  final opacity = find.ancestor(of: finder, matching: find.byType(Opacity));
  if (opacity.evaluate().isEmpty) return null;
  return tester.widget<Opacity>(opacity.first).opacity;
}

void main() {
  for (final dark in [false, true]) {
    final mode = dark ? FortalThemeMode.dark : FortalThemeMode.light;
    final name = dark ? 'dark' : 'light';

    testWidgets('$name: the default cell draws the quiet shell', (
      tester,
    ) async {
      await tester.pumpRemixApp(const _Host(), mode: mode, accent: .orla);
      await tester.pumpAndSettle();

      expect(tester.getSize(_shell), const Size(196, 40));
      final shell = _shellDecoration(tester);
      expect(shell.color, _token(tester, FortalTokens.gray2));
      expect(_shellBorder(tester), _token(tester, FortalTokens.gray7));
      expect((shell.border! as Border).top.width, 1);
      expect(shell.borderRadius, BorderRadius.circular(14));

      for (final icon in [RemixIcons.minus, RemixIcons.plus]) {
        final step = _step(tester, icon);
        expect(step.icon.spec.icon, icon);
        expect(step.icon.spec.color, _token(tester, FortalTokens.gray11));
        expect(step.icon.spec.size, 12.5);
        expect(step.iconScale, 1);
        expect(
          tester.getSize(find.byType(NakedButton).first),
          const Size(30, 30),
        );
      }
      expect(
        tester.getCenter(find.byIcon(RemixIcons.plus)).dx -
            tester.getTopLeft(_shell).dx,
        196 - 1 - 3 - 15,
      );

      final value = tester.widget<EditableText>(_editor).style;
      expect(value.fontSize, 15);
      expect(value.fontWeight, FontWeight.w500);
      expect(value.color, _token(tester, FortalTokens.gray12));
      expect(value.fontFeatures, [const FontFeature.tabularFigures()]);
      expect(value.letterSpacing, closeTo(-.15, 1e-9));

      final label = tester.widget<Text>(find.text('Guests')).style!;
      expect(label.fontSize, 13);
      expect(label.fontWeight, FontWeight.w500);
    });

    testWidgets('$name: hover strengthens the border; focus inks it, with '
        'no ring', (tester) async {
      await tester.pumpRemixApp(const _Host(), mode: mode, accent: .orla);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(_editor));
      await tester.pumpAndSettle();
      expect(_shellBorder(tester), _token(tester, FortalTokens.gray8));

      await mouse.moveTo(Offset.zero);
      await tester.tap(_editor);
      await tester.pumpAndSettle();
      expect(_shellBorder(tester), _token(tester, FortalTokens.gray12));
      final adapters = find.ancestor(
        of: _editor,
        // ignore: invalid_use_of_internal_member
        matching: find.byType(RemixBoxAdapter),
      );
      expect(adapters, findsWidgets);
      for (final element in adapters.evaluate()) {
        // ignore: invalid_use_of_internal_member
        expect((element.widget as RemixBoxAdapter).containerEffects, isNull);
      }
    });

    testWidgets('$name: a hovered step fills; a held one presses its glyph '
        'in', (tester) async {
      await tester.pumpRemixApp(const _Host(), mode: mode, accent: .orla);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      final plus = tester.getCenter(find.byIcon(RemixIcons.plus));
      await mouse.moveTo(plus);
      await tester.pumpAndSettle();

      var step = _step(tester, RemixIcons.plus);
      expect(
        (step.container.spec.decoration! as BoxDecoration).color,
        _token(tester, FortalTokens.gray3),
      );
      expect(step.icon.spec.color, _token(tester, FortalTokens.gray12));
      expect(
        _step(tester, RemixIcons.minus).icon.spec.color,
        _token(tester, FortalTokens.gray11),
      );

      await mouse.down(plus);
      await tester.pumpAndSettle();
      step = _step(tester, RemixIcons.plus);
      expect(
        (step.container.spec.decoration! as BoxDecoration).color,
        _token(tester, FortalTokens.gray12).withValues(alpha: .1),
      );
      expect(step.iconScale, .82);
      await mouse.up();
      await tester.pumpAndSettle();
      expect(find.text('5'), findsOneWidget);
    });
  }

  testWidgets('a step at its bound fades; a disabled field mutes and fades '
      'its shell', (tester) async {
    await tester.pumpRemixApp(const _Host(initial: 10), accent: .orla);
    await tester.pumpAndSettle();
    expect(_opacityAbove(tester, find.byIcon(RemixIcons.plus)), .32);
    expect(_opacityAbove(tester, find.byIcon(RemixIcons.minus)), isNull);

    await tester.pumpRemixApp(const _Host(enabled: false), accent: .orla);
    await tester.pumpAndSettle();
    expect(_shellDecoration(tester).color, _token(tester, FortalTokens.gray3));
    expect(_opacityAbove(tester, _editor), .5);
  });

  testWidgets('sizes follow the table', (tester) async {
    for (final (size, shell, step, text, label) in [
      (FortalNumberFieldSize.size1, const Size(164, 32), 24.0, 14.0, 12.0),
      (FortalNumberFieldSize.size3, const Size(228, 44), 34.0, 17.0, 13.0),
    ]) {
      await tester.pumpRemixApp(_Host(size: size), accent: .orla);
      await tester.pumpAndSettle();
      expect(tester.getSize(_shell), shell);
      expect(tester.getSize(find.byType(NakedButton).first), Size(step, step));
      expect(tester.widget<EditableText>(_editor).style.fontSize, text);
      expect(tester.widget<Text>(find.text('Guests')).style!.fontSize, label);
    }
  });

  testWidgets('the value sits on the shell center despite the caret gap', (
    tester,
  ) async {
    await tester.pumpRemixApp(const _Host(), accent: .orla);
    await tester.pumpAndSettle();
    final editable = tester.state<EditableTextState>(_editor).renderEditable;
    final box = editable
        .getBoxesForSelection(
          const TextSelection(baseOffset: 0, extentOffset: 1),
        )
        .single;
    final glyphCenter = editable
        .localToGlobal(Offset((box.left + box.right) / 2, 0))
        .dx;
    expect(glyphCenter, closeTo(tester.getCenter(_shell).dx, .5));
  });

  testWidgets('high contrast moves the border, from the family or the '
      'theme', (tester) async {
    await tester.pumpRemixApp(
      const _Host(highContrast: true, helperText: 'Up to ten'),
      accent: .orla,
    );
    await tester.pumpAndSettle();
    expect(_shellBorder(tester), _token(tester, FortalTokens.controlBorder));
    expect(
      tester.widget<Text>(find.text('Up to ten')).style!.color,
      _token(tester, FortalTokens.gray11),
    );

    await tester.pumpRemixApp(
      const _Host(helperText: 'Up to ten'),
      accent: .orla,
      highContrast: true,
    );
    await tester.pumpAndSettle();
    expect(_shellBorder(tester), _token(tester, FortalTokens.controlBorder));
    expect(
      tester.widget<Text>(find.text('Up to ten')).style!.color,
      _token(tester, FortalTokens.gray10),
    );
  });
}
