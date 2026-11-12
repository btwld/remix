import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'dashboard_demo_ui.dart';

import 'dashboard_demo_typography.dart';

/// The one gutter every dashboard page uses: 24 wide, 16 under 600 wide.
///
/// Pass the page's available width, or [double.infinity] for the wide value.
EdgeInsets fortalPagePadding(double width) =>
    EdgeInsets.all(width < 600 ? 16 : 24);

/// A vertically scrolling page body inset by [fortalPagePadding].
class FortalPageScroll extends StatelessWidget {
  const FortalPageScroll({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      padding: fortalPagePadding(constraints.maxWidth),
      child: child,
    ),
  );
}

/// The title, description, and optional actions at the top of a page.
///
class FortalPageHeader extends StatelessWidget {
  const FortalPageHeader({
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
              FortalHeading(title, size: .size6, weight: .bold),
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
class FortalSectionLabel extends StatelessWidget {
  const FortalSectionLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) =>
      FortalHeading(label, headingLevel: 2, size: .size4, weight: .medium);
}

/// A [FortalSectionLabel] with supporting copy beneath it.
class FortalCardHeading extends StatelessWidget {
  const FortalCardHeading({
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
      FortalSectionLabel(title),
      StyledText(description, style: dashboardText(.size2, tone: .muted)),
    ],
  );
}
