import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'dialog.g.dart';

/// The sizes a dialog comes in, from its padding and corners. Pixel values are
/// at 100% theme scaling.
enum UiDialogSize {
  /// 12px padding.
  size1,

  /// 16px padding.
  size2,

  /// 24px padding. The default.
  size3,

  /// 32px padding.
  size4,
}

/// Padding that keeps the dialog off the screen edges: 16px at the sides and
/// 32px at the top and bottom, or the safe area when that is larger. The
/// bottom keeps at least 6% of the viewport height.
final _dialogViewportInsets = ContextToken<EdgeInsetsGeometry>((context) {
  final safeArea = MediaQuery.paddingOf(context);
  final viewportHeight = MediaQuery.sizeOf(context).height;
  final horizontal = UiTokens.space4.resolve(context);
  final vertical = UiTokens.space6.resolve(context);

  return EdgeInsets.fromLTRB(
    math.max(safeArea.left, horizontal),
    math.max(safeArea.top, vertical),
    math.max(safeArea.right, horizontal),
    math.max(safeArea.bottom, math.max(vertical, viewportHeight * 0.06)),
  );
});

/// The Ui Dialog recipe: a raised, blurred panel with a bold title.
///
/// The generated [UiDialog] defaults to [UiDialogSize.size3],
/// [Alignment.center], fills up to 600 logical pixels, preserves safe
/// viewport insets, and is modal.
@MixWidget(target: RemixDialog.new)
DialogStyler uiDialogStyle({
  UiDialogSize size = .size3,
  AlignmentGeometry align = Alignment.center,
  DialogStyler style = const DialogStyler.create(),
}) {
  final radius = switch (size) {
    .size1 || .size2 => UiTokens.radius4(),
    .size3 || .size4 => UiTokens.radius5(),
  };
  final padding = switch (size) {
    .size1 => UiTokens.space3(),
    .size2 => UiTokens.space4(),
    .size3 => UiTokens.space5(),
    .size4 => UiTokens.space6(),
  };

  return DialogStyler()
      .wrap(
        .modifier(
          PaddingModifierMix.create(padding: Prop.token(_dialogViewportInsets)),
        ).align(alignment: align).orderOfModifiers([
          PaddingModifier,
          AlignModifier,
        ]),
      )
      .title(
        .style(UiTokens.text5.mix())
            .fontWeight(UiTokens.fontWeightBold())
            .color(UiTokens.gray12())
            .wrap(.padding(EdgeInsetsMix.fromLTRB(0, 0, 0, UiTokens.space3()))),
      )
      .description(
        TextStyler(style: UiTokens.text3.mix()).color(UiTokens.gray12()),
      )
      .actions(
        FlexBoxStyler()
            .mainAxisAlignment(.end)
            .spacing(UiTokens.space3())
            .margin(.top(UiTokens.space5())),
      )
      .width(UiTokens.dialogMaxWidth())
      .padding(.all(padding))
      .borderRadius(.all(radius))
      .color(UiTokens.colorPanel())
      .decoration(BoxDecorationMix.create(boxShadow: UiTokens.shadow6.mix()))
      .containerEffects(RemixBoxEffectsMix.backdropBlur(UiTokens.panelBlur()))
      .merge(style);
}
