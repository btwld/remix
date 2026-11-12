import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../theme/tokens.dart';

/// A run of dashboard text in the preset's type scale.
class PlaygroundDashboardText extends StatelessWidget {
  const PlaygroundDashboardText(
    this.value, {
    super.key,
    this.token = PlaygroundTokens.textSm,
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
          muted
              ? PlaygroundTokens.mutedForeground()
              : PlaygroundTokens.foreground(),
        ),
  );
}

/// Shows a confirmation toast with [title].
void playgroundDashboardToast(BuildContext context, String title) =>
    showRemixToast(
      context,
      RemixToastData(title: title, icon: RemixIcons.checkCircle),
    );
