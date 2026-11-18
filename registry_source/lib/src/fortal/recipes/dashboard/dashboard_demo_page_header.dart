import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';

/// The widest a page's content grows, so lines stay readable on a large
/// display.
const fortalPageMaxWidth = 1440.0;

/// The one gutter every dashboard page uses: 24 wide, 16 on a phone.
///
/// It follows the window, not the page's own width, so a page does not
/// rebuild on every frame while the sidebar beside it animates.
EdgeInsets fortalPagePadding(BuildContext context) =>
    EdgeInsets.all(MediaQuery.sizeOf(context).width < 600 ? 16 : 24);

/// A dashboard page: a title block above a column of sections, scrolling
/// together inside [fortalPagePadding].
class FortalPage extends StatelessWidget {
  const FortalPage({
    super.key,
    required this.title,
    required this.description,
    this.actions = const [],
    this.maxWidth = fortalPageMaxWidth,
    this.scrollController,
    required this.children,
  });

  /// The page title, published as the page's level-one heading.
  final String title;

  /// A line of supporting copy under the title.
  final String description;

  /// Controls beside the title. They wrap under it when space runs out.
  final List<Widget> actions;

  /// The widest the content grows.
  final double maxWidth;

  /// Controls the page's scroll position.
  final ScrollController? scrollController;

  /// The page's sections, top to bottom.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: scrollController,
    padding: fortalPagePadding(context),
    child: Box(
      style: BoxStyler().alignment(.topStart),
      child: ColumnBox(
        style: FlexBoxStyler()
            .maxWidth(maxWidth)
            .crossAxisAlignment(.stretch)
            .spacing(FortalTokens.space5()),
        children: [
          FortalPageHeader(
            title: title,
            description: description,
            actions: actions,
          ),
          ...children,
        ],
      ),
    ),
  );
}

/// The title, description and actions at the top of a page.
class FortalPageHeader extends StatelessWidget {
  const FortalPageHeader({
    super.key,
    required this.title,
    required this.description,
    this.actions = const [],
  });

  /// The page title, published as the page's level-one heading.
  final String title;

  /// A line of supporting copy under the title.
  final String description;

  /// Controls beside the title. They wrap under it when space runs out.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => WrapBox(
    style: WrapBoxStyler()
        .wrapAlignment(.spaceBetween)
        .crossAxisAlignment(.end)
        .spacing(FortalTokens.space4())
        .runSpacing(FortalTokens.space3()),
    children: [
      ColumnBox(
        style: FlexBoxStyler()
            .mainAxisSize(.min)
            .crossAxisAlignment(.start)
            .spacing(FortalTokens.space1()),
        children: [
          FortalHeading(title, size: .size6, weight: .bold),
          StyledText(description, style: dashboardText(.size2, tone: .muted)),
        ],
      ),
      if (actions.isNotEmpty)
        WrapBox(
          style: WrapBoxStyler()
              .crossAxisAlignment(.center)
              .spacing(FortalTokens.space2())
              .runSpacing(FortalTokens.space2()),
          children: actions,
        ),
    ],
  );
}
