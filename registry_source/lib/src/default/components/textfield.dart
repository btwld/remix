// `DragStartBehavior` and `MaxLengthEnforcement` appear in the generated
// constructors below, so they have to be visible from this library even though
// nothing written here names them.
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'textfield.g.dart';

/// The application's TextField recipe.
///
/// There is no hover fragment: the I-beam cursor is the affordance, and tinting
/// the box would compete with the focus ring that follows.
///
/// `EditableText` asserts on an `Overlay` ancestor when the field takes focus.
/// Any app with a `Navigator` has one; a bare `WidgetsApp(builder: ...)` has to
/// supply its own.
@MixWidget(target: RemixTextField.new)
TextFieldStyler vanillaTextFieldStyle({
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  return _base()
      .minHeight(VanillaTokens.controlMd)
      .padding(
        .symmetric(horizontal: VanillaTokens.s3, vertical: VanillaTokens.s1),
      )
      .crossAxisAlignment(.center)
      .merge(style);
}

/// The application's TextArea recipe.
///
/// The field's recipe with a taller resting box (at least 64px, 8px above and
/// below the text) and accessories pinned to the first line.
@MixWidget(target: RemixTextArea.new)
TextFieldStyler vanillaTextAreaStyle({
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  return _base()
      .minHeight(VanillaTokens.s16)
      .padding(
        .symmetric(horizontal: VanillaTokens.s3, vertical: VanillaTokens.s2),
      )
      .crossAxisAlignment(.start)
      .merge(style);
}

/// The surface, the text roles and every state fragment, shared by the field
/// and the area.
TextFieldStyler _base() => TextFieldStyler()
    .animate(VanillaTokens.motion)
    // Transparent, or `input` at 30% in the dark theme: a well, not a hole.
    .color(vanillaTint(VanillaTokens.input, 0, dark: 0.3)())
    .border(.color(VanillaTokens.input()).width(VanillaTokens.strokeHairline))
    .borderRadius(.all(VanillaTokens.radiusMd()))
    // In the effects layer: the fill is transparent, and a decoration shadow
    // would show through it.
    .containerEffects(.behindContent(VanillaShadow.xs.effects))
    .spacing(VanillaTokens.s2)
    .text(.style(VanillaTokens.textSm.mix()).color(VanillaTokens.foreground()))
    // Quieter than the value, or an empty field looks filled in.
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
    .layout(.direction(.vertical).spacing(VanillaTokens.s2))
    .wrap(
      .iconTheme(
        color: VanillaTokens.mutedForeground(),
        size: VanillaTokens.icon,
      ),
    )
    // Any focus, not only keyboard focus: a browser treats a focused text input
    // as `:focus-visible` even after a click, so shadcn's input rings on click.
    .onFocused(
      TextFieldStyler()
          .containerEffects(vanillaFocusRing())
          .border(vanillaFocusBorder()),
    )
    // Mix ships no `onError`; `RemixTextField` drives this standard
    // `WidgetState` from its own `error` flag. `destructive` clears 4.5:1 on the
    // page in both themes, so the helper line is set in it too.
    .variant(
      ContextVariant.widgetState(.error),
      TextFieldStyler()
          .border(.color(VanillaTokens.destructive()))
          .helperText(.color(VanillaTokens.destructive()))
          // Focus rings in the same red: `destructive` at 20%, 40% in the dark.
          .onFocused(
            TextFieldStyler()
                .containerEffects(
                  vanillaFocusRing(
                    color: VanillaTokens.destructive,
                    alpha: 0.2,
                    dark: 0.4,
                  ),
                )
                .border(.color(VanillaTokens.destructive())),
          ),
    )
    // Declared last so it wins; the ring is cleared because a disabled control
    // that still rings reads as editable.
    .onDisabled(
      TextFieldStyler()
          .containerEffects(.outline(.style(.none)))
          .wrap(.opacity(VanillaTokens.disabledOpacity)),
    );
