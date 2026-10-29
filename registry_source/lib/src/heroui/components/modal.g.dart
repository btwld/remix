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

  final bool scrollable;

  final bool modal;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return RemixDialog(
      key: this.key,
      style: heroUiModalStyle(
        size: this.size,
        placement: this.placement,
        style: this.style,
      ),
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
