import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../theme/tokens.dart';

class VanillaDashboardText extends StatelessWidget {
  const VanillaDashboardText(
    this.value, {
    super.key,
    this.token = VanillaTokens.textSm,
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
          muted ? VanillaTokens.mutedForeground() : VanillaTokens.foreground(),
        ),
  );
}

void vanillaDashboardToast(BuildContext context, String title) =>
    showRemixToast(
      context,
      RemixToastData(title: title, icon: RemixIcons.checkCircled),
    );
