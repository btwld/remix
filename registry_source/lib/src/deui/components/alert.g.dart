// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Deui recipe for [RemixCallout]: an icon and a title on a surface.
///
/// [RemixCallout] holds one text or one custom child; a title with a
/// description is the app's composition inside `child`.
class DeuiAlert extends StatelessWidget {
  const DeuiAlert({
    super.key,
    this.status = .defaultStatus,
    this.style = const CalloutStyler.create(),
    this.text,
    this.icon,
    this.child,
  });

  final DeuiAlertStatus status;

  final CalloutStyler style;

  final String? text;

  final IconData? icon;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RemixCallout(
      key: this.key,
      style: deuiAlertStyle(status: this.status, style: this.style),
      text: this.text,
      icon: this.icon,
      child: this.child,
    );
  }
}
