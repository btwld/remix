import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'popover.g.dart';

/// The application's Popover recipe.
///
/// The floating panel's surface: the `popover` fill, a `border` hairline and
/// the `md` shadow, which together tell a reader where the panel stops and the
/// page resumes.
///
/// `RemixPopover` opens on a tap of its own `child`, which a button with its
/// own `onPressed` consumes first. For a button trigger, set `openOnTap:
/// false`, toggle a `MenuController` from the button, and share one `FocusNode`
/// so the button is the only tab stop and regains focus on close:
///
/// ```dart
/// class _FiltersState extends State<Filters> {
///   final _controller = MenuController();
///   final _triggerFocus = FocusNode();
///
///   @override
///   void dispose() {
///     _triggerFocus.dispose();
///     super.dispose();
///   }
///
///   @override
///   Widget build(BuildContext context) => VanillaPopover(
///     controller: _controller,
///     openOnTap: false,
///     triggerFocusNode: _triggerFocus,
///     popoverChild: const Text('Filters go here.'),
///     child: VanillaButton.outline(
///       label: 'Filter',
///       focusNode: _triggerFocus,
///       onPressed: () =>
///           _controller.isOpen ? _controller.close() : _controller.open(),
///     ),
///   );
/// }
/// ```
@MixWidget(target: RemixPopover.new)
PopoverStyler vanillaPopoverStyle({
  PopoverStyler style = const PopoverStyler.create(),
}) => PopoverStyler()
    .color(VanillaTokens.popover())
    .border(.color(VanillaTokens.border()).width(VanillaTokens.strokeHairline))
    .borderRadius(.all(VanillaTokens.radiusMd()))
    // 288px, fixed so the panel does not resize as its content changes.
    .width(VanillaTokens.popoverWidth)
    .padding(.all(VanillaTokens.s4))
    .shadows(VanillaShadow.md.box)
    .merge(style);
