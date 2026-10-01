import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/scale.dart';
import '../theme/tokens.dart';
import 'button.dart';
import 'icon_button.dart';

part 'toast.g.dart';

/// The tones this application offers for a toast.
enum PlaygroundToastVariant {
  /// An ordinary confirmation or notice.
  neutral,

  /// A failure the reader should notice.
  ///
  /// Visual only. Pair it with `RemixToastPriority.assertive` when the message
  /// must interrupt a screen reader; a red outline alone announces nothing.
  destructive,
}

/// The application's Toast recipe.
///
/// Remix owns the queue, the timers, focus, and the announcement through
/// `RemixToastScope`; this recipe owns the surface, the type, and the colors.
/// Hand it to the scope once, above the app's `Navigator` so every route,
/// including dialogs, can reach it:
///
/// ```dart
/// WidgetsApp(
///   color: const Color(0xFFFFFFFF),
///   pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
///     settings: settings,
///     pageBuilder: (context, animation, secondaryAnimation) => builder(context),
///   ),
///   home: const SizedBox.shrink(),
///   builder: (context, child) => Overlay.wrap(
///     child: RemixToastScope(style: playgroundToastStyle(), child: child!),
///   ),
/// )
/// ```
///
/// One toast can switch tone through `RemixToastData.style`, which merges over
/// the scope's style:
///
/// ```dart
/// showRemixToast(
///   context,
///   RemixToastData(
///     title: 'Upload failed',
///     priority: RemixToastPriority.assertive,
///     style: playgroundToastStyle(variant: .destructive),
///   ),
/// );
/// ```
///
/// The action and the close button reuse this application's Button and
/// IconButton recipes, so they keep their own hover, focus, and press states.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it.
@MixWidget(target: RemixToast.new)
ToastStyler playgroundToastStyle({
  PlaygroundToastVariant variant = .neutral,
  ToastStyler style = const ToastStyler.create(),
}) => _base().merge(_variantStyle(variant)).merge(style);

/// The toast's lift: 4px down, a 12px blur, black at 10%. A toast floats over
/// content that keeps scrolling beneath it, so it is heavier than a card's.
final _shadow = BoxShadowMix(
  color: const Color(0x1A000000),
  offset: const Offset(0, 4),
  blurRadius: 12,
);

/// Surface, layout, and typography shared by both tones: the `popover` surface
/// with the theme's `radius`.
ToastStyler _base() => ToastStyler()
    .color(PlaygroundTokens.popover())
    .border(.color(PlaygroundTokens.border()).width(PlaygroundStroke.hairline))
    .borderRadius(.all(PlaygroundTokens.radiusLg()))
    .padding(.all(PlaygroundSpace.s4))
    .maxWidth(PlaygroundSize.toastWidth)
    .shadow(_shadow)
    .spacing(PlaygroundSpace.s3)
    .content(FlexBoxStyler().spacing(PlaygroundSpace.s1))
    .title(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).fontWeight(FontWeight.w500).color(PlaygroundTokens.popoverForeground()),
    )
    .description(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    .icon(.size(PlaygroundSize.icon))
    .action(playgroundButtonStyle(variant: .outline, size: .small))
    .closeButton(playgroundIconButtonStyle(variant: .ghost, size: .small));

/// The tone shows in the glyph and, for `destructive`, the outline. The
/// sentence stays in `popoverForeground`, the color it is readable in on the
/// toast's own surface.
ToastStyler _variantStyle(PlaygroundToastVariant variant) => switch (variant) {
  .neutral => ToastStyler().icon(.color(PlaygroundTokens.mutedForeground())),
  .destructive =>
    ToastStyler()
        .border(.color(PlaygroundTokens.destructive()))
        .icon(.color(PlaygroundTokens.destructive())),
};
