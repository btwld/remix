// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Dialog recipe: a raised, blurred panel with a bold title.
///
/// The generated [UiDialog] defaults to [UiDialogSize.size3],
/// [Alignment.center], fills up to 600 logical pixels, preserves safe
/// viewport insets, and is modal.
class UiDialog extends StatelessWidget {
  const UiDialog({
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

  final UiDialogSize size;

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
      style: uiDialogStyle(size: size, align: align, style: style),
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
