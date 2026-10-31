import 'package:flutter/widgets.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:remix/remix.dart';

import '../../theme/tokens.dart';

class PlaygroundDashboardText extends StatelessWidget {
  const PlaygroundDashboardText(
    this.value, {
    super.key,
    this.token = PlaygroundTokens.textSm,
    this.emphasized = false,
    this.muted = false,
  });

  final String value;
  final TextStyleToken token;
  final bool emphasized;
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

void playgroundDashboardToast(BuildContext context, String title) =>
    showRemixToast(
      context,
      RemixToastData(title: title, icon: LucideIcons.circleCheck),
    );
