import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';

/// The title, description, and optional actions at the top of a page.
///
/// Titles are [UiHeading] so the page publishes a real heading tree: the
/// page title is level 1 and every card or section title below it is level 2.
/// The visual size is chosen independently of that level, exactly as Radix
/// separates `as` from `size`.
class UiPageHeader extends StatelessWidget {
  const UiPageHeader({
    super.key,
    required this.title,
    required this.description,
    this.actions,
  });

  final String title;
  final String description;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return RowBox(
      style: FlexBoxStyler().crossAxisAlignment(.start),
      children: [
        Expanded(
          child: ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
            children: [
              UiHeading(title, size: .size6, weight: .bold),
              StyledText(
                description,
                style: dashboardText(.size2, tone: .muted),
              ),
            ],
          ),
        ),
        ?actions,
      ],
    );
  }
}

/// The title of a section inside a card.
class UiSectionLabel extends StatelessWidget {
  const UiSectionLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) =>
      UiHeading(label, headingLevel: 2, size: .size4, weight: .medium);
}

/// A [UiSectionLabel] with supporting copy beneath it.
class UiCardHeading extends StatelessWidget {
  const UiCardHeading({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.start).spacing(3),
    children: [
      UiSectionLabel(title),
      StyledText(description, style: dashboardText(.size2, tone: .muted)),
    ],
  );
}
