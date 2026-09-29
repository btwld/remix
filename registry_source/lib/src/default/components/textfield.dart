// `DragStartBehavior` and `MaxLengthEnforcement` appear in the generated
// constructors below, so they have to be visible from this library even though
// nothing written here names them.
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'textfield.g.dart';

/// The application's TextField recipe.
///
/// Remix owns the rendering, the editing behavior, the label/hint/helper
/// composition, focus, selection, and the input accessibility semantics —
/// including announcing the error state. This recipe supplies the surface, the
/// text colors, and the focus/error/disabled fragments.
///
/// There is deliberately no hover fragment, as in shadcn: a text field's
/// affordance is the I-beam cursor Remix already sets, and tinting the box on
/// hover would only compete with the focus ring that follows a moment later.
///
/// One host requirement travels with it: `EditableText` asserts on an
/// `Overlay` ancestor the moment the field takes focus, for its selection
/// handles and magnifier. Any application with a `Navigator` — `MaterialApp`,
/// `CupertinoApp`, or a `WidgetsApp` with routes — already has one. A bare
/// `WidgetsApp(builder: ...)` does not, and has to supply an `Overlay` itself.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat the recipe's error outline has to be
/// declared as an error fragment too.
@MixWidget(target: RemixTextField.new)
TextFieldStyler vanillaTextFieldStyle({
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  return _base()
      .minHeight(VanillaSize.controlMd)
      .padding(
        .symmetric(horizontal: VanillaSpace.s3, vertical: VanillaSpace.s1),
      )
      // A single line sits on the field's centre line; the accessories go with
      // it.
      .crossAxisAlignment(.center)
      .merge(style);
}

/// The application's TextArea recipe.
///
/// `RemixTextArea` is `RemixTextField` with multi-line defaults, and it shares
/// the same styler, so this is the field's recipe with two changes: shadcn's
/// taller resting box (`min-h-16 py-2`), and accessories pinned to the first
/// line instead of floating in the middle of a growing one.
///
/// [style] is merged **last**, exactly as it is for the single-line field.
@MixWidget(target: RemixTextArea.new)
TextFieldStyler vanillaTextAreaStyle({
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  return _base()
      .minHeight(VanillaSpace.s16)
      .padding(
        .symmetric(horizontal: VanillaSpace.s3, vertical: VanillaSpace.s2),
      )
      .crossAxisAlignment(.start)
      .merge(style);
}

/// The field's fill: transparent on a light page, and `input` at 30% on a
/// dark one, as shadcn's `bg-transparent dark:bg-input/30` paints it, so a
/// dark field reads as a well rather than a hole.
final _fill = vanillaTint(VanillaTokens.input, 0, dark: _darkFillAlpha);

/// See [_fill].
const _darkFillAlpha = 0.3;

/// The surface, the four text roles, and every state fragment: shadcn's
/// `input.tsx`, with the field label and helper from `field.tsx`.
///
/// Both recipes share this whole body; only the box's height, its vertical
/// inset, and the accessory alignment differ between them.
TextFieldStyler _base() => TextFieldStyler()
    .animate(VanillaMotion.standard)
    .color(_fill())
    .border(.color(VanillaTokens.input()).width(VanillaStroke.hairline))
    .borderRadius(.all(VanillaTokens.radiusMd()))
    // In the effects layer rather than the decoration: the fill is
    // transparent, and a decoration shadow would show through it.
    .containerEffects(.behindContent(VanillaShadow.xs.effects))
    .spacing(VanillaSpace.s2)
    .text(.style(VanillaTokens.textSm.mix()).color(VanillaTokens.foreground()))
    // The placeholder is not the value: it has to read as the quieter of the
    // two, or an empty field looks filled in.
    .hintText(
      .style(VanillaTokens.textSm.mix()).color(VanillaTokens.mutedForeground()),
    )
    .cursorColor(VanillaTokens.foreground())
    .label(
      .style(
        VanillaTokens.textSm.mix(),
      ).fontWeight(FontWeight.w500).color(VanillaTokens.foreground()),
    )
    .helperText(
      .style(VanillaTokens.textSm.mix()).color(VanillaTokens.mutedForeground()),
    )
    .layout(.direction(.vertical).spacing(VanillaSpace.s2))
    .onFocusVisible(_focusVisibleStyle())
    .merge(_errorStyle())
    .onDisabled(_disabledStyle());

/// The keyboard focus ring: shadcn's 3px `ring` band at half strength, with
/// the field's own outline turned `ring`.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the
/// box without taking layout space, so focusing a field never reflows the form
/// it sits in.
TextFieldStyler _focusVisibleStyle() => TextFieldStyler()
    .containerEffects(vanillaFocusRing())
    .border(vanillaFocusBorder());

/// The invalid field: a `destructive` outline and a `destructive` helper line.
///
/// Spelled with `variant` rather than one of the `on…` helpers because Mix
/// ships no `onError`; the state itself is a standard `WidgetState` that
/// `RemixTextField` drives from its own `error` flag.
///
/// Of this vocabulary's thirty-three tokens, `destructive` is the one that
/// means danger, and the shipped themes keep it above the 4.5:1 text floor on
/// the page — 4.8:1 in the light theme and 6.9:1 in the dark — so the message
/// that explains the problem is set in it, as shadcn's `FieldError` is. Remix
/// announces the error to assistive technology either way.
TextFieldStyler _errorStyle() => TextFieldStyler().variant(
  ContextVariant.widgetState(.error),
  TextFieldStyler()
      .border(.color(VanillaTokens.destructive()))
      .helperText(.color(VanillaTokens.destructive()))
      // An invalid field that takes focus rings in its own red, as shadcn's
      // `aria-invalid:ring-destructive/20` does, and keeps its red outline.
      .onFocusVisible(
        TextFieldStyler()
            .containerEffects(
              vanillaFocusRing(
                color: VanillaTokens.destructive,
                alpha: _errorRingAlpha,
                dark: _darkErrorRingAlpha,
              ),
            )
            .border(.color(VanillaTokens.destructive())),
      ),
);

/// The invalid field's focus ring: `ring-destructive/20`, `/40` in the dark.
const _errorRingAlpha = 0.2;
const _darkErrorRingAlpha = 0.4;

/// Declared last so it wins over every other state fragment.
///
/// A disabled field keeps its surface and simply fades; the focus ring is
/// cleared because a disabled control that still draws a focus ring reads as
/// editable.
TextFieldStyler _disabledStyle() => TextFieldStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(VanillaOpacity.disabled));
