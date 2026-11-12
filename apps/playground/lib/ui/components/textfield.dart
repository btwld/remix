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
TextFieldStyler playgroundTextFieldStyle({
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  return _base()
      .minHeight(PlaygroundTokens.controlMd)
      .padding(
        .symmetric(
          horizontal: PlaygroundTokens.s3,
          vertical: PlaygroundTokens.s1,
        ),
      )
      .crossAxisAlignment(.center)
      .merge(style);
}

/// The application's TextArea recipe.
///
/// The field's recipe with a taller resting box (at least 64px, 8px above and
/// below the text) and accessories pinned to the first line.
@MixWidget(target: RemixTextArea.new)
TextFieldStyler playgroundTextAreaStyle({
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  return _base()
      .minHeight(PlaygroundTokens.s16)
      .padding(
        .symmetric(
          horizontal: PlaygroundTokens.s3,
          vertical: PlaygroundTokens.s2,
        ),
      )
      .crossAxisAlignment(.start)
      .merge(style);
}

/// The surface, the text roles and every state fragment, shared by the field
/// and the area.
TextFieldStyler _base() => TextFieldStyler()
    .animate(PlaygroundTokens.motion)
    // Transparent, or `input` at 30% in the dark theme: a well, not a hole.
    .color(playgroundTint(PlaygroundTokens.input, 0, dark: 0.3)())
    .border(
      .color(PlaygroundTokens.input()).width(PlaygroundTokens.strokeHairline),
    )
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    // In the effects layer: the fill is transparent, and a decoration shadow
    // would show through it.
    .containerEffects(.behindContent(PlaygroundShadow.xs.effects))
    .spacing(PlaygroundTokens.s2)
    .text(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.foreground()),
    )
    // Quieter than the value, or an empty field looks filled in.
    .hintText(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    .cursorColor(PlaygroundTokens.foreground())
    .label(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).fontWeight(FontWeight.w500).color(PlaygroundTokens.foreground()),
    )
    .helperText(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    .layout(.direction(.vertical).spacing(PlaygroundTokens.s2))
    .wrap(
      .iconTheme(
        color: PlaygroundTokens.mutedForeground(),
        size: PlaygroundTokens.icon,
      ),
    )
    // Any focus, not only keyboard focus: a browser treats a focused text input
    // as `:focus-visible` even after a click, so shadcn's input rings on click.
    .onFocused(
      TextFieldStyler()
          .containerEffects(playgroundFocusRing())
          .border(playgroundFocusBorder()),
    )
    // Mix ships no `onError`; `RemixTextField` drives this standard
    // `WidgetState` from its own `error` flag. `destructive` clears 4.5:1 on the
    // page in both themes, so the helper line is set in it too.
    .variant(
      ContextVariant.widgetState(.error),
      TextFieldStyler()
          .border(.color(PlaygroundTokens.destructive()))
          .helperText(.color(PlaygroundTokens.destructive()))
          // Focus rings in the same red: `destructive` at 20%, 40% in the dark.
          .onFocused(
            TextFieldStyler()
                .containerEffects(
                  playgroundFocusRing(
                    color: PlaygroundTokens.destructive,
                    alpha: 0.2,
                    dark: 0.4,
                  ),
                )
                .border(.color(PlaygroundTokens.destructive())),
          ),
    )
    // Declared last so it wins; the ring is cleared because a disabled control
    // that still rings reads as editable.
    .onDisabled(
      TextFieldStyler()
          .containerEffects(.outline(.style(.none)))
          .wrap(.opacity(PlaygroundTokens.disabledOpacity)),
    );
