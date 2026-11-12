import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
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
/// A 36px strip with a 3px inset, hugging its tabs. [VanillaTabsVariant.filled]
/// is a recessed `muted` list with large corners; [VanillaTabsVariant.line] has
/// no surface of its own.
///
/// The strip does not scroll. Put a scroll view **outside** the bar: Flutter's
/// tab-bar semantics role requires every direct semantics child to be a tab, so
/// a scroll view inside it trips an assertion.
///
/// ```dart
/// SingleChildScrollView(
///   scrollDirection: Axis.horizontal,
///   child: VanillaTabBar(child: Row(children: tabs)),
/// )
/// ```
///
/// `RemixTabs`, which owns selection and roving focus, has no styler and no
/// recipe. Wrap the bar and the views in it directly:
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
      .height(VanillaTokens.controlMd)
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
/// `textSm` at medium weight, 60% `foreground` until hovered or current
/// (`mutedForeground` in the dark theme). In the filled list the current tab is
/// lifted onto the page color with a small shadow; in the dark theme onto a
/// faint `input` well with an `input` outline, since the dark page is darker
/// than the list. In the line list it is underlined in `foreground` instead.
///
/// The generated widget omits `builder`: `NakedTabState` comes from
/// `package:naked_ui`, which this layer does not import. Pass a `child` for
/// custom content, or use `RemixTab` for the raw state.
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
  return _content(
        // 60% `foreground`, or `mutedForeground` in the dark theme: 4.5:1 on
        // the `muted` list.
        vanillaByBrightness(
          light: vanillaTint(VanillaTokens.foreground, 0.6),
          dark: VanillaTokens.mutedForeground,
        )(),
      )
      .direction(.horizontal)
      .mainAxisSize(.min)
      .mainAxisAlignment(.center)
      .crossAxisAlignment(.center)
      // The list's height less its inset, so a tab fills the list edge to edge.
      .minHeight(VanillaTokens.controlMd - 2 * _listInset)
      .padding(
        .symmetric(horizontal: VanillaTokens.s2, vertical: VanillaTokens.s1),
      )
      .spacing(VanillaTokens.s1_5)
      .label(.style(VanillaTokens.textSm.mix()).fontWeight(FontWeight.w500))
      .icon(.size(VanillaTokens.icon))
      .merge(switch (variant) {
        // The outline is transparent at rest, so the dark theme's current
        // outline paints a pixel the tab already owns.
        .filled =>
          TabStyler()
              .borderRadius(.all(VanillaTokens.radiusMd()))
              .border(
                .all(.color(_transparent).width(VanillaTokens.strokeHairline)),
              )
              .onSelected(
                _content(VanillaTokens.foreground())
                    .color(
                      vanillaByBrightness(
                        light: VanillaTokens.background,
                        dark: _darkCurrentFill,
                      )(),
                    )
                    // None in the light theme, `input` in the dark one.
                    .border(
                      .all(
                        .color(vanillaTint(VanillaTokens.input, 0, dark: 1)()),
                      ),
                    )
                    .shadows(VanillaShadow.sm.box),
              ),
        // The underline's space is held at rest in a transparent edge, so
        // choosing a tab does not reflow the strip. No radius: Flutter cannot
        // round a box whose edges differ.
        .line =>
          TabStyler()
              .border(
                .bottom(
                  .color(_transparent).width(VanillaTokens.strokeIndicator),
                ),
              )
              .onSelected(
                _content(
                  VanillaTokens.foreground(),
                ).border(.bottom(.color(VanillaTokens.foreground()))),
              ),
      })
      .onHovered(_content(VanillaTokens.foreground()))
      .onFocusVisible(.containerEffects(vanillaFocusRing()))
      // Declared last so it wins; the ring is cleared because a disabled tab
      // that still rings reads as reachable.
      .onDisabled(
        TabStyler()
            .containerEffects(.outline(.style(.none)))
            .wrap(.opacity(VanillaTokens.disabledOpacity)),
      )
      .merge(style);
}

/// The panel a tab reveals. It owns the 8px gap between the strip and the
/// content.
@MixWidget(target: RemixTabView.new)
TabViewStyler vanillaTabViewStyle({
  TabViewStyler style = const TabViewStyler.create(),
}) => TabViewStyler().padding(.top(VanillaTokens.s2)).merge(style);

/// The list's inset around its tabs.
const _listInset = 3.0;

const _transparent = Color(0x00000000);

/// The dark current tab's `input` at 30%, blended over the `muted` list here
/// rather than painted translucent: the tab's shadow is a decoration shadow,
/// which Flutter paints under the whole box and would darken a translucent fill.
final _darkCurrentFill = ContextToken<Color>(
  (context) => Color.alphaBlend(
    vanillaTint(VanillaTokens.input, 0.3).resolve(context),
    VanillaTokens.muted.resolve(context),
  ),
);

/// One content color for the label and the icons.
TabStyler _content(Color foreground) =>
    TabStyler().label(.color(foreground)).icon(.color(foreground));
