import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedButton, NakedListbox;
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

class _Host extends StatefulWidget {
  const _Host({
    super.key,
    this.initial = const {},
    this.size = .size2,
    this.highContrast = false,
    this.enabled = true,
  });

  final Set<String> initial;
  final FortalMultiSelectSize size;
  final bool highContrast;
  final bool enabled;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late Set<String> value = widget.initial;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 280,
    child: FortalMultiSelect<String>(
      size: widget.size,
      highContrast: widget.highContrast,
      enabled: widget.enabled,
      trigger: const RemixSelectTrigger(placeholder: 'Select teams'),
      items: const [
        RemixSelectItem(value: 'design', label: 'Design'),
        RemixSelectItem(value: 'engineering', label: 'Engineering'),
        RemixSelectItem(value: 'marketing', label: 'Marketing'),
        RemixSelectItem(value: 'sales', label: 'Sales', enabled: false),
      ],
      selectedValues: value,
      onChanged: (next) => setState(() => value = next),
    ),
  );
}

Color _token(WidgetTester tester, ColorToken token) =>
    token.resolve(tester.element(find.byType(NakedButton)));

Finder get _trigger => find.byType(NakedButton);

BoxDecoration _decorationAround(WidgetTester tester, Finder child) =>
    tester
            .widget<DecoratedBox>(
              find
                  .ancestor(of: child, matching: find.byType(DecoratedBox))
                  .first,
            )
            .decoration
        as BoxDecoration;

Finder _inTrigger(String text) =>
    find.descendant(of: _trigger, matching: find.text(text));

Finder _inList(String text) => find.descendant(
  of: find.byType(NakedListbox<String>),
  matching: find.text(text),
);

/// The trigger's own box: the outermost decorated box inside the button.
Finder get _triggerBox =>
    find.descendant(of: _trigger, matching: find.byType(DecoratedBox)).first;

BoxDecoration _triggerDecoration(WidgetTester tester) =>
    tester.widget<DecoratedBox>(_triggerBox).decoration as BoxDecoration;

Color _border(BoxDecoration decoration) =>
    (decoration.border! as Border).top.color;

TextStyle _style(WidgetTester tester, Finder text) =>
    tester.widget<Text>(text).style!;

/// The option row's fill: the decorated box nearest its label.
Color? _optionFill(WidgetTester tester, String label) =>
    _decorationAround(tester, _inList(label)).color;

