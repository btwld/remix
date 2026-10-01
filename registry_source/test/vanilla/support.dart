import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

/// Both shipped themes, named for test descriptions.
const vanillaThemes = <({String name, VanillaThemeData data})>[
  (name: 'light', data: VanillaThemeData.light()),
  (name: 'dark', data: VanillaThemeData.dark()),
];

/// The value [theme] gives [token], for tokens the data derives (radii, text).
T tokenOf<T>(VanillaThemeData theme, MixToken<T> token) =>
    theme.tokens[token]! as T;

/// [color] at [alpha] of its own opacity, the way `vanillaTint` resolves it.
Color tint(Color color, double alpha) =>
    color.withValues(alpha: color.a * alpha);

/// Resolves [style] under [theme] with [states] active, with no widget of the
/// component's own around it.
///
/// Every recipe that keys its fragments on plain widget states resolves
/// faithfully this way. A recipe keyed on a component's own inherited state
/// (the checkbox's tristate) needs the real widget; see [pumpedSpec].
Future<StyleSpec<S>> resolveVanilla<S extends Spec<S>>(
  WidgetTester tester,
  Style<S> style, {
  required VanillaThemeData theme,
  Set<WidgetState> states = const {},
}) async {
  final previous = FocusManager.instance.highlightStrategy;
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(() => FocusManager.instance.highlightStrategy = previous);

  late StyleSpec<S> resolved;
  await tester.pumpWidget(
    VanillaThemeScope(
      theme: theme,
      child: hostOf(
        WidgetStateProvider(
          states: states,
          child: Builder(
            builder: (context) {
              resolved = style.build(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );

  return resolved;
}

/// Pumps [widget] under [theme] and returns the spec it resolved for itself.
Future<StyleSpec<S>> pumpedSpec<S extends Spec<S>>(
  WidgetTester tester,
  Widget widget, {
  required VanillaThemeData theme,
}) async {
  await tester.pumpWidget(
    VanillaThemeScope(
      theme: theme,
      child: hostOf(Center(child: widget)),
    ),
  );

  return tester
      .widget<StyleSpecProvider<S>>(find.byType(StyleSpecProvider<S>).first)
      .spec;
}

/// Pumps the widget [build] returns, then hovers or focuses it, and returns
/// the spec it resolved in that state.
///
/// For recipes keyed on a component's own inherited state (a disclosure's
/// `onExpanded`, a checkbox's tristate), which a bare [resolveVanilla] cannot
/// stand in for.
Future<StyleSpec<S>> interactedSpec<S extends Spec<S>>(
  WidgetTester tester,
  Widget Function(FocusNode focusNode) build, {
  required VanillaThemeData theme,
  bool hovered = false,
  bool focused = false,
}) async {
  final previous = FocusManager.instance.highlightStrategy;
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(() => FocusManager.instance.highlightStrategy = previous);
  final focusNode = FocusNode(debugLabel: 'vanilla-probe');
  addTearDown(focusNode.dispose);

  await tester.pumpWidget(
    VanillaThemeScope(
      theme: theme,
      child: hostOf(Center(child: build(focusNode))),
    ),
  );
  await tester.pumpAndSettle();
  if (focused) {
    focusNode.requestFocus();
    await tester.pumpAndSettle();
  }
  final provider = find.byType(StyleSpecProvider<S>).first;
  if (hovered) {
    final pointer = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(pointer.removePointer);
    await pointer.addPointer(location: Offset.zero);
    await tester.pump();
    await pointer.moveTo(tester.getCenter(provider));
    await tester.pumpAndSettle();
  }

  return tester.widget<StyleSpecProvider<S>>(provider).spec;
}

/// The minimal host: `WidgetsApp` and nothing from Material or Cupertino.
Widget hostOf(Widget child) =>
    WidgetsApp(color: const Color(0xFF000000), builder: (_, _) => child);

/// The box decoration of a plain box.
BoxDecoration? decorationOf(StyleSpec<BoxSpec> box) =>
    box.spec.decoration as BoxDecoration?;

/// The box decoration of a flex box.
BoxDecoration? flexDecorationOf(StyleSpec<FlexBoxSpec> box) =>
    box.spec.box?.spec.decoration as BoxDecoration?;

/// The foreground decoration of a flex box.
BoxDecoration? flexForegroundOf(StyleSpec<FlexBoxSpec> box) =>
    box.spec.box?.spec.foregroundDecoration as BoxDecoration?;

/// The box half of a flex box.
BoxSpec? boxOf(StyleSpec<FlexBoxSpec> box) => box.spec.box?.spec;

/// The flex half of a flex box.
FlexSpec? flexOf(StyleSpec<FlexBoxSpec> box) => box.spec.flex?.spec;

/// Matches a border that paints nothing: absent, zero-width, or transparent.
final Matcher paintsNoBorder = predicate<BoxBorder?>((border) {
  if (border == null) return true;
  if (border is! Border) return false;
  return [border.top, border.right, border.bottom, border.left].every(
    (side) =>
        side.style == BorderStyle.none || side.width == 0 || side.color.a == 0,
  );
}, 'paints no border');

/// Matches a radius that rounds any control in this layer into a pill.
final Matcher isFullyRounded = predicate<BorderRadiusGeometry?>(
  (radius) =>
      radius is BorderRadius &&
      [
        radius.topLeft,
        radius.topRight,
        radius.bottomLeft,
        radius.bottomRight,
      ].every((corner) => corner.x >= 999 && corner.y >= 999),
  'is fully rounded',
);

/// WCAG 2 contrast ratio between two opaque colors.
double contrastRatio(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  final lighter = a > b ? a : b;
  final darker = a > b ? b : a;

  return (lighter + 0.05) / (darker + 0.05);
}
