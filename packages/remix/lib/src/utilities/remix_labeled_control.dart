import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../rendering/remix_box_effects.dart';

/// Lays out a binary control with an optional visible label after it, inside a
/// target of at least [minimumTapTargetSize].
///
/// An unlabeled control is centered in the target. A labeled row starts at the
/// leading edge and is centered vertically. The label wraps within a bounded
/// width and takes its natural width otherwise, and the row can be measured by
/// intrinsic-sizing parents such as [IntrinsicWidth] and [IntrinsicHeight].
///
/// Returned from the builder of a Naked behavior widget, the label, the gap,
/// and the target padding take part in the control's pointer, hover, press, and
/// focus handling. The label is excluded from semantics because the behavior
/// widget already names the control.
///
/// A [description] stacks under the label, [descriptionSpacing] below it, and
/// is excluded from semantics too; the caller announces it as a hint. A [row]
/// box draws around the control and its copy, inside the target, so its fill
/// and border follow the control's interaction state.
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
    this.description,
    this.descriptionSpec = const StyleSpec(spec: TextSpec()),
    this.descriptionSpacing = 0,
    this.controlAlignment,
    this.row,
    this.rowEffects,
  });

  final Widget control;
  final String? label;
  final StyleSpec<TextSpec> labelSpec;
  final double labelSpacing;
  final Size minimumTapTargetSize;
  final String? description;
  final StyleSpec<TextSpec> descriptionSpec;
  final double descriptionSpacing;

  /// How the control aligns with its copy. Defaults to centered.
  final CrossAxisAlignment? controlAlignment;
  final StyleSpec<BoxSpec>? row;
  final RemixBoxEffectsSpec? rowEffects;

  @override
  Widget build(BuildContext context) {
    final visibleLabel = label;
    final visibleDescription = description;
    final Widget? copy = switch ((visibleLabel, visibleDescription)) {
      (null, null) => null,
      (final label?, null) => StyledText(label, styleSpec: labelSpec),
      (final label, final description?) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            StyledText(label, styleSpec: labelSpec),
            SizedBox(height: descriptionSpacing),
          ],
          StyledText(description, styleSpec: descriptionSpec),
        ],
      ),
    };
    final Widget layout = copy == null
        ? control
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: controlAlignment ?? CrossAxisAlignment.center,
            children: [
              control,
              SizedBox(width: labelSpacing),
              Flexible(child: ExcludeSemantics(child: copy)),
            ],
          );
    final rowSpec = row;
    final framed = rowSpec == null
        ? layout
        : RemixBoxAdapter(
            styleSpec: rowSpec,
            containerEffects: rowEffects,
            child: layout,
          );
    final content = copy == null && rowSpec == null
        ? Align(widthFactor: 1, heightFactor: 1, child: control)
        : framed;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minimumTapTargetSize.width,
        minHeight: minimumTapTargetSize.height,
      ),
      child: content,
    );
  }
}
