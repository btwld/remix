// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixCallout]: an icon and a title on a surface.
///
/// [RemixCallout] holds one text or one custom child; a title with a
/// description is the app's composition inside `child`.
class HeroUiAlert extends StatelessWidget {
  const HeroUiAlert({
    super.key,
    this.status = .defaultStatus,
    this.style = const CalloutStyler.create(),
    this.text,
    this.icon,
    this.child,
  });

  final HeroUiAlertStatus status;

  final CalloutStyler style;

  final String? text;

  final IconData? icon;

  final Widget? child;

  @override
  Widget build(BuildContext _) {
    return RemixCallout(
      style: heroUiAlertStyle(status: status, style: style),
      text: text,
      icon: icon,
      child: child,
    );
  }
}
