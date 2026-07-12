import 'package:mix/mix.dart';

import 'remix_style.dart';

mixin SelectedWidgetStateVariantMixin<
  S extends Spec<S>,
  T extends RemixStyler<S, T>
>
    on RemixStyler<S, T> {
  T onSelected(T style) {
    return variant(ContextVariant.widgetState(.selected), style);
  }
}
