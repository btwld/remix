part of 'dialog.dart';

@MixableSpec()
class RemixDialogSpec extends Spec<RemixDialogSpec>
    with Diagnosticable, _$RemixDialogSpecMethods {
  @override
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> title;
  @override
  final StyleSpec<TextSpec> description;
  @override
  final StyleSpec<FlexBoxSpec> actions;
  @override
  final StyleSpec<BoxSpec> overlay;

  const RemixDialogSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? description,
    StyleSpec<FlexBoxSpec>? actions,
    StyleSpec<BoxSpec>? overlay,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       title = title ?? const StyleSpec(spec: TextSpec()),
       description = description ?? const StyleSpec(spec: TextSpec()),
       actions = actions ?? const StyleSpec(spec: FlexBoxSpec()),
       overlay = overlay ?? const StyleSpec(spec: BoxSpec());
}
