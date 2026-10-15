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

class VanillaGalleryDisplayPage extends StatefulWidget {
  const VanillaGalleryDisplayPage({super.key});

  @override
  State<VanillaGalleryDisplayPage> createState() =>
      _VanillaGalleryDisplayPageState();
}

class _VanillaGalleryDisplayPageState extends State<VanillaGalleryDisplayPage> {
  bool _spinnersRunning = false;
  bool _skeletonLoading = false;

  @override
  Widget build(BuildContext context) => VanillaGalleryPage(
    title: 'Data Display',
    intro: 'Rich surfaces and status components for product interfaces.',
    sections: [
      VanillaGallerySection(
        label: 'Avatar',
        description: 'The native avatar treatment with image and fallback.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s4)
              .crossAxisAlignment(.center),
          children: const [
            VanillaAvatar(label: 'RF'),
            VanillaAvatar(icon: RemixIcons.person),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Badge',
        description: 'Status labels in every native variant.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s3)
              .runSpacing(VanillaTokens.s3),
          children: [
            for (final variant in VanillaBadgeVariant.values)
              VanillaBadge(
                variant: variant,
                label: vanillaGalleryEnumLabel(variant),
              ),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Card',
        description: 'The native surface and spacing treatment.',
        child: Box(
          style: BoxStyler().width(240),
          child: const VanillaCard(child: VanillaGalleryText('Card content')),
        ),
      ),
      VanillaGallerySection(
        label: 'Callout',
        description: 'Contextual information in every native variant.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s3)
              .runSpacing(VanillaTokens.s3),
          children: [
            for (final variant in VanillaCalloutVariant.values)
              Box(
                style: BoxStyler().width(280),
                child: VanillaCallout(
                  variant: variant,
                  icon: variant == VanillaCalloutVariant.destructive
                      ? RemixIcons.exclamationTriangle
                      : RemixIcons.infoCircled,
                  text:
                      'A helpful ${vanillaGalleryEnumLabel(variant)} callout.',
                ),
              ),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Data list',
        description: 'Label and value pairs in both orientations.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s8)
              .runSpacing(VanillaTokens.s5),
          children: const [
            VanillaDataList(
              items: [
                RemixDataListItem(label: 'Status', value: 'Active'),
                RemixDataListItem(label: 'Plan', value: 'Enterprise'),
                RemixDataListItem(label: 'Seats', value: '48'),
              ],
            ),
            VanillaDataList(
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
      VanillaGallerySection(
        label: 'Skeleton',
        description: 'Placeholder shapes preserve loaded measurements.',
        child: ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(VanillaTokens.s3),
          children: [
            VanillaButton.secondary(
              size: .small,
              label: _skeletonLoading ? 'Show content' : 'Show skeleton',
              onPressed: () =>
                  setState(() => _skeletonLoading = !_skeletonLoading),
            ),
            VanillaSkeleton(
              loading: _skeletonLoading,
              child: const VanillaAvatar(label: 'RF'),
            ),
            VanillaSkeleton(
              loading: _skeletonLoading,
              child: const VanillaGalleryText(
                'Loaded content replaces the placeholder.',
              ),
            ),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Progress',
        description: 'Determinate progress using the native treatment.',
        child: Box(
          style: BoxStyler().width(320),
          child: const VanillaProgress(
            value: .68,
            semanticsLabel: '68 percent complete',
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Spinner',
        description:
            'Animation is stopped by default so automated tests settle.',
        child: RowBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.center)
              .spacing(VanillaTokens.s4),
          children: [
            VanillaButton.secondary(
              size: .small,
              label: _spinnersRunning ? 'Stop' : 'Start',
              onPressed: () =>
                  setState(() => _spinnersRunning = !_spinnersRunning),
            ),
            if (_spinnersRunning)
              const VanillaSpinner(semanticsLabel: 'Loading example')
            else
              const Icon(RemixIcons.check, size: VanillaTokens.icon),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Divider',
        description: 'Horizontal and vertical native dividers.',
        child: ColumnBox(
          style: FlexBoxStyler().spacing(VanillaTokens.s3_5),
          children: [
            const VanillaDivider(),
            Box(
              style: BoxStyler().height(VanillaTokens.s12),
              child: const VanillaDivider(orientation: Axis.vertical),
            ),
          ],
        ),
      ),
    ],
  );
}
