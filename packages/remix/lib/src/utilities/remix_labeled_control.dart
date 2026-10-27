import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Lays out a binary control with an optional visible label after it, centered
/// in a target of at least [minimumTapTargetSize].
///
/// Returned from the builder of a Naked behavior widget, the label, the gap,
/// and the target padding take part in the control's pointer, hover, press, and
/// focus handling. The label is excluded from semantics because the behavior
/// widget already names the control.
///
/// Start and end follow the ambient [Directionality].
@internal
final class RemixLabeledControl extends StatelessWidget {
  const RemixLabeledControl({
    super.key,
    required this.control,
    required this.label,
    required this.labelSpec,
    required this.labelSpacing,
    required this.minimumTapTargetSize,
  });

  final Widget control;
  final String? label;
  final StyleSpec<TextSpec> labelSpec;
  final double labelSpacing;
  final Size minimumTapTargetSize;

  @override
  Widget build(BuildContext context) {
    final visibleLabel = label;
    final content = visibleLabel == null
        ? Align(widthFactor: 1, heightFactor: 1, child: control)
        : LayoutBuilder(
            builder: (context, constraints) {
              final labelWidget = ExcludeSemantics(
                child: StyledText(visibleLabel, styleSpec: labelSpec),
              );

              return Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  control,
                  SizedBox(width: labelSpacing),
                  if (constraints.hasBoundedWidth)
                    Flexible(child: labelWidget)
                  else
                    labelWidget,
                ],
              );
            },
          );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minimumTapTargetSize.width,
        minHeight: minimumTapTargetSize.height,
      ),
      child: content,
    );
  }
}
