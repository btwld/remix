import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/avatar.dart';
import '../../components/badge.dart';
import '../../components/button.dart';
import '../../components/callout.dart';
import '../../components/card.dart';
import '../../components/data_list.dart';
import '../../components/divider.dart';
import '../../components/progress.dart';
import '../../components/skeleton.dart';
import '../../components/spinner.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_gallery_scaffold.dart';

class PlaygroundGalleryDisplayPage extends StatefulWidget {
  const PlaygroundGalleryDisplayPage({super.key});

  @override
  State<PlaygroundGalleryDisplayPage> createState() =>
      _PlaygroundGalleryDisplayPageState();
}

class _PlaygroundGalleryDisplayPageState
    extends State<PlaygroundGalleryDisplayPage> {
  bool _spinnersRunning = false;
  bool _skeletonLoading = false;

  @override
  Widget build(BuildContext context) => PlaygroundGalleryPage(
    title: 'Data Display',
    intro: 'Rich surfaces and status components for product interfaces.',
    sections: [
      PlaygroundGallerySection(
        label: 'Avatar',
        description: 'The native avatar treatment with image and fallback.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s4)
              .crossAxisAlignment(.center),
          children: const [
            PlaygroundAvatar(label: 'RF'),
            PlaygroundAvatar(icon: RemixIcons.person),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Badge',
        description: 'Status labels in every native variant.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s3)
              .runSpacing(PlaygroundTokens.s3),
          children: [
            for (final variant in PlaygroundBadgeVariant.values)
              PlaygroundBadge(
                variant: variant,
                label: playgroundGalleryEnumLabel(variant),
              ),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Card',
        description: 'The native surface and spacing treatment.',
        child: Box(
          style: BoxStyler().width(240),
          child: const PlaygroundCard(
            child: PlaygroundGalleryText('Card content'),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Callout',
        description: 'Contextual information in every native variant.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s3)
              .runSpacing(PlaygroundTokens.s3),
          children: [
            for (final variant in PlaygroundCalloutVariant.values)
              Box(
                style: BoxStyler().width(280),
                child: PlaygroundCallout(
                  variant: variant,
                  icon: variant == PlaygroundCalloutVariant.destructive
                      ? RemixIcons.exclamationTriangle
                      : RemixIcons.infoCircled,
                  text:
                      'A helpful ${playgroundGalleryEnumLabel(variant)} callout.',
                ),
              ),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Data list',
        description: 'Label and value pairs in both orientations.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s8)
              .runSpacing(PlaygroundTokens.s5),
          children: const [
            PlaygroundDataList(
              items: [
                RemixDataListItem(label: 'Status', value: 'Active'),
                RemixDataListItem(label: 'Plan', value: 'Enterprise'),
                RemixDataListItem(label: 'Seats', value: '48'),
              ],
            ),
            PlaygroundDataList(
              orientation: Axis.vertical,
              items: [
                RemixDataListItem(label: 'Status', value: 'Active'),
                RemixDataListItem(label: 'Plan', value: 'Enterprise'),
                RemixDataListItem(label: 'Seats', value: '48'),
              ],
            ),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Skeleton',
        description: 'Placeholder shapes preserve loaded measurements.',
        child: ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(PlaygroundTokens.s3),
          children: [
            PlaygroundButton.secondary(
              size: .small,
              label: _skeletonLoading ? 'Show content' : 'Show skeleton',
              onPressed: () =>
                  setState(() => _skeletonLoading = !_skeletonLoading),
            ),
            PlaygroundSkeleton(
              loading: _skeletonLoading,
              child: const PlaygroundAvatar(label: 'RF'),
            ),
            PlaygroundSkeleton(
              loading: _skeletonLoading,
              child: const PlaygroundGalleryText(
                'Loaded content replaces the placeholder.',
              ),
            ),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Progress',
        description: 'Determinate progress using the native treatment.',
        child: Box(
          style: BoxStyler().width(320),
          child: const PlaygroundProgress(
            value: .68,
            semanticsLabel: '68 percent complete',
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Spinner',
        description:
            'Animation is stopped by default so automated tests settle.',
        child: RowBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.center)
              .spacing(PlaygroundTokens.s4),
          children: [
            PlaygroundButton.secondary(
              size: .small,
              label: _spinnersRunning ? 'Stop' : 'Start',
              onPressed: () =>
                  setState(() => _spinnersRunning = !_spinnersRunning),
            ),
            if (_spinnersRunning)
              const PlaygroundSpinner(semanticsLabel: 'Loading example')
            else
              const Icon(RemixIcons.check, size: PlaygroundTokens.icon),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Divider',
        description: 'Horizontal and vertical native dividers.',
        child: ColumnBox(
          style: FlexBoxStyler().spacing(PlaygroundTokens.s3_5),
          children: [
            const PlaygroundDivider(),
            Box(
              style: BoxStyler().height(PlaygroundTokens.s12),
              child: const PlaygroundDivider(orientation: Axis.vertical),
            ),
          ],
        ),
      ),
    ],
  );
}
