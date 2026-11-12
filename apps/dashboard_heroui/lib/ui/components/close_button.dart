import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/theme.dart';
import 'spinner.dart';

part 'close_button.g.dart';

/// HeroUI recipe for [RemixIconButton]: the 24px `CloseButton`.
///
/// The cross is the project icon library's; HeroUI draws its own. Pass [icon]
/// to replace it. [semanticLabel] defaults to "Close".
@MixWidget(target: RemixIconButton.new)
IconButtonStyler uiCloseButtonStyle({
  IconData? icon = RemixIcons.close,
  String semanticLabel = 'Close',
  IconButtonStyler style = const IconButtonStyler.create(),
}) => IconButtonStyler()
    .size(_size, _size)
    .padding(.all(_padding))
    .alignment(.center)
    .borderRadius(.all(UiTokens.radiusXl()))
    .color(UiTokens.defaultColor())
    .icon(.size(_iconSize).color(UiTokens.muted()))
    .spinner(uiInlineSpinnerStyle(UiTokens.muted()))
    .onPressed(
      IconButtonStyler().scale(_pressedScale).animate(UiTokens.transformMotion),
    )
    .onHovered(IconButtonStyler().color(UiTokens.defaultHover()))
    .onFocusVisible(.containerEffects(uiFocusRing()))
    .animate(UiTokens.fillMotion)
    .onDisabled(IconButtonStyler().wrap(.opacity(UiTokens.disabledOpacity)))
    .merge(style);

/// `h-6 w-6 p-1`, and the icon's `size-4`.
const _size = 24.0;
const _padding = 4.0;
const _iconSize = 16.0;

/// `transform: scale(0.93)` while pressed.
const _pressedScale = .93;
