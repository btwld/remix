// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modal.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixDialog], the modal surface.
///
/// Open it with `showRemixDialog`, or `showRemixAlertDialog` for an alert; pass
/// `HeroUiTokens.backdrop` (resolved in the caller's context) as `barrierColor`
/// for HeroUI's backdrop.
class HeroUiModal extends StatelessWidget {
  const HeroUiModal({
    super.key,
    this.size = .md,
    this.placement = .auto,
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

  final HeroUiModalSize size;

  final HeroUiModalPlacement placement;

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
      style: heroUiModalStyle(size: size, placement: placement, style: style),
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
