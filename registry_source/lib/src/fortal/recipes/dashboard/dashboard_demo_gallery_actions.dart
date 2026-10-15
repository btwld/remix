import 'package:flutter/widgets.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:remix/remix.dart';
import 'dashboard_demo_ui.dart';

import 'dashboard_demo_gallery_scaffold.dart';

class FortalGalleryActionsPage extends StatefulWidget {
  const FortalGalleryActionsPage({super.key});

  @override
  State<FortalGalleryActionsPage> createState() =>
      _FortalGalleryActionsPageState();
}

class _FortalGalleryActionsPageState extends State<FortalGalleryActionsPage> {
  bool _selected = true;

  @override
  Widget build(BuildContext context) {
    return FortalGalleryPage(
      title: 'Actions',
      intro: 'Interactive actions across every native variant and size.',
      sections: [
        FortalGallerySection(
          label: 'Button',
          description:
              'Classic, solid, soft, surface, outline, and ghost actions.',
          child: FortalGalleryEnumMatrix(
            rows: FortalButtonVariant.values,
            columns: FortalButtonSize.values,
            cellBuilder: (context, variant, size) => FortalButton(
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
        FortalGallerySection(
          label: 'Icon button',
          description:
              'Compact icon-only controls with complete focus semantics.',
          child: FortalGalleryEnumMatrix(
            rows: FortalIconButtonVariant.values,
            columns: FortalIconButtonSize.values,
            cellBuilder: (context, variant, size) => FortalIconButton(
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
        FortalGallerySection(
          label: 'Toggle',
          description: 'Ghost and outline toggles remain fully interactive.',
          child: FortalGalleryEnumMatrix(
            rows: FortalToggleVariant.values,
            columns: FortalToggleSize.values,
            cellBuilder: (_, variant, size) => FortalToggle(
              variant: variant,
              size: size,
              selected: _selected,
              icon: RemixIcons.fontBold,
              label: 'Bold',
              onChanged: (value) => setState(() => _selected = value),
            ),
          ),
        ),
        FortalGallerySection(
          label: 'States',
          description:
              'Disabled and loading behavior uses the same component API.',
          child: WrapBox(
            style: WrapBoxStyler().spacing(12).runSpacing(12),
            children: [
              const FortalButton(
                enabled: false,
                onPressed: null,
                label: 'Disabled',
              ),
              FortalButton(loading: true, onPressed: () {}, label: 'Saving'),
              FortalIconButton(
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
