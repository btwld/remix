// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Dialog recipe: a floating 440px panel. With a close button,
/// the title, description and close button form a header row over a
/// divider, then come the body and actions; without one, they stack in one
/// padded column.
///
/// The generated [FortalDialog] defaults to [FortalDialogSize.size3] and
/// [Alignment.center], keeps 12px from the viewport edges, and is modal. Open
/// it with [showFortalDialog] for the blurred scrim and the panel's spring.
class FortalDialog extends StatelessWidget {
  const FortalDialog({
    super.key,
    this.size = .size3,
    this.align = Alignment.center,
    this.style = const DialogStyler.create(),
    this.child,
    this.title,
    this.description,
    this.actions,
    this.onClose,
    this.closeLabel,
    this.scrollable = false,
    this.modal = true,
    this.semanticLabel,
  });

  final FortalDialogSize size;

  final AlignmentGeometry align;

  final DialogStyler style;

  final Widget? child;

  final String? title;

  final String? description;

  final List<Widget>? actions;

  final VoidCallback? onClose;

  final String? closeLabel;

  final bool scrollable;

  final bool modal;

  final String? semanticLabel;

  @override
  Widget build(BuildContext _) {
    return RemixDialog(
      style: fortalDialogStyle(size: size, align: align, style: style),
      title: title,
      description: description,
      actions: actions,
      onClose: onClose,
      closeLabel: closeLabel,
      scrollable: scrollable,
      modal: modal,
      semanticLabel: semanticLabel,
      child: child,
    );
  }
}
