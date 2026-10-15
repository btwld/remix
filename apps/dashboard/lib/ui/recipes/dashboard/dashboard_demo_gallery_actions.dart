import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_gallery_scaffold.dart';
import 'dashboard_demo_ui.dart';

class UiGalleryActionsPage extends StatefulWidget {
  const UiGalleryActionsPage({super.key});

  @override
  State<UiGalleryActionsPage> createState() => _UiGalleryActionsPageState();
}

class _UiGalleryActionsPageState extends State<UiGalleryActionsPage> {
  bool _selected = true;

  @override
  Widget build(BuildContext context) {
    return UiGalleryPage(
      title: 'Actions',
      intro: 'Interactive actions across every native variant and size.',
      sections: [
        UiGallerySection(
          label: 'Button',
          description:
              'Classic, solid, soft, surface, outline, and ghost actions.',
          child: UiGalleryEnumMatrix(
            rows: UiButtonVariant.values,
            columns: UiButtonSize.values,
            cellBuilder: (context, variant, size) => UiButton(
              variant: variant,
              size: size,
              onPressed: () => showRemixToast(
                context,
                const RemixToastData(
                  title: 'Button pressed',
                  icon: RemixIcons.checkCircled,
                ),
              ),
              label: 'Button',
            ),
          ),
        ),
        UiGallerySection(
          label: 'Icon button',
          description:
              'Compact icon-only controls with complete focus semantics.',
          child: UiGalleryEnumMatrix(
            rows: UiIconButtonVariant.values,
            columns: UiIconButtonSize.values,
            cellBuilder: (context, variant, size) => UiIconButton(
              variant: variant,
              size: size,
              semanticLabel: 'Add item',
              onPressed: () => showRemixToast(
                context,
                const RemixToastData(
                  title: 'Item added',
                  icon: RemixIcons.checkCircled,
                ),
              ),
              icon: RemixIcons.plus,
            ),
          ),
        ),
        UiGallerySection(
          label: 'Toggle',
          description: 'Ghost and outline toggles remain fully interactive.',
          child: UiGalleryEnumMatrix(
            rows: UiToggleVariant.values,
            columns: UiToggleSize.values,
            cellBuilder: (_, variant, size) => UiToggle(
              variant: variant,
              size: size,
              selected: _selected,
              icon: RemixIcons.fontBold,
              label: 'Bold',
              onChanged: (value) => setState(() => _selected = value),
            ),
          ),
        ),
        UiGallerySection(
          label: 'States',
          description:
              'Disabled and loading behavior uses the same component API.',
          child: WrapBox(
            style: WrapBoxStyler().spacing(12).runSpacing(12),
            children: [
              const UiButton(
                enabled: false,
                onPressed: null,
                label: 'Disabled',
              ),
              UiButton(loading: true, onPressed: () {}, label: 'Saving'),
              UiIconButton(
                enabled: false,
                semanticLabel: 'Disabled favorite',
                onPressed: () {},
                icon: RemixIcons.heart,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
