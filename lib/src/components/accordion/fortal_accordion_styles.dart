part of 'accordion.dart';

/// FortalAccordionStyle utility class for creating Fortal-themed accordion styles.
///
/// Provides static methods for direct access to accordion styling.
/// Composes the correct metrics and visuals sourced from the Fortal token system.
class FortalAccordionStyle {
  const FortalAccordionStyle._();

  /// Creates the base accordion style with Fortal design tokens.
  ///
  /// Returns a RemixAccordionStyle configured with default Fortal styling
  /// for trigger, title, trailing icon, and content.
  static RemixAccordionStyle<T> base<T>() {
    return RemixAccordionStyle<T>()
        .trigger(
          FlexBoxStyler()
              .direction(Axis.horizontal)
              .paddingX(FortalTokens.space3())
              .paddingY(FortalTokens.space3())
              .color(FortalTokens.gray1()),
        )
        .title(
          TextStyler()
              .fontSize(15)
              .fontWeight(FontWeight.w500)
              .color(FortalTokens.gray12()),
        )
        .trailingIcon(IconStyler().color(FortalTokens.gray11()).size(20))
        .content(
          BoxStyler()
              .width(double.infinity)
              .borderTop(
                color: FortalTokens.gray6(),
                width: FortalTokens.borderWidth1(),
              )
              .color(FortalTokens.gray2())
              .paddingAll(FortalTokens.space3()),
        );
  }
}
