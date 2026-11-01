import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'popover.g.dart';

/// HeroUI recipe for [RemixPopover], the overlay surface.
///
/// Anchoring, dismissal, and focus return stay with Remix. To open the popover
/// from a button, set `openOnTap: false`, open it from the button's `onPressed`
/// with the popover's `controller`, and pass one `FocusNode` as both the
/// popover's `triggerFocusNode` and the button's `focusNode`, so the button is
/// the only tab stop and takes focus back on close.
@MixWidget(target: RemixPopover.new)
PopoverStyler heroUiPopoverStyle({
  PopoverStyler style = const PopoverStyler.create(),
}) => PopoverStyler()
    // `.popover` has `p-0` around `.popover__dialog`'s `p-4`: one 16px inset.
    .padding(.all(_inset))
    .color(HeroUiTokens.overlay())
    .borderRadius(.all(HeroUiTokens.radiusPanel()))
    .containerEffects(heroUiSurfaceEffects(overlay: true))
    .wrap(.defaultTextStyle(style: HeroUiTokens.textSm.mix()))
    .merge(style);

/// `.popover__dialog` `p-4`.
const _inset = 16.0;
