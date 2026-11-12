import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/message.dart';
import '../theme/theme.dart';

/// Styles for a message: a card and a ghost button that expands a long message.
@immutable
final class UiAgentMessageRecipe {
  const UiAgentMessageRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.collapsibleStyle,
    required this.toggleStyle,
  });

  /// Styles for the message row, avatar, header, body and footer.
  final UiMessageStyler style;

  /// Styles for the card the message sits in.
  final CardStyler surfaceStyle;

  /// Styles for the collapsed height and clipping of a long message.
  final UiMessageCollapsibleStyler collapsibleStyle;

  /// Styles for the button that expands or collapses a long message.
  final ButtonStyler toggleStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
UiAgentMessageRecipe uiAgentMessageRecipe({
  UiMessageStyler style = const UiMessageStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  UiMessageCollapsibleStyler collapsibleStyle =
      const UiMessageCollapsibleStyler.create(),
  ButtonStyler toggleStyle = const ButtonStyler.create(),
}) => UiAgentMessageRecipe(
  style: UiMessageStyler(
    row: FlexBoxStyler().mainAxisSize(.max).spacing(UiTokens.space2()),
    avatar: BoxStyler().size(
      UiTokens.messageAvatarSize(),
      UiTokens.messageAvatarSize(),
    ),
    header: BoxStyler().padding(.bottom(UiTokens.space2())),
    body: BoxStyler(),
    footer: BoxStyler().padding(.top(UiTokens.space1())),
    maxWidth: UiTokens.messageContentMaxWidth(),
  ).merge(style),
  surfaceStyle: uiCardStyle(style: surfaceStyle),
  collapsibleStyle: UiMessageCollapsibleStyler(
    collapsedHeight: UiTokens.messageCollapsedHeight(),
    container: BoxStyler(),
    clipped: BoxStyler(),
  ).merge(collapsibleStyle),
  toggleStyle: uiButtonStyle(variant: .ghost, size: .size1, style: toggleStyle),
);
