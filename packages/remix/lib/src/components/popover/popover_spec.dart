part of 'popover.dart';

/// Resolved visual properties for a [RemixPopover] overlay.
@MixableSpec()
class RemixPopoverSpec with _$RemixPopoverSpec {
  @override
  final StyleSpec<BoxSpec> container;

  const RemixPopoverSpec({StyleSpec<BoxSpec>? container})
    : container = container ?? const StyleSpec(spec: BoxSpec());
}
