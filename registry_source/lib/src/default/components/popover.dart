import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'popover.g.dart';

/// The application's Popover recipe.
///
/// Remix owns the rendering, the overlay, the anchor positioning, the
/// dismiss-on-outside-tap behavior, focus, and the popover accessibility
/// semantics; this recipe supplies only the floating panel's surface.
///
/// A popover sits *over* arbitrary content, so its edge is doing real work: it
/// is what tells a reader where the panel stops and the page resumes. That edge
/// is a `border` hairline plus the `md` shadow. The fill is `popover`, the
/// surface every floating panel shares: the page color in the light theme and a
/// step lighter than the page in the dark one.
///
/// One composition trap worth knowing: `RemixPopover` opens on a tap of its
/// own `child`, so a trigger that handles its own taps never lets the popover
/// see one. A `VanillaButton` with an `onPressed` is exactly that, and a
/// popover built the obvious way silently never opens. Drive it from a
/// `MenuController` when the trigger has to be a button:
///
/// ```dart
/// final filters = MenuController();
///
/// VanillaPopover(
///   controller: filters,
///   popoverChild: const Text('Filters go here.'),
///   child: VanillaButton.outline(
///     label: 'Filter',
///     onPressed: () => filters.isOpen ? filters.close() : filters.open(),
///   ),
/// )
/// ```
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// VanillaPopover(
///   style: PopoverStyler().width(360),
///   popoverChild: const Text('A wider panel for a longer form.'),
///   child: const Text('Details'),
/// )
/// ```
@MixWidget(target: RemixPopover.new)
PopoverStyler vanillaPopoverStyle({
  PopoverStyler style = const PopoverStyler.create(),
}) => PopoverStyler()
    .color(VanillaTokens.popover())
    .border(.color(VanillaTokens.border()).width(VanillaStroke.hairline))
    .borderRadius(.all(VanillaTokens.radiusMd()))
    // 288px: a popover holds a short form or a few lines, and a fixed width
    // keeps it from resizing as that content changes. A call site with wider
    // content sets `.width(...)` through [style].
    .width(VanillaSize.popoverWidth)
    .padding(.all(VanillaSpace.s4))
    .shadows(VanillaShadow.md.box)
    .merge(style);
