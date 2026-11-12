import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';
import 'button.dart';
import 'icon_button.dart';

part 'toast.g.dart';

/// The tones this application offers for a toast.
enum VanillaToastVariant {
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
/// Hand it to `RemixToastScope` once, above the app's `Navigator`, so every
/// route (dialogs included) can reach it:
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
///     child: RemixToastScope(style: vanillaToastStyle(), child: child!),
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
///     style: vanillaToastStyle(variant: .destructive),
///   ),
/// );
/// ```
///
/// The action and close button reuse the Button and IconButton recipes, with
/// their own hover, focus and press states.
@MixWidget(target: RemixToast.new)
ToastStyler vanillaToastStyle({
  VanillaToastVariant variant = .neutral,
  ToastStyler style = const ToastStyler.create(),
}) {
  // The tone shows in the glyph and, for `destructive`, the outline. The text
  // stays `popoverForeground`, which reads on the toast's own surface.
  final (:border, :icon) = switch (variant) {
    .neutral => (
      border: VanillaTokens.border(),
      icon: VanillaTokens.mutedForeground(),
    ),
    .destructive => (
      border: VanillaTokens.destructive(),
      icon: VanillaTokens.destructive(),
    ),
  };

  return ToastStyler()
      .color(VanillaTokens.popover())
      .border(.color(border).width(VanillaTokens.strokeHairline))
      .borderRadius(.all(VanillaTokens.radiusLg()))
      .padding(.all(VanillaTokens.s4))
      .maxWidth(VanillaTokens.toastWidth)
      // Heavier than a card's: a toast floats over content that keeps scrolling
      // beneath it. Black at 10%.
      .shadow(
        BoxShadowMix(
          color: const Color(0x1A000000),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      )
      .spacing(VanillaTokens.s3)
      .content(FlexBoxStyler().spacing(VanillaTokens.s1))
      .title(
        .style(
          VanillaTokens.textSm.mix(),
        ).fontWeight(FontWeight.w500).color(VanillaTokens.popoverForeground()),
      )
      .description(
        .style(
          VanillaTokens.textSm.mix(),
        ).color(VanillaTokens.mutedForeground()),
      )
      .icon(.size(VanillaTokens.icon).color(icon))
      .action(vanillaButtonStyle(variant: .outline, size: .small))
      .closeButton(vanillaIconButtonStyle(variant: .ghost, size: .small))
      .merge(style);
}
