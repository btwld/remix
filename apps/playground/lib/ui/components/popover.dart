import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
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
/// `RemixPopover` opens on a tap of its own `child`, which a button with its
/// own `onPressed` consumes first. For a button trigger, set `openOnTap:
/// false`, toggle a `MenuController` from the button, and give the popover and
/// the button one `FocusNode`, so the button is the only tab stop and takes
/// focus back when the popover closes:
///
/// ```dart
/// final filters = MenuController();
/// final filtersFocus = FocusNode();
///
/// PlaygroundPopover(
///   controller: filters,
///   openOnTap: false,
///   triggerFocusNode: filtersFocus,
///   popoverChild: const Text('Filters go here.'),
///   child: PlaygroundButton.outline(
///     label: 'Filter',
///     focusNode: filtersFocus,
///     onPressed: () => filters.isOpen ? filters.close() : filters.open(),
///   ),
/// )
/// ```
@MixWidget(target: RemixPopover.new)
PopoverStyler playgroundPopoverStyle({
  PopoverStyler style = const PopoverStyler.create(),
}) => PopoverStyler()
    .color(PlaygroundTokens.popover())
    .border(
      .color(PlaygroundTokens.border()).width(PlaygroundTokens.strokeHairline),
    )
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    // 288px: a popover holds a short form or a few lines, and a fixed width
    // keeps it from resizing as that content changes. A call site with wider
    // content sets `.width(...)` through [style].
    .width(PlaygroundTokens.popoverWidth)
    .padding(.all(PlaygroundTokens.s4))
    .shadows(PlaygroundShadow.md.box)
    .merge(style);
