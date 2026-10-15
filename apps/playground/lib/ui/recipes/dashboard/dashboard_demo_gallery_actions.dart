import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/button.dart';
import '../../components/icon_button.dart';
import '../../components/toggle.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_gallery_scaffold.dart';

class PlaygroundGalleryActionsPage extends StatefulWidget {
  const PlaygroundGalleryActionsPage({super.key});

  @override
  State<PlaygroundGalleryActionsPage> createState() =>
      _PlaygroundGalleryActionsPageState();
}

class _PlaygroundGalleryActionsPageState
    extends State<PlaygroundGalleryActionsPage> {
  bool _selected = true;

  @override
  Widget build(BuildContext context) => PlaygroundGalleryPage(
    title: 'Actions',
    intro: 'Interactive actions across every native variant and size.',
    sections: [
      PlaygroundGallerySection(
        label: 'Button',
        description:
            'Primary, secondary, outline, ghost, and destructive actions.',
        child: PlaygroundGalleryEnumMatrix(
          rows: PlaygroundButtonVariant.values,
          columns: PlaygroundButtonSize.values,
          cellBuilder: (context, variant, size) => PlaygroundButton(
            variant: variant,
            size: size,
            onPressed: () =>
                showPlaygroundGalleryToast(context, 'Button pressed'),
            label: 'Button',
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Icon button',
        description:
            'Compact icon-only controls with complete focus semantics.',
        child: PlaygroundGalleryEnumMatrix(
          rows: PlaygroundIconButtonVariant.values,
          columns: PlaygroundIconButtonSize.values,
          cellBuilder: (context, variant, size) => PlaygroundIconButton(
            variant: variant,
            size: size,
            icon: RemixIcons.plus,
            semanticLabel: 'Add item',
            onPressed: () => showPlaygroundGalleryToast(context, 'Item added'),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Toggle',
        description: 'Ghost and outline toggles remain fully interactive.',
        child: PlaygroundGalleryEnumMatrix(
          rows: PlaygroundToggleVariant.values,
          columns: PlaygroundToggleSize.values,
          cellBuilder: (_, variant, size) => PlaygroundToggle(
            variant: variant,
            size: size,
            selected: _selected,
            icon: RemixIcons.fontBold,
            label: 'Bold',
            onChanged: (value) => setState(() => _selected = value),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'States',
        description:
            'Disabled and loading behavior uses the same component API.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s3)
              .runSpacing(PlaygroundTokens.s3),
          children: [
            const PlaygroundButton(label: 'Disabled', enabled: false),
            PlaygroundButton(label: 'Saving', loading: true, onPressed: () {}),
            const PlaygroundIconButton(
              icon: RemixIcons.heart,
              semanticLabel: 'Disabled favorite',
              enabled: false,
            ),
          ],
        ),
      ),
    ],
  );
}
