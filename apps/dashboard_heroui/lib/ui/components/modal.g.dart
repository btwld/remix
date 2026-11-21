// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modal.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixDialog], the modal surface.
///
/// Open it with `showRemixDialog`, or `showRemixAlertDialog` for an alert; pass
/// `UiTokens.backdrop` (resolved in the caller's context) as `barrierColor`
/// for HeroUI's backdrop.
class UiModal extends StatelessWidget {
  const UiModal({
    super.key,
    this.size = .md,
    this.placement = .auto,
    this.style = const DialogStyler.create(),
    this.child,
    this.title,
    this.description,
    this.actions,
    this.scrollable = false,
    this.modal = true,
    this.semanticLabel,
  });

  final UiModalSize size;

  final UiModalPlacement placement;

  final DialogStyler style;

  final Widget? child;

  final String? title;

  final String? description;

  final List<Widget>? actions;

  final bool scrollable;

  final bool modal;

  final String? semanticLabel;

  @override
  Widget build(BuildContext _) {
    return RemixDialog(
      style: uiModalStyle(size: size, placement: placement, style: style),
      title: title,
      description: description,
      actions: actions,
      scrollable: scrollable,
      modal: modal,
      semanticLabel: semanticLabel,
      child: child,
    );
  }
}
