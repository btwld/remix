import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/tokens.dart';
import 'link.dart';

/// One step of a [PlaygroundBreadcrumbs] trail.
///
/// A step with [onPressed] is a link back to that page; one without is plain
/// muted text, for a level that has no page of its own. The last step is the
/// current page and is never a link, so its [onPressed] is not used.
@immutable
class PlaygroundBreadcrumbItem {
  const PlaygroundBreadcrumbItem(
    this.label, {
    this.onPressed,
    this.semanticLabel,
  });

  /// The visible text.
  final String label;

  /// Navigates to this step's page.
  final VoidCallback? onPressed;

  /// Replaces [label] for assistive technology.
  final String? semanticLabel;
}

/// The application's Breadcrumbs: the pages above the current one, then the
/// current page.
///
/// A composition of [PlaygroundLink]s rather than a recipe, because Remix has no
/// breadcrumb widget. The trail is `textSm` in `mutedForeground`; a link
/// turns `foreground` under the pointer and rings on keyboard focus, and the
/// current page is `foreground` at regular weight. A 14px chevron sits 10px
/// from the steps on either side, mirrored in right-to-left text. The trail
/// stays on one line, and a step ellipsizes when the row runs out of room.
///
/// ```dart
/// PlaygroundBreadcrumbs(
///   items: [
///     PlaygroundBreadcrumbItem('Home', onPressed: openHome),
///     PlaygroundBreadcrumbItem('Components', onPressed: openComponents),
///     const PlaygroundBreadcrumbItem('Breadcrumb'),
///   ],
/// )
/// ```
class PlaygroundBreadcrumbs extends StatelessWidget {
  const PlaygroundBreadcrumbs({
    super.key,
    required this.items,
    this.semanticLabel = 'Breadcrumb',
  }) : assert(items.length > 0, 'A trail needs at least the current page.');

  /// The steps from the top level down; the last is the current page.
  final List<PlaygroundBreadcrumbItem> items;

  /// Names the trail's navigation landmark for assistive technology.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final current = items.length - 1;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      role: .navigation,
      label: semanticLabel,
      child: RowBox(
        style: FlexBoxStyler()
            .mainAxisSize(.min)
            .crossAxisAlignment(.center)
            .spacing(PlaygroundTokens.s2_5),
        children: [
          for (final (index, item) in items.indexed) ...[
            if (index > 0) const _PlaygroundBreadcrumbSeparator(),
            Flexible(
              child: index == current || item.onPressed == null
                  ? _step(item, current: index == current)
                  : PlaygroundLink(
                      label: item.label,
                      semanticLabel: item.semanticLabel,
                      onPressed: item.onPressed,
                      style: _linkStyle(),
                    ),
            ),
          ],
        ],
      ),
    );
  }

  /// A step that is not a link: the current page in `foreground`, or a level
  /// with no page in the trail's muted color.
  Widget _step(PlaygroundBreadcrumbItem item, {required bool current}) {
    final text = StyledText(
      item.label,
      style: _oneLine(
        TextStyler()
            .style(PlaygroundTokens.textSm.mix())
            .fontWeight(FontWeight.w400)
            .color(
              current
                  ? PlaygroundTokens.foreground()
                  : PlaygroundTokens.mutedForeground(),
            ),
      ),
    );
    final semanticLabel = item.semanticLabel;

    return semanticLabel == null
        ? text
        : Semantics(label: semanticLabel, excludeSemantics: true, child: text);
  }
}

/// The trail's colors over the Link recipe: regular weight in
/// `mutedForeground`, turning `foreground` under the pointer instead of
/// underlining, on one line. The recipe's focus ring and motion stay.
LinkStyler _linkStyle() => LinkStyler()
    .label(
      _oneLine(
        TextStyler()
            .fontWeight(FontWeight.w400)
            .color(PlaygroundTokens.mutedForeground()),
      ),
    )
    .onHovered(
      .label(
        .color(PlaygroundTokens.foreground()).decoration(TextDecoration.none),
      ),
    );

/// [text] on a single line that ellipsizes when the trail runs out of room.
TextStyler _oneLine(TextStyler text) =>
    text.maxLines(1).softWrap(false).overflow(.ellipsis);

/// The chevron between two steps, mirrored in right-to-left text.
class _PlaygroundBreadcrumbSeparator extends StatelessWidget {
  const _PlaygroundBreadcrumbSeparator();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Transform.flip(
      flipX: Directionality.of(context) == TextDirection.rtl,
      child: StyledIcon(
        icon: RemixIcons.chevronRight,
        style: IconStyler()
            .size(PlaygroundTokens.iconSm)
            .color(PlaygroundTokens.mutedForeground()),
      ),
    ),
  );
}
