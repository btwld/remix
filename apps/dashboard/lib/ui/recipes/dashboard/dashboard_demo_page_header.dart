import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';

/// The one gutter every dashboard page uses: 24 wide, 16 under 600 wide.
///
/// Pass the page's available width, or [double.infinity] for the wide value.
EdgeInsets uiPagePadding(double width) => EdgeInsets.all(width < 600 ? 16 : 24);

/// A vertically scrolling page body inset by [uiPagePadding].
class UiPageScroll extends StatelessWidget {
  const UiPageScroll({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      padding: uiPagePadding(constraints.maxWidth),
      child: child,
    ),
  );
}

/// The title, description, and optional actions at the top of a page.
///
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
