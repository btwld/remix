import 'package:mix/mix.dart';

/// Adds the selected widget-state variant to generated Remix stylers.
extension SelectedWidgetStateVariantExtension<
  T extends Style<S>,
  S extends Spec<S>
>
    on MixStyler<T, S> {
  /// Applies [style] while the widget is selected.
  T onSelected(T style) {
    return variant(ContextVariant.widgetState(.selected), style);
  }
}
