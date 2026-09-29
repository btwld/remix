import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'tabs.g.dart';

/// The looks this application offers for a tab strip.
///
/// Both are shadcn's. Pass the same value to the bar and to each tab.
enum PlaygroundTabsVariant {
  /// The default: a recessed `muted` list, with the current tab lifted onto
  /// the page color.
  filled,

  /// No list surface; the current tab is marked by a `foreground` underline.
  line,
}

/// The application's tab-strip recipe.
///
/// The strip is shadcn's `TabsList`: 36px tall with a 3px inset, hugging its
/// tabs. The [PlaygroundTabsVariant.filled] list is a recessed `muted` surface
/// with large corners; the [PlaygroundTabsVariant.line] list has no surface of
/// its own.
///
/// The strip does not scroll. Tabs wider than the container are a layout
/// decision, and the scroll view belongs **outside** the bar:
///
/// ```dart
/// SingleChildScrollView(
///   scrollDirection: Axis.horizontal,
///   child: PlaygroundTabBar(child: Row(children: tabs)),
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
///       PlaygroundTabBar(
///         child: Row(mainAxisSize: MainAxisSize.min, children: [
///           PlaygroundTab(tabId: 'account', label: 'Account'),
///           PlaygroundTab(tabId: 'billing', label: 'Billing'),
///         ]),
///       ),
///       PlaygroundTabView(tabId: 'account', child: accountPanel),
///       PlaygroundTabView(tabId: 'billing', child: billingPanel),
///     ],
///   ),
/// )
/// ```
@MixWidget(target: RemixTabBar.new)
TabBarStyler playgroundTabBarStyle({
  PlaygroundTabsVariant variant = .filled,
  TabBarStyler style = const TabBarStyler.create(),
}) {
  final list = TabBarStyler()
      .direction(.horizontal)
      .mainAxisSize(.min)
      .crossAxisAlignment(.center)
      .height(PlaygroundSize.controlMd)
      .padding(.all(_listInset));

  return switch (variant) {
    .filled =>
      list
          .color(PlaygroundTokens.muted())
          .borderRadius(.all(PlaygroundTokens.radiusLg())),
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
/// It is shadcn's `TabsTrigger`: `textSm` at medium weight, 60% `foreground`
/// until it is hovered or current (`mutedForeground` in the dark theme). In
/// the filled list the current tab is lifted onto the page color with a small
/// shadow — in the dark theme onto a faint `input` well with an `input`
/// outline, since the dark page is darker than the list it would lift out of.
/// In the line list the current tab is underlined in `foreground` instead.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat the recipe's current tab has to be
/// declared as a selected fragment too (`TabStyler().onSelected(...)`).
///
/// `builder` is deliberately not forwarded to the generated
/// `PlaygroundTab`. Its type is `ValueWidgetBuilder<NakedTabState>`, and
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
TabStyler playgroundTabStyle({
  PlaygroundTabsVariant variant = .filled,
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
/// It exists so the panel carries the application's prefix and has one place
/// to edit, and it earns that by owning the gap between the strip and the
/// content: shadcn's `gap-2`.
@MixWidget(target: RemixTabView.new)
TabViewStyler playgroundTabViewStyle({
  TabViewStyler style = const TabViewStyler.create(),
}) => TabViewStyler().padding(.top(PlaygroundSpace.s2)).merge(style);

/// The list's inset around its tabs: shadcn's `p-[3px]`.
const _listInset = 3.0;

/// An edge that paints nothing, holding an outline's space.
const _noEdge = Color(0x00000000);

/// A tab not yet chosen: 60% `foreground`, or `mutedForeground` in the dark
/// theme (shadcn's `text-foreground/60 dark:text-muted-foreground`). Both
/// clear 4.5:1 on the `muted` list.
final _restingContent = playgroundByBrightness(
  light: playgroundTint(PlaygroundTokens.foreground, _restingAlpha),
  dark: PlaygroundTokens.mutedForeground,
);

/// See [_restingContent].
const _restingAlpha = 0.6;

/// The current filled tab's surface: the page color, or `input` at 30% in the
/// dark theme (`dark:data-[state=active]:bg-input/30`).
final _currentFill = playgroundByBrightness(
  light: PlaygroundTokens.background,
  dark: playgroundTint(PlaygroundTokens.input, _darkCurrentFillAlpha),
);

/// See [_currentFill].
const _darkCurrentFillAlpha = 0.3;

/// The current filled tab's outline: none in the light theme, `input` in the
/// dark one (`dark:data-[state=active]:border-input`).
final _currentEdge = playgroundTint(PlaygroundTokens.input, 0, dark: 1);

/// Layout, typography, and the resting content color shared by both looks:
/// shadcn's `px-2 py-1 gap-1.5 text-sm font-medium`.
///
/// A tab is the list's height less its inset on both sides, so it fills the
/// list edge to edge.
TabStyler _base() => _content(_restingContent())
    .animate(PlaygroundMotion.standard)
    .direction(.horizontal)
    .mainAxisSize(.min)
    .mainAxisAlignment(.center)
    .crossAxisAlignment(.center)
    .minHeight(PlaygroundSize.controlMd - 2 * _listInset)
    .padding(
      .symmetric(horizontal: PlaygroundSpace.s2, vertical: PlaygroundSpace.s1),
    )
    .spacing(PlaygroundSpace.s1_5)
    .label(.style(PlaygroundTokens.textSm.mix()).fontWeight(FontWeight.w500))
    .icon(.size(PlaygroundSize.icon));

/// The filled look: a transparent outline at rest, so the dark theme's
/// current outline paints a pixel it already owns, and the lifted surface once
/// current.
TabStyler _filled() => TabStyler()
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .border(.all(.color(_noEdge).width(PlaygroundStroke.hairline)))
    .onSelected(
      _current()
          .color(_currentFill())
          .border(.all(.color(_currentEdge())))
          .shadows(PlaygroundShadow.sm.box),
    );

/// The line look: an underline under the current tab.
///
/// The underline's space is held at rest in a transparent edge, so choosing a
/// tab paints two pixels instead of reflowing the strip. It has no corner
/// radius: Flutter cannot round a box whose edges differ.
TabStyler _line() => TabStyler()
    .border(.bottom(.color(_noEdge).width(PlaygroundStroke.indicator)))
    .onSelected(
      _current().border(.bottom(.color(PlaygroundTokens.foreground()))),
    );

/// The content color of a hovered or current tab.
TabStyler _current() => _content(PlaygroundTokens.foreground());

/// Applies one content color to the label and the icons.
TabStyler _content(Color foreground) =>
    TabStyler().label(.color(foreground)).icon(.color(foreground));

/// The keyboard focus ring: shadcn's 3px `ring` band at half strength.
///
/// A *foreground* decoration rather than the box border: `TabSpec` has no
/// `containerEffects` layer to paint an outline into, and Flutter insets a
/// container's content by its border widths — so adding a real border on
/// focus would nudge the label. The decoration strokes outside the tab and
/// takes no layout space.
TabStyler _focusVisibleStyle(PlaygroundTabsVariant variant) =>
    TabStyler().foregroundDecoration(
      playgroundFocusRingDecoration(
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
    .wrap(.opacity(PlaygroundOpacity.disabled));
