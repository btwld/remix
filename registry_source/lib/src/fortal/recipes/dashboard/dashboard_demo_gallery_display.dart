import 'package:flutter/widgets.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:remix/remix.dart';
import 'dashboard_demo_ui.dart';

import 'dashboard_demo_text.dart';
import 'dashboard_demo_gallery_scaffold.dart';

class FortalGalleryDisplayPage extends StatefulWidget {
  const FortalGalleryDisplayPage({super.key});

  @override
  State<FortalGalleryDisplayPage> createState() =>
      _FortalGalleryDisplayPageState();
}

class _FortalGalleryDisplayPageState extends State<FortalGalleryDisplayPage> {
  bool _spinnersRunning = false;
  bool _skeletonLoading = true;

  @override
  Widget build(BuildContext context) {
    return FortalGalleryPage(
      title: 'Data Display',
      intro: 'Rich surfaces and status components for product interfaces.',
      sections: [
        FortalGallerySection(
          label: 'Avatar',
          description:
              'Two visual variants across all nine Radix-compatible sizes.',
          child: FortalGalleryEnumMatrix(
            rows: FortalAvatarVariant.values,
            columns: FortalAvatarSize.values,
            // Size9 is 160px; preserve its 20px cell padding and divider.
            cellWidth: 181,
            cellBuilder: (_, variant, size) =>
                FortalAvatar(variant: variant, size: size, label: 'RF'),
          ),
        ),
        FortalGallerySection(
          label: 'Badge',
          description:
              'Status labels in solid, soft, surface, and outline variants.',
          child: FortalGalleryEnumMatrix(
            rows: FortalBadgeVariant.values,
            columns: FortalBadgeSize.values,
            cellBuilder: (_, variant, size) =>
                FortalBadge(variant: variant, size: size, label: 'Active'),
          ),
        ),
        FortalGallerySection(
          label: 'Card',
          description:
              'Surface, classic, and ghost containers across five spacing sizes.',
          child: FortalGalleryEnumMatrix(
            rows: FortalCardVariant.values,
            columns: FortalCardSize.values,
            cellWidth: 200,
            cellBuilder: (_, variant, size) => Box(
              style: BoxStyler().width(160),
              child: FortalCard(
                variant: variant,
                size: size,
                child: const FortalText('Card content', size: .size2),
              ),
            ),
          ),
        ),
        FortalGallerySection(
          label: 'Callout',
          description: 'Contextual information in every variant and size.',
          child: FortalGalleryEnumMatrix(
            rows: FortalCalloutVariant.values,
            columns: FortalCalloutSize.values,
            cellWidth: 230,
            cellBuilder: (_, variant, size) => Box(
              style: BoxStyler().width(200),
              child: FortalCallout(
                variant: variant,
                size: size,
                text: 'A helpful callout message.',
              ),
            ),
          ),
        ),
        FortalGallerySection(
          label: 'Data list',
          description:
              'Label and value pairs at every size, horizontal and vertical.',
          child: FortalGalleryEnumMatrix(
            rows: Axis.values,
            columns: FortalDataListSize.values,
            cellWidth: 250,
            cellBuilder: (_, orientation, size) => FortalDataList(
              size: size,
              orientation: orientation,
              items: const [
                RemixDataListItem(
                  label: 'Status',
                  child: FortalBadge(highContrast: true, label: 'Active'),
                ),
                RemixDataListItem(label: 'Plan', value: 'Enterprise'),
                RemixDataListItem(label: 'Seats', value: '48'),
              ],
            ),
          ),
        ),
        FortalGallerySection(
          label: 'Skeleton',
          description:
              'Placeholder shapes that keep the loaded layout measurements.',
          child: ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.start).spacing(14),
            children: [
              FortalButton.soft(
                size: .size1,
                onPressed: () =>
                    setState(() => _skeletonLoading = !_skeletonLoading),
                label: _skeletonLoading ? 'Show content' : 'Show skeleton',
              ),
              FortalSkeleton(
                loading: _skeletonLoading,
                child: const FortalAvatar(label: 'RF', size: .size5),
              ),
              FortalSkeleton(
                loading: _skeletonLoading,
                child: const FortalText(
                  'Loaded content replaces the placeholder.',
                  size: .size2,
                ),
              ),
            ],
          ),
        ),
        FortalGallerySection(
          label: 'Progress',
          description:
              'Determinate progress with classic, surface, and soft treatments.',
          child: FortalGalleryEnumMatrix(
            rows: FortalProgressVariant.values,
            columns: FortalProgressSize.values,
            cellWidth: 210,
            cellBuilder: (_, variant, size) => Box(
              style: BoxStyler().width(170),
              child: FortalProgress(
                variant: variant,
                size: size,
                value: 0.68,
                semanticsLabel: '68 percent complete',
              ),
            ),
          ),
        ),
        FortalGallerySection(
          label: 'Spinner',
          description:
              'Animation is stopped by default so automated tests remain settleable.',
          child: RowBox(
            style: FlexBoxStyler().crossAxisAlignment(.center).spacing(18),
            children: [
              FortalButton.soft(
                size: .size1,
                onPressed: () =>
                    setState(() => _spinnersRunning = !_spinnersRunning),
                label: _spinnersRunning ? 'Stop' : 'Start',
              ),
              for (final size in FortalSpinnerSize.values)
                if (_spinnersRunning)
                  FortalSpinner(size: size, semanticsLabel: 'Loading example')
                else
                  StyledIcon(
                    icon: RemixIcons.check,
                    style: IconStyler().size(16).color(FortalTokens.gray11()),
                  ),
            ],
          ),
        ),
        FortalGallerySection(
          label: 'Divider',
          description: 'Horizontal dividers at all four inset sizes.',
          child: ColumnBox(
            style: FlexBoxStyler().spacing(14),
            children: [
              for (final size in FortalDividerSize.values)
                RowBox(
                  style: FlexBoxStyler()
                      .crossAxisAlignment(.center)
                      .spacing(12),
                  children: [
                    Box(
                      style: BoxStyler().width(64),
                      child: FortalText(enumLabel(size), size: .size2),
                    ),
                    Expanded(child: FortalDivider(size: size)),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
