import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../../theme/tokens.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// A run of dashboard text in the preset's type scale.
class VanillaDashboardText extends StatelessWidget {
  const VanillaDashboardText(
    this.value, {
    super.key,
    this.token = VanillaTokens.textSm,
    this.emphasized = false,
    this.muted = false,
  });

  /// The text to show.
  final String value;

  /// The text size token.
  final TextStyleToken token;

  /// Whether to use the semibold weight.
  final bool emphasized;

  /// Whether to use the muted foreground color.
  final bool muted;

  @override
  Widget build(BuildContext context) => StyledText(
    value,
    style: TextStyler()
        .style(token.mix())
        .fontWeight(emphasized ? FontWeight.w600 : FontWeight.w400)
        .color(
          muted ? VanillaTokens.mutedForeground() : VanillaTokens.foreground(),
        ),
  );
}

/// Shows a confirmation toast with [title].
void vanillaDashboardToast(BuildContext context, String title) =>
    showRemixToast(
      context,
      RemixToastData(title: title, icon: RemixIcons.checkCircle),
    );
