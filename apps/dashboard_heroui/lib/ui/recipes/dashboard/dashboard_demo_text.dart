import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/tabs.dart';
import '../../theme/theme.dart';

/// The text sizes the demo uses, named as HeroUI's typography names them.
///
/// The theme carries only `text-xs`, `text-sm` and `text-base`; the headings
/// set Tailwind's larger sizes over `text-base`, as `UiTypography` does,
/// so the demo does not need the `typography` item and its fonts package.
enum UiDashboardTextType { h3, h4, h6, bodySm, bodyXs }

/// One run of demo copy in HeroUI's type scale.
///
/// Headings are semibold and tightly tracked. [emphasized] makes body copy
/// medium, HeroUI's weight for labels and titles; [muted] uses `muted`.
class UiDashboardText extends StatelessWidget {
  const UiDashboardText(
    this.value, {
    super.key,
    this.type = .bodySm,
    this.emphasized = false,
    this.muted = false,
  });

  final String value;
  final UiDashboardTextType type;
  final bool emphasized;
  final bool muted;

  @override
  Widget build(BuildContext context) => StyledText(
    value,
    style: uiDashboardTextStyle(
      type: type,
      emphasized: emphasized,
      muted: muted,
    ),
  );
}

/// The style [UiDashboardText] draws with, for widgets that take a
/// [TextStyler].
TextStyler uiDashboardTextStyle({
  UiDashboardTextType type = .bodySm,
  bool emphasized = false,
  bool muted = false,
}) {
  final (token, size, height, heading) = switch (type) {
    .h3 => (UiTokens.textBase, 24.0, 32.0, true),
    .h4 => (UiTokens.textBase, 20.0, 28.0, true),
    .h6 => (UiTokens.textBase, 16.0, 24.0, true),
    .bodySm => (UiTokens.textSm, 14.0, 20.0, false),
    .bodyXs => (UiTokens.textXs, 12.0, 16.0, false),
  };
  var style = TextStyler()
      .style(token.mix())
      .fontSize(size)
      .height(height / size)
      .fontWeight(
        heading
            ? FontWeight.w600
            : (emphasized ? FontWeight.w500 : FontWeight.w400),
      )
      .color(muted ? UiTokens.muted() : UiTokens.foreground());
  if (heading) style = style.letterSpacing(_tracking * size);
  return style;
}

/// `tracking-tight` on headings.
const _tracking = -0.025;

/// The toast every demo action reports itself with, in the scope's style.
void uiDashboardToast(BuildContext context, String title) => showRemixToast(
  context,
  RemixToastData(title: title, icon: RemixIcons.checkCircle),
);

/// A single choice among a few values, drawn as HeroUI's primary tabs: the
/// segmented pill. HeroUI has no segmented control; its tab list is the same
/// control in its design.
class UiDashboardSegments<T extends Object> extends StatelessWidget {
  const UiDashboardSegments({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.semanticLabel,
  });

  final List<({T value, String label})> items;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ids = {for (final (index, item) in items.indexed) '$index': item};
    final selected = items.indexWhere((item) => item.value == selectedValue);
    return Semantics(
      container: true,
      label: semanticLabel,
      child: RemixTabs(
        selectedTabId: '$selected',
        onChanged: (id) {
          final item = ids[id];
          if (item != null) onChanged(item.value);
        },
        child: UiTabBar.primary(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final MapEntry(key: id, value: item) in ids.entries)
                UiTab(tabId: id, label: item.label),
            ],
          ),
        ),
      ),
    );
  }
}
