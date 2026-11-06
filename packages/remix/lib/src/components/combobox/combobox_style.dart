part of 'combobox.dart';

// Project only the requested slots after merging active root variants. Root
// animation and modifiers belong to the editor root, never to every option.
enum _ComboboxSlot { field, panel, option }

final class _ComboboxProjection extends ComboboxStyler {
  _ComboboxProjection(this.source, this.slot, {this.fieldFallback})
    : super.create(variants: source.$variants);

  final ComboboxStyler source;
  final _ComboboxSlot slot;
  final Style<TextFieldSpec>? fieldFallback;

  @override
  ComboboxStyler merge(ComboboxStyler? other) => _ComboboxProjection(
    source.merge(other),
    slot,
    fieldFallback: fieldFallback,
  );

  @override
  StyleSpec<ComboboxSpec> resolve(BuildContext context) => StyleSpec(
    spec: switch (slot) {
      .field => ComboboxSpec(
        field: MixOps.resolve(
          context,
          MixOps.merge(Prop.maybeMix(fieldFallback), source.$field),
        ),
      ),
      .panel => ComboboxSpec(panel: MixOps.resolve(context, source.$panel)),
      .option => ComboboxSpec(
        option: MixOps.resolve(context, source.$option),
        optionLabel: MixOps.resolve(context, source.$optionLabel),
      ),
    },
  );

  @override
  List<Object?> get props => [source, slot, fieldFallback];
}

// Inherit ahead of TextField's base-style merge so a generated TextFieldStyler
// cannot flatten this projection. TextField's existing controller supplies all
// editor states; only the field slot's metadata is returned by the projection.
final class _ComboboxFieldStyle extends Style<TextFieldSpec> {
  _ComboboxFieldStyle(this.source, this.fallback)
    : super(variants: null, modifier: null, animation: null);

  final ComboboxStyler source;
  final Style<TextFieldSpec>? fallback;

  @override
  Style<TextFieldSpec> merge(covariant Style<TextFieldSpec>? other) =>
      _ComboboxFieldStyle(source, fallback?.merge(other) ?? other);

  @override
  StyleSpec<TextFieldSpec> resolve(BuildContext context) => _ComboboxProjection(
    source,
    .field,
    fieldFallback: fallback,
  ).build(context).spec.field;

  @override
  List<Object?> get props => [source, fallback];
}
