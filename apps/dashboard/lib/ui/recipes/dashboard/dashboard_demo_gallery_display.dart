import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_gallery_scaffold.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_ui.dart';

class UiGalleryDisplayPage extends StatefulWidget {
  const UiGalleryDisplayPage({super.key});

  @override
  State<UiGalleryDisplayPage> createState() => _UiGalleryDisplayPageState();
}

class _UiGalleryDisplayPageState extends State<UiGalleryDisplayPage> {
  bool _spinnersRunning = false;
  bool _skeletonLoading = false;

  @override
  Widget build(BuildContext context) {
    return UiGalleryPage(
      title: 'Data Display',
      intro: 'Rich surfaces and status components for product interfaces.',
      sections: [
        UiGallerySection(
          label: 'Avatar',
          description:
              'Two visual variants across all nine Radix-compatible sizes.',
          child: UiGalleryEnumMatrix(
            rows: UiAvatarVariant.values,
            columns: UiAvatarSize.values,
            // Size9 is 160px; preserve its 20px cell padding and divider.
            cellWidth: 181,
            cellBuilder: (_, variant, size) =>
                UiAvatar(variant: variant, size: size, label: 'RF'),
          ),
        ),
        UiGallerySection(
          label: 'Badge',
          description:
              'Status labels in solid, soft, surface, and outline variants.',
          child: UiGalleryEnumMatrix(
            rows: UiBadgeVariant.values,
            columns: UiBadgeSize.values,
            cellBuilder: (_, variant, size) =>
                UiBadge(variant: variant, size: size, label: 'Active'),
          ),
        ),
        UiGallerySection(
          label: 'Card',
          description:
              'Surface, classic, and ghost containers across five spacing sizes.',
          child: UiGalleryEnumMatrix(
            rows: UiCardVariant.values,
            columns: UiCardSize.values,
            cellWidth: 200,
            cellBuilder: (_, variant, size) => Box(
              style: BoxStyler().width(160),
              child: UiCard(
                variant: variant,
                size: size,
                child: const UiText('Card content', size: .size2),
              ),
            ),
          ),
        ),
        UiGallerySection(
          label: 'Callout',
          description: 'Contextual information in every variant and size.',
          child: UiGalleryEnumMatrix(
            rows: UiCalloutVariant.values,
            columns: UiCalloutSize.values,
            cellWidth: 230,
            cellBuilder: (_, variant, size) => Box(
              style: BoxStyler().width(200),
              child: UiCallout(
                variant: variant,
                size: size,
                text: 'A helpful callout message.',
              ),
            ),
          ),
        ),
        UiGallerySection(
          label: 'Data list',
          description:
              'Label and value pairs at every size, horizontal and vertical.',
          child: UiGalleryEnumMatrix(
            rows: Axis.values,
            columns: UiDataListSize.values,
            cellWidth: 250,
            cellBuilder: (_, orientation, size) => UiDataList(
              size: size,
              orientation: orientation,
              items: const [
                RemixDataListItem(
                  label: 'Status',
                  child: UiBadge(highContrast: true, label: 'Active'),
                ),
                RemixDataListItem(label: 'Plan', value: 'Enterprise'),
                RemixDataListItem(label: 'Seats', value: '48'),
              ],
            ),
          ),
        ),
        UiGallerySection(
          label: 'Skeleton',
          description:
              'Placeholder shapes that keep the loaded layout measurements.',
          child: ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.start).spacing(14),
            children: [
              UiButton.soft(
                size: .size1,
                onPressed: () =>
                    setState(() => _skeletonLoading = !_skeletonLoading),
                label: _skeletonLoading ? 'Show content' : 'Show skeleton',
              ),
              UiSkeleton(
                loading: _skeletonLoading,
                child: const UiAvatar(label: 'RF', size: .size5),
              ),
              UiSkeleton(
                loading: _skeletonLoading,
                child: const UiText(
                  'Loaded content replaces the placeholder.',
                  size: .size2,
                ),
              ),
            ],
          ),
        ),
        UiGallerySection(
          label: 'Progress',
          description:
              'Determinate progress with classic, surface, and soft treatments.',
          child: UiGalleryEnumMatrix(
            rows: UiProgressVariant.values,
            columns: UiProgressSize.values,
            cellWidth: 210,
            cellBuilder: (_, variant, size) => Box(
              style: BoxStyler().width(170),
              child: UiProgress(
                variant: variant,
                size: size,
                value: 0.68,
                semanticsLabel: '68 percent complete',
              ),
            ),
          ),
        ),
        UiGallerySection(
          label: 'Spinner',
          description:
              'Animation is stopped by default so automated tests remain settleable.',
          child: RowBox(
            style: FlexBoxStyler().crossAxisAlignment(.center).spacing(18),
            children: [
              UiButton.soft(
                size: .size1,
                onPressed: () =>
                    setState(() => _spinnersRunning = !_spinnersRunning),
                label: _spinnersRunning ? 'Stop' : 'Start',
              ),
              for (final size in UiSpinnerSize.values)
                if (_spinnersRunning)
                  UiSpinner(size: size, semanticsLabel: 'Loading example')
                else
                  const Icon(RemixIcons.check, size: 16),
            ],
          ),
        ),
        UiGallerySection(
          label: 'Divider',
          description: 'Horizontal dividers at all four inset sizes.',
          child: ColumnBox(
            style: FlexBoxStyler().spacing(14),
            children: [
              for (final size in UiDividerSize.values)
                RowBox(
                  style: FlexBoxStyler()
                      .crossAxisAlignment(.center)
                      .spacing(12),
                  children: [
                    Box(
                      style: BoxStyler().width(64),
                      child: UiText(enumLabel(size), size: .size2),
                    ),
                    Expanded(child: UiDivider(size: size)),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
