import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'dialog.g.dart';

/// The sizes a dialog comes in, from its padding and corners. Pixel values are
/// at 100% theme scaling.
enum FortalDialogSize {
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
/// 24px at the top and bottom, or the safe area when that is larger. The
/// bottom keeps at least 6% of the viewport height.
final _dialogViewportInsets = ContextToken<EdgeInsetsGeometry>((context) {
  final safeArea = MediaQuery.paddingOf(context);
  final viewportHeight = MediaQuery.sizeOf(context).height;
  final horizontal = FortalTokens.space4.resolve(context);
  final vertical = FortalTokens.space6.resolve(context);

  return EdgeInsets.fromLTRB(
    math.max(safeArea.left, horizontal),
    math.max(safeArea.top, vertical),
    math.max(safeArea.right, horizontal),
    math.max(safeArea.bottom, math.max(vertical, viewportHeight * 0.06)),
  );
});

/// The Fortal Dialog recipe: a raised, blurred panel with a bold title.
///
/// The generated [FortalDialog] defaults to [FortalDialogSize.size3],
/// [Alignment.center], fills up to 600 logical pixels, preserves safe
/// viewport insets, and is modal.
@MixWidget(target: RemixDialog.new)
DialogStyler fortalDialogStyle({
  FortalDialogSize size = FortalDialogSize.size3,
  AlignmentGeometry align = Alignment.center,
  DialogStyler style = const DialogStyler.create(),
}) {
  final radius = switch (size) {
    FortalDialogSize.size1 || FortalDialogSize.size2 => FortalTokens.radius4(),
    FortalDialogSize.size3 || FortalDialogSize.size4 => FortalTokens.radius5(),
  };
  final padding = switch (size) {
    FortalDialogSize.size1 => FortalTokens.space3(),
    FortalDialogSize.size2 => FortalTokens.space4(),
    FortalDialogSize.size3 => FortalTokens.space5(),
    FortalDialogSize.size4 => FortalTokens.space6(),
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
        .style(FortalTokens.text5.mix())
            .fontWeight(FortalTokens.fontWeightBold())
            .color(FortalTokens.gray12())
            .wrap(
              .padding(EdgeInsetsMix.fromLTRB(0, 0, 0, FortalTokens.space3())),
            ),
      )
      .description(
        TextStyler(
          style: FortalTokens.text3.mix(),
        ).color(FortalTokens.gray12()),
      )
      .actions(
        FlexBoxStyler()
            .mainAxisAlignment(.end)
            .spacing(FortalTokens.space3())
            .margin(.top(FortalTokens.space5())),
      )
      .width(FortalTokens.dialogMaxWidth())
      .padding(.all(padding))
      .borderRadius(.all(radius))
      .color(FortalTokens.colorPanel())
      .decoration(
        BoxDecorationMix.create(boxShadow: FortalTokens.shadow6.mix()),
      )
      .containerEffects(
        RemixBoxEffectsMix.backdropBlur(FortalTokens.panelBlur()),
      )
      .merge(style);
}
