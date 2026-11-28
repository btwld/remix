import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/computed.dart' show mixOklabPremultiplied;
import '../theme/theme.dart';

part 'toggle_group.g.dart';

/// The sizes a toggle group comes in. Pixel values are at 100% theme scaling;
/// the outer height adds the 3px group padding and the 1px frame on each side.
enum UiToggleGroupSize {
  /// 28px items with 12px text and 14px icons.
  size1,

  /// 36px items with 13px text and 16px icons. The default.
  size2,

  /// 44px items with 13px text and 16px icons.
  size3,
}

/// The looks a toggle group's on item comes in.
enum UiToggleGroupVariant {
  /// The accent's indicator mixed into the surface behind the on item.
  soft,

  /// The muted fill inside a 1px border behind the on item.
  surface,
}

/// The Fortal ToggleGroup recipe: items inside a padded 1px frame, with one
/// fill that glides to the item that is on.
///
/// It reads top to bottom: the frame, the gliding fill, the item's look for
/// rest, hover, press, on, focus and disabled, then the size.
///
/// [highContrast] draws resting item text in ink and the frame in the strong
/// border.
@MixWidget(target: RemixToggleGroup.new)
ToggleGroupStyler uiToggleGroupStyle({
  UiToggleGroupVariant variant = .soft,
  UiToggleGroupSize size = .size2,
  bool highContrast = false,
  ToggleGroupStyler style = const ToggleGroupStyler.create(),
}) {
  final frame = highContrast ? UiTokens.gray8() : UiTokens.gray7();
  final rest = highContrast ? UiTokens.gray12() : UiTokens.gray11();
  final ink = UiTokens.gray12();

  return ToggleGroupStyler(
        container: FlexBoxStyler()
            .mainAxisSize(.min)
            .padding(.all(_groupPadding))
            .spacing(_itemGap)
            .color(UiTokens.gray2())
            .border(BoxBorderMix.all(_side(frame)))
            .borderRadius(.all(UiTokens.radius4OrFull())),
        item: ToggleGroupItemStyler()
            .animate(_motion)
            .alignment(.center)
            .color(_transparent)
            .labelColor(rest)
            .iconColor(rest)
            .labelFontWeight(UiTokens.fontWeightMedium())
            .onHovered(
              ToggleGroupItemStyler()
                  .color(UiTokens.gray3())
                  .labelColor(ink)
                  .iconColor(ink),
            )
            .onPressed(_pressedContent())
            .onFocusVisible(
              ToggleGroupItemStyler()
                  .color(UiTokens.gray3())
                  .labelColor(ink)
                  .iconColor(ink)
                  .containerEffects(uiFocusOutline()),
            )
            // After focus, so the gliding fill shows through a focused or
            // hovered on item.
            .onSelected(
              ToggleGroupItemStyler()
                  .color(_transparent)
                  .labelColor(ink)
                  .iconColor(ink),
            )
            .onDisabled(
              ToggleGroupItemStyler()
                  .wrap(.opacity(_disabledItemOpacity))
                  .containerEffects(.outline(.style(.none))),
            ),
      )
      .indicator(_indicator(variant))
      // Measured against the reference glide: the standard ease over 200ms
      // (0.33, 0.59, 0.76 of the travel at 16, 33 and 50ms), not a spring.
      .indicatorMotion(
        AnimationConfig.curve(
          duration: UiMotion.standard,
          curve: UiMotion.easeStandard,
        ),
      )
      .merge(_scale(size))
      .merge(style);
}

/// The group's inset around the items and the gap between them.
const _groupPadding = 3.0;
const _itemGap = 2.0;

/// How much of a disabled item shows.
const _disabledItemOpacity = 0.45;

/// How far an item's label and icon sink while held.
const _pressedScale = 0.96;

const _transparent = Color(0x00000000);

final _motion = AnimationConfig.curve(
  duration: UiMotion.fast,
  curve: UiMotion.easeStandard,
);

BorderSideMix _side(Color color) =>
    BorderSideMix(color: color, width: UiTokens.borderWidth1());

/// The content sinks while held; the item box and the fill do not.
ToggleGroupItemStyler _pressedContent() => ToggleGroupItemStyler(
  label: TextStyler().wrap(.scale(x: _pressedScale, y: _pressedScale)),
  icon: IconStyler().wrap(.scale(x: _pressedScale, y: _pressedScale)),
);

/// The fill that glides to the on item.
BoxStyler _indicator(UiToggleGroupVariant variant) => switch (variant) {
  .soft => BoxStyler().color(_onFill()).borderRadius(.all(_onFillRadius())),
  .surface =>
    BoxStyler()
        .color(UiTokens.gray3())
        .border(BoxBorderMix.all(_side(UiTokens.gray7())))
        .borderRadius(.all(_itemRadius())),
};

/// The accent's indicator mixed into the surface, 11% in light and 14% in
/// dark: neutral gray under orla, a faint tint under the other accents.
const _onFillToken = ContextToken<Color>(_resolveOnFill);

Color _onFill() => _onFillToken();

Color _resolveOnFill(BuildContext context) => mixOklabPremultiplied(
  UiTokens.gray2.resolve(context),
  UiTokens.accentIndicator.resolve(context),
  UiTheme.of(context).isDark ? 0.14 : 0.11,
);

/// An item's corner: the group corner less the group padding. The gliding
/// fill rounds one pixel past the group corner.
final _itemRadius = ContextToken<Radius>(
  (context) => Radius.circular(
    UiTokens.radius4OrFull.resolve(context).x - _groupPadding,
  ),
);
final _onFillRadius = ContextToken<Radius>(
  (context) => Radius.circular(UiTokens.radius4OrFull.resolve(context).x + 1),
);

/// The item height, which is also its minimum width, and its padding, text
/// and icon size.
ToggleGroupStyler _scale(UiToggleGroupSize size) {
  final (edge, paddingX, text, icon) = switch (size) {
    .size1 => (_itemEdge1(), UiTokens.space2(), UiTokens.text1, _icon1()),
    .size2 => (
      _itemEdge2(),
      _itemPadding2(),
      UiTokens.text2,
      UiTokens.space4(),
    ),
    .size3 => (
      UiTokens.controlHeight3(),
      UiTokens.space3(),
      UiTokens.text2,
      UiTokens.space4(),
    ),
  };

  return ToggleGroupStyler(
    item: ToggleGroupItemStyler()
        .minHeight(edge)
        .minWidth(edge)
        .borderRadius(.all(_itemRadius()))
        .container(
          FlexBoxStyler().padding(.horizontal(paddingX)).spacing(_contentGap()),
        )
        .label(.style(text.mix()))
        .icon(.size(icon)),
  );
}

// Off-scale item metrics: one 4px space under the 32 and 40px control
// heights, a 10px pad, a 6px content gap and a 14px small icon.
final _itemEdge1 = ContextToken<double>(
  (context) =>
      UiTokens.controlHeight1.resolve(context) -
      UiTokens.space1.resolve(context),
);
final _itemEdge2 = ContextToken<double>(
  (context) =>
      UiTokens.controlHeight2.resolve(context) -
      UiTokens.space1.resolve(context),
);
final _itemPadding2 = ContextToken<double>(
  (context) =>
      UiTokens.space2.resolve(context) + UiTokens.space1.resolve(context) / 2,
);
final _contentGap = ContextToken<double>(
  (context) =>
      UiTokens.space2.resolve(context) - UiTokens.space1.resolve(context) / 2,
);
final _icon1 = ContextToken<double>(
  (context) =>
      UiTokens.space4.resolve(context) - UiTokens.space1.resolve(context) / 2,
);