void main() {
  for (final dark in [false, true]) {
    final mode = dark ? FortalThemeMode.dark : FortalThemeMode.light;
    final name = dark ? 'dark' : 'light';

    testWidgets('$name: the default cell draws the quiet field', (
      tester,
    ) async {
      await tester.pumpRemixApp(const _Host(), mode: mode, accent: .orla);
      await tester.pumpAndSettle();

      expect(tester.getSize(_triggerBox), const Size(280, 40));
      final box = _triggerDecoration(tester);
      expect(box.color, _token(tester, FortalTokens.gray2));
      expect(_border(box), _token(tester, FortalTokens.gray7));
      expect((box.border! as Border).top.width, 1);
      expect(box.borderRadius, BorderRadius.circular(14));

      final placeholder = _style(tester, _inTrigger('Select teams'));
      expect(placeholder.fontSize, 13);
      expect(placeholder.color, _token(tester, FortalTokens.gray10));
      expect(
        tester.getTopLeft(_inTrigger('Select teams')).dx -
            tester.getTopLeft(_triggerBox).dx,
        1 + 12,
      );
    });

    testWidgets('$name: chips are muted pills and the rest fold into +N', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        const _Host(initial: {'marketing', 'design', 'engineering'}),
        mode: mode,
        accent: .orla,
      );
      await tester.pumpAndSettle();

      final chip = _decorationAround(tester, _inTrigger('Marketing'));
      expect(chip.color, _token(tester, FortalTokens.gray3));
      expect(_border(chip), _token(tester, FortalTokens.gray6));
      expect(chip.borderRadius, BorderRadius.circular(999));
      final label = _style(tester, _inTrigger('Marketing'));
      expect(label.fontSize, 12);
      expect(label.color, _token(tester, FortalTokens.gray12));
      expect(
        tester
            .getSize(
              find
                  .ancestor(
                    of: _inTrigger('Marketing'),
                    matching: find.byType(DecoratedBox),
                  )
                  .first,
            )
            .height,
        closeTo(12 * 1.4 + 8, .25),
      );

      expect(_inTrigger('Engineering'), findsNothing);
      final more = _style(tester, _inTrigger('+1'));
      expect(more.color, _token(tester, FortalTokens.gray11));
      expect(more.fontFeatures, [const FontFeature.tabularFigures()]);
    });

    testWidgets('$name: hover lifts the field and its chips', (tester) async {
      await tester.pumpRemixApp(
        const _Host(initial: {'design'}),
        mode: mode,
        accent: .orla,
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(_trigger));
      await tester.pumpAndSettle();

      final box = _triggerDecoration(tester);
      expect(box.color, _token(tester, FortalTokens.gray3));
      expect(_border(box), _token(tester, FortalTokens.gray8));
      expect(
        _decorationAround(tester, _inTrigger('Design')).color,
        _token(tester, FortalTokens.gray2),
      );
    });

    testWidgets('$name: the open panel floats 8px below the field', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        const _Host(initial: {'design'}),
        mode: mode,
        accent: .orla,
      );
      await tester.tap(_trigger);
      await tester.pumpAndSettle();

      final box = _triggerDecoration(tester);
      expect(box.color, _token(tester, FortalTokens.gray3), reason: 'open');
      expect(_border(box), _token(tester, FortalTokens.gray8));

      final panelBox = find
          .ancestor(
            of: find.byType(NakedListbox<String>),
            matching: find.byType(DecoratedBox),
          )
          .first;
      final panel =
          tester.widget<DecoratedBox>(panelBox).decoration as BoxDecoration;
      expect(panel.color, _token(tester, FortalTokens.colorPanelSolid));
      expect(_border(panel), _token(tester, FortalTokens.gray7));
      expect(panel.borderRadius, BorderRadius.circular(20));
      expect(
        tester.getTopLeft(panelBox).dy - tester.getBottomLeft(_triggerBox).dy,
        8,
      );
      expect(tester.getSize(panelBox).width, 280);

      final row = find
          .ancestor(
            of: _inList('Marketing'),
            matching: find.byType(DecoratedBox),
          )
          .first;
      expect(tester.getSize(row).height, 38);
      expect(
        (tester.widget<DecoratedBox>(row).decoration as BoxDecoration)
            .borderRadius,
        BorderRadius.circular(15),
      );
      expect(_style(tester, _inList('Marketing')).fontSize, 13);

      // A pointer open focuses the picked option without painting it; the
      // keyboard paints the row it moves to.
      expect(_optionFill(tester, 'Design'), const Color(0x00000000));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(
        _optionFill(tester, 'Engineering'),
        _token(tester, FortalTokens.gray3),
      );

      final sales = find.ancestor(
        of: _inList('Sales'),
        matching: find.byType(Opacity),
      );
      expect(tester.widget<Opacity>(sales.first).opacity, .42);
    });
  }

  testWidgets('disabled fades the whole field to half', (tester) async {
    await tester.pumpRemixApp(
      const _Host(initial: {'design'}, enabled: false),
      accent: .orla,
    );
    await tester.pumpAndSettle();
    final fade = find.ancestor(of: _triggerBox, matching: find.byType(Opacity));
    expect(tester.widget<Opacity>(fade.first).opacity, .5);
  });

  testWidgets('high contrast moves the frame and muted text', (tester) async {
    await tester.pumpRemixApp(const _Host(highContrast: true), accent: .orla);
    await tester.pumpAndSettle();
    expect(
      _border(_triggerDecoration(tester)),
      _token(tester, FortalTokens.controlBorder),
    );
    expect(
      _style(tester, _inTrigger('Select teams')).color,
      _token(tester, FortalTokens.gray11),
    );

    await tester.pumpRemixApp(const _Host(), accent: .orla, highContrast: true);
    await tester.pumpAndSettle();
    expect(
      _border(_triggerDecoration(tester)),
      _token(tester, FortalTokens.controlBorder),
      reason: 'the theme switch',
    );
  });

  testWidgets('sizes set the field height', (tester) async {
    for (final (size, height) in [
      (FortalMultiSelectSize.size1, 32.0),
      (FortalMultiSelectSize.size2, 40.0),
      (FortalMultiSelectSize.size3, 44.0),
    ]) {
      await tester.pumpRemixApp(
        _Host(key: ValueKey(size), size: size, initial: const {'design'}),
        accent: .orla,
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(_triggerBox).height, height, reason: '$size');
    }
  });
}
