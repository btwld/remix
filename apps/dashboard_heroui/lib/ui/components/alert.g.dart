// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixCallout]: an icon and a title on a surface.
///
/// [RemixCallout] holds one text or one custom child; a title with a
/// description is the app's composition inside `child`.
class UiAlert extends StatelessWidget {
  const UiAlert({
    super.key,
    this.status = .defaultStatus,
    this.style = const CalloutStyler.create(),
    this.text,
    this.icon,
    this.child,
  });

  final UiAlertStatus status;

  final CalloutStyler style;

  final String? text;

  final IconData? icon;

  final Widget? child;

  @override
  Widget build(BuildContext _) {
    return RemixCallout(
      style: uiAlertStyle(status: status, style: style),
      text: text,
      icon: icon,
      child: child,
    );
  }
}
