import 'package:flutter/widgets.dart';
import 'package:naked_ui/naked_ui.dart';

/// A plain outlined button for the example apps.
///
/// The examples host on [WidgetsApp] rather than `MaterialApp`, so Material's
/// `OutlinedButton` and `TextButton` are unavailable. This is deliberately the
/// smallest thing that fills their role: `NakedButton` supplies the behavior
/// and semantics, and the surface below is presentation only.
class ExampleButton extends StatelessWidget {
  const ExampleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.focusNode,
    this.subtle = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;

  /// Renders without a border, the role Material's `TextButton` played.
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF3D3D3D);
    const disabled = Color(0xFF9E9E9E);
    final enabled = onPressed != null;

    return NakedButton(
      onPressed: onPressed,
      focusNode: focusNode,
      builder: (context, state, child) {
        final foreground = enabled ? accent : disabled;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: state.isPressed
                ? const Color(0x143D3D3D)
                : state.isHovered
                ? const Color(0x0A3D3D3D)
                : const Color(0x00000000),
            border: subtle
                ? null
                : Border.all(
                    color: enabled
                        ? const Color(0xFFBDBDBD)
                        : const Color(0xFFE0E0E0),
                  ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: foreground,
              ),
            ),
          ),
        );
      },
    );
  }
}
