import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'tabs.g.dart';

/// The looks this application offers for a tab strip.
///
/// Pass the same value to the bar and to each tab.
enum VanillaTabsVariant {
  /// The default: a recessed `muted` list, with the current tab lifted onto
  /// the page color.
  filled,

  /// No list surface; the current tab is marked by a `foreground` underline.
  line,
}

/// The application's tab-strip recipe.
///
/// The strip is 36px tall with a 3px inset, hugging its tabs. The
/// [VanillaTabsVariant.filled] list is a recessed `muted` surface with large
/// corners; the [VanillaTabsVariant.line] list has no surface of its own.
///
/// The strip does not scroll. Tabs wider than the container are a layout
/// decision, and the scroll view belongs **outside** the bar:
///
/// ```dart
/// SingleChildScrollView(
///   scrollDirection: Axis.horizontal,
///   child: VanillaTabBar(child: Row(children: tabs)),
/// )
/// ```
///
/// Not inside it. Flutter's tab-bar semantics role requires every direct
/// semantics child of the bar to be a tab, and a scroll view inserted between
/// them adds a node of its own, which trips that assertion at runtime.
///
/// `RemixTabs` — the behavioral root that owns selection, roving focus, and
/// arrow-key traversal — carries no styler and therefore no recipe. Compose it
/// directly around this bar:
///
/// ```dart
/// RemixTabs(
///   selectedTabId: tab,
///   onChanged: (id) => setState(() => tab = id),
///   child: Column(
///     crossAxisAlignment: CrossAxisAlignment.start,
///     children: [
///       VanillaTabBar(
///         child: Row(mainAxisSize: MainAxisSize.min, children: [
///           VanillaTab(tabId: 'account', label: 'Account'),
///           VanillaTab(tabId: 'billing', label: 'Billing'),
///         ]),
///       ),
///       VanillaTabView(tabId: 'account', child: accountPanel),
///       VanillaTabView(tabId: 'billing', child: billingPanel),
///     ],
///   ),
/// )
/// ```
@MixWidget(target: RemixTabBar.new)
TabBarStyler vanillaTabBarStyle({
  VanillaTabsVariant variant = .filled,
  TabBarStyler style = const TabBarStyler.create(),
}) {
  final list = TabBarStyler()
      .direction(.horizontal)
      .mainAxisSize(.min)
      .crossAxisAlignment(.center)
      .height(VanillaSize.controlMd)
      .padding(.all(_listInset));

  return switch (variant) {
    .filled =>
      list
          .color(VanillaTokens.muted())
          .borderRadius(.all(VanillaTokens.radiusLg())),
    .line => list,
  }.merge(style);
}

