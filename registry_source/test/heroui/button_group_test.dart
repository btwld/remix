import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/button.dart';
import 'package:registry_source/src/heroui/components/button_group.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _labels = ['Left', 'Right'];
const _glyph = IconData(0xe000, fontFamily: 'Test');

/// The measured hover, pressed, and focus captures of the first button of an
/// outline group.
const _outlineFirst = 'button-group-outline-md-horizontal-first';

String _id(HeroUiButtonVariant variant) =>
    variant == .dangerSoft ? 'danger-soft' : variant.name;

Widget _group({
  HeroUiButtonVariant variant = .primary,
  HeroUiButtonSize size = .md,
  Axis orientation = Axis.horizontal,
  bool fullWidth = false,
  List<String> labels = _labels,
  List<String>? pressed,
}) => HeroUiButtonGroup(
  variant: variant,
  size: size,
  orientation: orientation,
  fullWidth: fullWidth,
  buttons: [
    for (final label in labels)
      (context, style) => RemixButton(
        label: label,
        style: style,
        onPressed: () => pressed?.add(label),
      ),
  ],
);

Future<void> _pump(
  WidgetTester tester,
  Widget group, {
  String mode = 'light',
  double width = 1024,
}) async {
  await tester.pumpHeroUi(group, mode: mode, width: width);
  await tester.pumpAndSettle();
}

ButtonSpec _spec(WidgetTester tester, String label) =>
    tester.resolvedSpecOf<ButtonSpec>(find.text(label));

BoxDecoration _decoration(ButtonSpec spec) =>
    spec.container.spec.boxSpec.decoration! as BoxDecoration;

BorderRadius _radius(ButtonSpec spec) =>
    _decoration(spec).borderRadius!.resolve(TextDirection.ltr);

/// The corners of a CSS `border-radius: tl tr br bl`.
BorderRadius _corners(HeroUiCase upstream) {
  final corners = upstream.styles['borderRadius']!
      .split(' ')
      .map((value) => Radius.circular(double.parse(value.replaceAll('px', ''))))
      .toList();
  return BorderRadius.only(
    topLeft: corners[0],
    topRight: corners[1],
    bottomRight: corners[2],
    bottomLeft: corners[3],
  );
}

/// The widths of the four border sides of an upstream case.
({double left, double top, double right, double bottom}) _borders(
  HeroUiCase upstream,
) => (
  left: upstream.px('borderLeftWidth'),
  top: upstream.px('borderTopWidth'),
  right: upstream.px('borderRightWidth'),
  bottom: upstream.px('borderBottomWidth'),
);

({double left, double top, double right, double bottom}) _borderOf(
  ButtonSpec spec,
) {
  final insets = _decoration(
    spec,
  ).border?.dimensions.resolve(TextDirection.ltr);
  return (
    left: insets?.left ?? 0,
    top: insets?.top ?? 0,
    right: insets?.right ?? 0,
    bottom: insets?.bottom ?? 0,
  );
}

/// The smallest scale among [label]'s ancestors; 1 when there is none.
double _scale(WidgetTester tester, String label) => tester
    .widgetList<Transform>(
      find.ancestor(of: find.text(label), matching: find.byType(Transform)),
    )
    .map((transform) => transform.transform.entry(0, 0))
    .fold(1.0, (a, b) => a < b ? a : b);

