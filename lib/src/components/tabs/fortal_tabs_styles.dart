// ignore_for_file: unused_element

part of 'tabs.dart';

/// FortalTabsStyles utility class for creating Fortal-themed tab styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Fortal token JSON.
class FortalTabsStyles {
  const FortalTabsStyles._();

  /// Factory constructor for FortalTabsStyles with variant and size parameters.
  ///
  /// Returns a RemixTabStyle configured with Fortal design tokens.
  /// Defaults to surface variant with size2.
  static RemixTabStyle create() {
    return base();
  }

  static RemixTabStyle base() {
    return RemixTabStyle()
        .label(TextStyler().color(FortalTokens.gray12()))
        .icon(IconStyler(color: FortalTokens.gray12(), size: 16.0))
        .wrapBox(
          BoxStyler()
              .height(40)
              .paddingX(4)
              .alignment(Alignment.center)
              .borderBottom(
                color: Colors.transparent,
                width: FortalTokens.borderWidth2(),
              ),
        )
        .container(
          FlexBoxStyler()
              .direction(Axis.horizontal)
              .borderRadiusAll(FortalTokens.radius2())
              .mainAxisAlignment(MainAxisAlignment.center)
              .crossAxisAlignment(CrossAxisAlignment.center)
              .spacing(8.0),
        )
        .onHovered(RemixTabStyle().color(FortalTokens.gray3()))
        .onSelected(
          RemixTabStyle()
              .label(TextStyler().fontWeight(FortalTokens.fontWeightMedium()))
              .wrapBox(BoxStyler().borderBottom(color: FortalTokens.accent9())),
        )
        .padding(EdgeInsetsMix.symmetric(horizontal: 12.0, vertical: 6.0));
  }
}