/// The application's Tab recipe.
///
/// Everything visual about one tab lives in this function: geometry,
/// typography, and the hover/selected/focus/disabled fragments. Remix keeps
/// ownership of rendering, selection, keyboard traversal, and the tab
/// accessibility semantics — this recipe never reimplements any of that.
///
/// A tab is `textSm` at medium weight, 60% `foreground` until it is hovered or
/// current (`mutedForeground` in the dark theme). In the filled list the
/// current tab is lifted onto the page color with a small shadow — in the dark
/// theme onto a faint `input` well with an `input` outline, since the dark page
/// is darker than the list it would lift out of. In the line list the current
/// tab is underlined in `foreground` instead.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat the recipe's current tab has to be
/// declared as a selected fragment too (`TabStyler().onSelected(...)`).
///
/// `builder` is deliberately not forwarded to the generated
/// `VanillaTab`. Its type is `ValueWidgetBuilder<NakedTabState>`, and
/// `NakedTabState` comes from `package:naked_ui`, which this layer does not
/// depend on. Pass a `child` for custom content, or reach for `RemixTab`
/// directly on the rare call site that needs the raw state.
@MixWidget(
  target: RemixTab.new,
  widgetParameters: .only({
    'tabId',
    'child',
    'label',
    'icon',
    'enabled',
    'mouseCursor',
    'enableFeedback',
    'focusNode',
    'autofocus',
    'onFocusChange',
    'onHoverChange',
    'onPressChange',
    'semanticLabel',
  }),
)
TabStyler vanillaTabStyle({
  VanillaTabsVariant variant = .filled,
  TabStyler style = const TabStyler.create(),
}) {
  return _base()
      .merge(switch (variant) {
        .filled => _filled(),
        .line => _line(),
      })
      .onHovered(_current())
      .onFocusVisible(_focusVisibleStyle(variant))
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// The application's recipe for the panel a tab reveals.
///
/// It exists so the panel carries the application's prefix and has one place to
/// edit, and it earns that by owning the gap between the strip and the content:
/// 8px.
@MixWidget(target: RemixTabView.new)
TabViewStyler vanillaTabViewStyle({
  TabViewStyler style = const TabViewStyler.create(),
}) => TabViewStyler().padding(.top(VanillaSpace.s2)).merge(style);

/// The list's inset around its tabs.
const _listInset = 3.0;

/// An edge that paints nothing, holding an outline's space.
const _noEdge = Color(0x00000000);

/// A tab not yet chosen: 60% `foreground`, or `mutedForeground` in the dark
/// theme. Both clear 4.5:1 on the `muted` list.
final _restingContent = vanillaByBrightness(
  light: vanillaTint(VanillaTokens.foreground, _restingAlpha),
  dark: VanillaTokens.mutedForeground,
);

/// See [_restingContent].
const _restingAlpha = 0.6;

/// The current filled tab's surface: the page color, or `input` at 30% laid
/// over the `muted` list in the dark theme.
///
/// The dark fill is blended here rather than painted translucent: the tab's
/// shadow is a decoration shadow, which Flutter paints under the whole box,
/// so it would show through a translucent fill and darken it. Tabs have no
/// effects layer to move the shadow to.
final _currentFill = vanillaByBrightness(
  light: VanillaTokens.background,
  dark: _darkCurrentFill,
);

final _darkCurrentFill = ContextToken<Color>(
  (context) => Color.alphaBlend(
    vanillaTint(VanillaTokens.input, _darkCurrentFillAlpha).resolve(context),
    VanillaTokens.muted.resolve(context),
  ),
);

/// See [_currentFill].
const _darkCurrentFillAlpha = 0.3;

/// The current filled tab's outline: none in the light theme, `input` in the
/// dark one.
final _currentEdge = vanillaTint(VanillaTokens.input, 0, dark: 1);

/// Layout, typography, and the resting content color shared by both looks: an
/// 8px side inset, 4px above and below, a 6px gap, and `textSm` at medium
/// weight.
///
/// A tab is the list's height less its inset on both sides, so it fills the
/// list edge to edge.
TabStyler _base() => _content(_restingContent())
    .animate(VanillaMotion.standard)
    .direction(.horizontal)
    .mainAxisSize(.min)
    .mainAxisAlignment(.center)
    .crossAxisAlignment(.center)
    .minHeight(VanillaSize.controlMd - 2 * _listInset)
    .padding(.symmetric(horizontal: VanillaSpace.s2, vertical: VanillaSpace.s1))
    .spacing(VanillaSpace.s1_5)
    .label(.style(VanillaTokens.textSm.mix()).fontWeight(FontWeight.w500))
    .icon(.size(VanillaSize.icon));

/// The filled look: a transparent outline at rest, so the dark theme's
/// current outline paints a pixel it already owns, and the lifted surface once
/// current.
TabStyler _filled() => TabStyler()
    .borderRadius(.all(VanillaTokens.radiusMd()))
    .border(.all(.color(_noEdge).width(VanillaStroke.hairline)))
    .onSelected(
      _current()
          .color(_currentFill())
          .border(.all(.color(_currentEdge())))
          .shadows(VanillaShadow.sm.box),
    );

/// The line look: an underline under the current tab.
///
/// The underline's space is held at rest in a transparent edge, so choosing a
/// tab paints two pixels instead of reflowing the strip. It has no corner
/// radius: Flutter cannot round a box whose edges differ.
TabStyler _line() => TabStyler()
    .border(.bottom(.color(_noEdge).width(VanillaStroke.indicator)))
    .onSelected(_current().border(.bottom(.color(VanillaTokens.foreground()))));

/// The content color of a hovered or current tab.
TabStyler _current() => _content(VanillaTokens.foreground());

/// Applies one content color to the label and the icons.
TabStyler _content(Color foreground) =>
    TabStyler().label(.color(foreground)).icon(.color(foreground));

/// The keyboard focus ring: a 3px band of `ring` at half strength.
///
/// A *foreground* decoration rather than the box border: `TabSpec` has no
/// `containerEffects` layer to paint an outline into, and Flutter insets a
/// container's content by its border widths — so adding a real border on
/// focus would nudge the label. The decoration strokes outside the tab and
/// takes no layout space.
TabStyler _focusVisibleStyle(VanillaTabsVariant variant) =>
    TabStyler().foregroundDecoration(
      vanillaFocusRingDecoration(
        radius: switch (variant) {
          .filled => null,
          .line => Radius.zero,
        },
      ),
    );

/// Declared last so it wins over every other state fragment.
///
/// A disabled tab keeps whatever surface its state gives it and simply fades;
/// the focus ring is cleared because a disabled tab that still draws a focus
/// ring reads as reachable.
TabStyler _disabledStyle() => TabStyler()
    .foregroundDecoration(BoxDecorationMix.border(.style(.none)))
    .wrap(.opacity(VanillaOpacity.disabled));
