import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/theme.dart';
import 'link.dart';

/// One step of a trail. Give every step but the last an [onPressed].
@immutable
class HeroUiBreadcrumb {
  const HeroUiBreadcrumb(this.label, {this.onPressed});

  final String label;
  final VoidCallback? onPressed;
}

/// HeroUI's `Breadcrumbs`: [RemixLink]s separated by chevrons. The last step
/// is the current page: coloured as a link and not actionable.
class HeroUiBreadcrumbs extends StatelessWidget {
  const HeroUiBreadcrumbs({
    super.key,
    required this.items,
    this.separator,
    this.linkStyle = const LinkStyler.create(),
  });

  final List<HeroUiBreadcrumb> items;

  /// Replaces the chevron, a 12px glyph in the muted colour.
  final Widget? separator;

  /// Merged last into every step's link style.
  final LinkStyler linkStyle;

  @override
  Widget build(BuildContext context) => Row(
    spacing: _itemGap,
    children: [
      for (final (index, item) in items.indexed)
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: _separatorGap,
          children: [
            RemixLink(
              label: item.label,
              onPressed: item.onPressed,
              enabled: index != items.length - 1,
              style: _linkStyle(
                current: index == items.length - 1,
              ).merge(linkStyle),
            ),
            if (index != items.length - 1)
              SizedBox.square(
                dimension: _separatorSize,
                child: separator ?? const _Chevron(),
              ),
          ],
        ),
    ],
  );
}

/// A step is HeroUI's link with `.breadcrumbs__link` on top: `text-sm
/// leading-5 text-muted` and full opacity when disabled; the current step is
/// `text-link`.
LinkStyler _linkStyle({required bool current}) => heroUiLinkStyle(
  style: LinkStyler()
      .label(
        .style(
          HeroUiTokens.textSm.mix(),
        ).color(current ? HeroUiTokens.link() : HeroUiTokens.muted()),
      )
      .onDisabled(LinkStyler().wrap(.opacity(1))),
);

/// `gap-1.5` between steps, `gap-1` inside one, and `size-3` for the chevron.
const _itemGap = 6.0;
const _separatorGap = 4.0;
const _separatorSize = 12.0;

/// A right-pointing chevron in the muted colour, mirrored in right-to-left
/// text (`rtl:rotate-180`).
class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Transform.flip(
      flipX: Directionality.of(context) == TextDirection.rtl,
      child: StyledIcon(
        icon: RemixIcons.chevronRight,
        style: IconStyler().size(_separatorSize).color(HeroUiTokens.muted()),
      ),
    ),
  );
}
