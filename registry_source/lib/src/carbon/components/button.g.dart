// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// A Carbon Button recipe and generated [RemixButton] wrapper.
///
/// When [size] is null, height comes from [CarbideLayoutScope], falling back to
/// Carbon's large 48px default and clamping to the supported small–2xl range.
/// Loading is non-interactive but retains the selected kind's treatment rather
/// than taking the ordinary disabled colors.
class CarbideButton extends StatelessWidget {
  const CarbideButton({
    super.key,
    this.kind = .primary,
    this.size,
    this.loading = false,
    required this.label,
    this.trailingIcon,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  final CarbideButtonKind kind;

  final CarbideSize? size;

  final bool loading;

  final String label;

  final IconData? trailingIcon;

  final bool enabled;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool enableFeedback;

  final String? semanticLabel;

  final String? semanticHint;

  final bool excludeSemantics;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return RemixButton(
      key: this.key,
      style: carbideButtonStyle(
        kind: this.kind,
        size: this.size,
        loading: this.loading,
      ),
      label: this.label,
      trailingIcon: this.trailingIcon,
      loading: this.loading,
      enabled: this.enabled,
      onPressed: this.onPressed,
      onLongPress: this.onLongPress,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      enableFeedback: this.enableFeedback,
      semanticLabel: this.semanticLabel,
      semanticHint: this.semanticHint,
      excludeSemantics: this.excludeSemantics,
      mouseCursor: this.mouseCursor,
    );
  }
}
