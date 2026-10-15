import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/button.dart';
import '../../components/icon_button.dart';
import '../../components/toggle.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_gallery_scaffold.dart';

class VanillaGalleryActionsPage extends StatefulWidget {
  const VanillaGalleryActionsPage({super.key});

  @override
  State<VanillaGalleryActionsPage> createState() =>
      _VanillaGalleryActionsPageState();
}

class _VanillaGalleryActionsPageState extends State<VanillaGalleryActionsPage> {
  bool _selected = true;

  @override
  Widget build(BuildContext context) => VanillaGalleryPage(
    title: 'Actions',
    intro: 'Interactive actions across every native variant and size.',
    sections: [
      VanillaGallerySection(
        label: 'Button',
        description:
            'Primary, secondary, outline, ghost, and destructive actions.',
        child: VanillaGalleryEnumMatrix(
          rows: VanillaButtonVariant.values,
          columns: VanillaButtonSize.values,
          cellBuilder: (context, variant, size) => VanillaButton(
            variant: variant,
            size: size,
            onPressed: () => showVanillaGalleryToast(context, 'Button pressed'),
            label: 'Button',
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Icon button',
        description:
            'Compact icon-only controls with complete focus semantics.',
        child: VanillaGalleryEnumMatrix(
          rows: VanillaIconButtonVariant.values,
          columns: VanillaIconButtonSize.values,
          cellBuilder: (context, variant, size) => VanillaIconButton(
            variant: variant,
            size: size,
            icon: RemixIcons.plus,
            semanticLabel: 'Add item',
            onPressed: () => showVanillaGalleryToast(context, 'Item added'),
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Toggle',
        description: 'Ghost and outline toggles remain fully interactive.',
        child: VanillaGalleryEnumMatrix(
          rows: VanillaToggleVariant.values,
          columns: VanillaToggleSize.values,
          cellBuilder: (_, variant, size) => VanillaToggle(
            variant: variant,
            size: size,
            selected: _selected,
            icon: RemixIcons.fontBold,
            label: 'Bold',
            onChanged: (value) => setState(() => _selected = value),
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'States',
        description:
            'Disabled and loading behavior uses the same component API.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s3)
              .runSpacing(VanillaTokens.s3),
          children: [
            const VanillaButton(label: 'Disabled', enabled: false),
            VanillaButton(label: 'Saving', loading: true, onPressed: () {}),
            const VanillaIconButton(
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
