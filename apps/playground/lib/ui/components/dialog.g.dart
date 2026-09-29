// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Dialog recipe.
///
/// Remix owns the rendering, the modal barrier, focus trapping, the escape
/// and barrier dismissal rules, and the dialog accessibility semantics; this
/// recipe supplies the panel, the two text roles, and the action row.
///
/// It is the page's `background` fill with a `border` hairline, `radiusLg`
/// corners, the heaviest shadow in the scale, a 24px inset, and at most 512px
/// wide. The title is `textLg` semibold and set tight, the description `textSm`
/// in `mutedForeground` 8px below it, and the decisions sit at the trailing
/// edge 16px below that.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it.
class PlaygroundDialog extends StatelessWidget {
  const PlaygroundDialog({
    super.key,
    this.style = const DialogStyler.create(),
    this.child,
    this.title,
    this.description,
    this.actions,
    this.scrollable = false,
    this.modal = true,
    this.semanticLabel,
  });

  final DialogStyler style;

  final Widget? child;

  final String? title;

  final String? description;

  final List<Widget>? actions;

  final bool scrollable;

  final bool modal;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return RemixDialog(
      key: this.key,
      style: playgroundDialogStyle(style: this.style),
      child: this.child,
      title: this.title,
      description: this.description,
      actions: this.actions,
      scrollable: this.scrollable,
      modal: this.modal,
      semanticLabel: this.semanticLabel,
    );
  }
}
