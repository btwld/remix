part of 'popover.dart';

/// Resolved visual properties for a [RemixPopover] overlay.
@MixableSpec(extraStylerMixins: [RemixBoxStylerMixin])
class RemixPopoverSpec with _$RemixPopoverSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  const RemixPopoverSpec({StyleSpec<BoxSpec>? container})
    : container = container ?? const StyleSpec(spec: BoxSpec());
}