void main() {
  for (final mode in ['light', 'dark']) {
    for (final width in [375, 1024]) {
      testWidgets(
        'every variant and size matches upstream at $width px in $mode',
        (tester) async {
          for (final variant in HeroUiButtonVariant.values) {
            for (final size in HeroUiButtonSize.values) {
              for (final orientation in Axis.values) {
                final reason =
                    '${variant.name} ${size.name} ${orientation.name}';
                await _pump(
                  tester,
                  _group(
                    variant: variant,
                    size: size,
                    orientation: orientation,
                  ),
                  mode: mode,
                  width: width.toDouble(),
                );
                final id = '${_id(variant)}-${size.name}-${orientation.name}';
                final group = heroUiCase(
                  'button-group-$id',
                  mode: mode,
                  width: width,
                );
                final first = heroUiCase(
                  'button-group-$id-first',
                  mode: mode,
                  width: width,
                );
                final last = heroUiCase(
                  'button-group-$id-last',
                  mode: mode,
                  width: width,
                );

                expect(
                  tester.getSize(find.byType(HeroUiButtonGroup)).height,
                  group.size.height,
                  reason: reason,
                );
                expect(
                  _radius(_spec(tester, 'Left')),
                  _corners(first),
                  reason: reason,
                );
                expect(
                  _radius(_spec(tester, 'Right')),
                  _corners(last),
                  reason: reason,
                );
                expect(
                  _borderOf(_spec(tester, 'Left')),
                  _borders(first),
                  reason: reason,
                );
                expect(
                  _borderOf(_spec(tester, 'Right')),
                  _borders(last),
                  reason: reason,
                );
              }
            }
          }
        },
      );
    }
  }

  for (final mode in ['light', 'dark']) {
    testWidgets('buttons keep the variant fill and join without a gap in '
        '$mode', (tester) async {
      await _pump(tester, _group(variant: .secondary), mode: mode);
      for (final (label, position) in [('Left', 'first'), ('Right', 'last')]) {
        final upstream = heroUiCase(
          'button-group-secondary-md-horizontal-$position',
          mode: mode,
        );
        expectCssColor(
          boxFill(_spec(tester, label).container.spec.box!)!,
          upstream.styles['backgroundColor']!,
          reason: label,
        );
      }
      final left = tester.getRect(find.byType(RemixButton).first);
      final right = tester.getRect(find.byType(RemixButton).last);
      expect(right.left, left.right);
      expect(
        tester.getSize(find.byType(HeroUiButtonGroup)).width,
        left.width + right.width,
      );
    });
  }

  testWidgets('a middle button has square corners and no side borders', (
    tester,
  ) async {
    await _pump(
      tester,
      _group(variant: .outline, labels: const ['One', 'Two', 'Three']),
    );
    final middle = _spec(tester, 'Two');
    expect(_radius(middle), BorderRadius.zero);
    final border = _borderOf(middle);
    expect(border.left, 0);
    expect(border.right, 0);
    final bordered = heroUiCase(_outlineFirst).px('borderTopWidth');
    expect(border.top, bordered);
    expect(border.bottom, bordered);
  });

  testWidgets('a lone button is rounded on every corner', (tester) async {
    await _pump(tester, _group(labels: const ['Only']));
    expect(
      _radius(_spec(tester, 'Only')),
      BorderRadius.circular(
        heroUiCase('button-group-nested').px('borderRadius'),
      ),
    );
  });

  testWidgets('fullWidth shares the width equally', (tester) async {
    await _pump(tester, SizedBox(width: 280, child: _group(fullWidth: true)));
    final upstream = heroUiCase('button-group-fullwidth');
    expect(
      tester.getSize(find.byType(HeroUiButtonGroup)).width,
      upstream.size.width,
    );
    expect(
      tester.getSize(find.byType(RemixButton).first).width,
      heroUiCase('button-group-fullwidth-first').size.width,
    );
    expect(
      tester.getSize(find.byType(RemixButton).last).width,
      heroUiCase('button-group-fullwidth-last').size.width,
    );
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('pressing a button runs its callback and does not scale it in '
        '$mode', (tester) async {
      // Outside a group the same press scales the button down.
      await _pump(
        tester,
        HeroUiButton(label: 'Alone', onPressed: () {}),
        mode: mode,
      );
      var touch = await tester.pressCenter(find.text('Alone'));
      expect(_scale(tester, 'Alone'), lessThan(1));
      await touch.up();

      final pressed = <String>[];
      await _pump(tester, _group(pressed: pressed), mode: mode);
      await tester.tap(find.text('Right'));
      expect(pressed, ['Right']);

      touch = await tester.pressCenter(find.text('Left'));
      expect(_scale(tester, 'Left'), 1);
      await touch.up();
    });

    testWidgets('outline buttons hover and press to the measured fills in '
        '$mode', (tester) async {
      await _pump(tester, _group(variant: .outline), mode: mode);
      final mouse = await tester.hoverCenter(find.text('Left'));
      final hover = heroUiCase('$_outlineFirst-hover', mode: mode, state: true);
      expectCssColor(
        boxFill(_spec(tester, 'Left').container.spec.box!)!,
        hover.styles['backgroundColor']!,
        reason: 'hover',
      );
      // The neighbour stays at rest.
      expect(
        boxFill(_spec(tester, 'Right').container.spec.box!),
        HeroUiTokens.transparent,
      );

      await mouse.down(tester.getCenter(find.text('Left')));
      await tester.pumpAndSettle();
      final pressed = heroUiCase(
        '$_outlineFirst-pressed',
        mode: mode,
        state: true,
      );
      expectCssColor(
        boxFill(_spec(tester, 'Left').container.spec.box!)!,
        pressed.styles['backgroundColor']!,
        reason: 'pressed',
      );
      expect(_scale(tester, 'Left'), 1);
      await mouse.up();
    });

    testWidgets('keyboard focus draws the measured ring without resizing in '
        '$mode', (tester) async {
      await _pump(tester, _group(variant: .outline), mode: mode);
      final before = tester.getSize(find.byType(HeroUiButtonGroup));
      expect(_spec(tester, 'Left').containerEffects?.isEmpty ?? true, isTrue);

      await tester.focusWithTab();
      expectFocusRing(
        _spec(tester, 'Left').containerEffects,
        heroUiCase('$_outlineFirst-focus', mode: mode, state: true),
      );
      expect(_spec(tester, 'Right').containerEffects?.isEmpty ?? true, isTrue);
      expect(tester.getSize(find.byType(HeroUiButtonGroup)), before);

      await tester.focusWithTab();
      expectFocusRing(
        _spec(tester, 'Right').containerEffects,
        heroUiCase('$_outlineFirst-focus', mode: mode, state: true),
      );
    });
  }

  testWidgets('builders keep every RemixButton parameter', (tester) async {
    final semantics = tester.ensureSemantics();
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await _pump(
      tester,
      HeroUiButtonGroup(
        buttons: [
          (context, style) => RemixButton(
            label: 'Save',
            leadingIcon: _glyph,
            focusNode: focusNode,
            semanticLabel: 'Save document',
            style: style,
            onPressed: () {},
          ),
          (context, style) => RemixButton(
            label: 'Next',
            trailingIcon: _glyph,
            style: style,
            onPressed: () {},
          ),
        ],
      ),
    );
    expect(find.byType(Icon), findsNWidgets(2));
    expect(find.bySemanticsLabel('Save document'), findsOneWidget);

    await tester.focusWithTab();
    expect(focusNode.hasFocus, isTrue);
    expect(_spec(tester, 'Save').containerEffects?.isEmpty ?? true, isFalse);
    semantics.dispose();
  });

  testWidgets('corners mirror in right-to-left text', (tester) async {
    await _pump(
      tester,
      Directionality(textDirection: TextDirection.rtl, child: _group()),
    );
    final first =
        _spec(tester, 'Left').container.spec.boxSpec.decoration!
            as BoxDecoration;
    // The first button is the rightmost; its start corners are on the right.
    expect(
      first.borderRadius!.resolve(TextDirection.rtl),
      BorderRadius.horizontal(
        right: Radius.circular(
          heroUiCase('button-group-nested').px('borderRadius'),
        ),
      ),
    );
  });
}
