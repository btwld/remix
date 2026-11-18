import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/tokens.dart';
import 'link.dart';

/// One step of a [VanillaBreadcrumbs] trail.
///
/// A step with [onPressed] is a link back to that page; one without is plain
/// muted text, for a level that has no page of its own. The last step is the
/// current page and is never a link, so its [onPressed] is not used.
@immutable
class VanillaBreadcrumbItem {
  const VanillaBreadcrumbItem(this.label, {this.onPressed, this.semanticLabel});

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
/// A composition of [VanillaLink]s rather than a recipe, because Remix has no
/// breadcrumb widget. The trail is `textSm` in `mutedForeground`; a link
/// turns `foreground` under the pointer and rings on keyboard focus, and the
/// current page is `foreground` at regular weight. A 14px chevron sits 10px
/// from the steps on either side, mirrored in right-to-left text. The trail
/// stays on one line, and a step ellipsizes when the row runs out of room.
///
/// ```dart
/// VanillaBreadcrumbs(
///   items: [
///     VanillaBreadcrumbItem('Home', onPressed: openHome),
///     VanillaBreadcrumbItem('Components', onPressed: openComponents),
///     const VanillaBreadcrumbItem('Breadcrumb'),
///   ],
/// )
/// ```
class VanillaBreadcrumbs extends StatelessWidget {
  const VanillaBreadcrumbs({
    super.key,
    required this.items,
    this.semanticLabel = 'Breadcrumb',
  }) : assert(items.length > 0, 'A trail needs at least the current page.');

  /// The steps from the top level down; the last is the current page.
  final List<VanillaBreadcrumbItem> items;

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
            .spacing(VanillaTokens.s2_5),
        children: [
          for (final (index, item) in items.indexed) ...[
            if (index > 0) const _VanillaBreadcrumbSeparator(),
            Flexible(
              child: index == current || item.onPressed == null
                  ? _step(item, current: index == current)
                  : VanillaLink(
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
  Widget _step(VanillaBreadcrumbItem item, {required bool current}) {
    final text = StyledText(
      item.label,
      style: _oneLine(
        TextStyler()
            .style(VanillaTokens.textSm.mix())
            .fontWeight(FontWeight.w400)
            .color(
              current
                  ? VanillaTokens.foreground()
                  : VanillaTokens.mutedForeground(),
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
            .color(VanillaTokens.mutedForeground()),
      ),
    )
    .onHovered(
      .label(
        .color(VanillaTokens.foreground()).decoration(TextDecoration.none),
      ),
    );

/// [text] on a single line that ellipsizes when the trail runs out of room.
TextStyler _oneLine(TextStyler text) =>
    text.maxLines(1).softWrap(false).overflow(.ellipsis);

/// The chevron between two steps, mirrored in right-to-left text.
class _VanillaBreadcrumbSeparator extends StatelessWidget {
  const _VanillaBreadcrumbSeparator();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Transform.flip(
      flipX: Directionality.of(context) == TextDirection.rtl,
      child: StyledIcon(
        icon: RemixIcons.chevronRight,
        style: IconStyler()
            .size(VanillaTokens.iconSm)
            .color(VanillaTokens.mutedForeground()),
      ),
    ),
  );
}
