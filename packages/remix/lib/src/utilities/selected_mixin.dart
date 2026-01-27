import 'package:mix/mix.dart';

import 'remix_style.dart';

mixin SelectedWidgetStateVariantMixin<
  S extends Spec<S>,
  T extends RemixStyle<S, T>
>
    on RemixStyle<S, T> {
  T onSelected(T style) {
    return variant(ContextVariant.widgetState(.selected), style);
  }
}
