part of 'button.dart';

/// Tells the styles under a [RemixButton] whether it is loading.
final class _RemixButtonLoadingScope extends InheritedWidget {
  const _RemixButtonLoadingScope({required this.loading, required super.child});

  final bool loading;

  @override
  bool updateShouldNotify(_RemixButtonLoadingScope oldWidget) =>
      loading != oldWidget.loading;
}

/// Applies while a [RemixButton] is loading.
///
/// It declares the disabled state as a dependency so Mix ranks it with the
/// widget-state variants: loading disables the button, and a loading style
/// declared after `onDisabled` must be able to override it.
final class _OnLoadingVariant extends ContextVariant {
  _OnLoadingVariant()
    : super(
        'remix_button_loading',
        (context) =>
            context
                .dependOnInheritedWidgetOfExactType<_RemixButtonLoadingScope>()
                ?.loading ??
            false,
      );

  @override
  Set<WidgetState> get widgetStateDependencies => const {WidgetState.disabled};
}

final _onLoadingVariant = _OnLoadingVariant();

extension RemixButtonStylerRemixHelpers on ButtonStyler {
  /// Styles the button while `loading` is true.
  ///
  /// Loading also disables the button, so `onDisabled` styles apply too.
  /// Declare `onLoading` after `onDisabled` to override them, for example to
  /// keep the enabled colors while the spinner shows.
  ButtonStyler onLoading(ButtonStyler value) =>
      variant(_onLoadingVariant, value);
}
