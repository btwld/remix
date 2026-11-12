// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Dialog recipe.
///
/// The page's `background` fill with a `border` hairline, `radiusLg` corners,
/// the heaviest shadow in the scale and a 24px inset. The panel is centered
/// with 16px to spare and fills the width up to 512px. The title is `textLg`
/// semibold, the description `textSm` in `mutedForeground` 8px below it, and
/// the actions sit at the trailing edge 16px below that.
class VanillaDialog extends StatelessWidget {
  const VanillaDialog({
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
      style: vanillaDialogStyle(style: this.style),
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
