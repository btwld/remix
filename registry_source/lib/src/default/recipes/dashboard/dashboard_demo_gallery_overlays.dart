import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/badge.dart';
import '../../components/button.dart';
import '../../components/dialog.dart';
import '../../components/menu.dart';
import '../../components/popover.dart';
import '../../components/textfield.dart';
import '../../components/tooltip.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_gallery_scaffold.dart';

class VanillaGalleryOverlaysPage extends StatefulWidget {
  const VanillaGalleryOverlaysPage({super.key});

  @override
  State<VanillaGalleryOverlaysPage> createState() =>
      _VanillaGalleryOverlaysPageState();
}

class _VanillaGalleryOverlaysPageState
    extends State<VanillaGalleryOverlaysPage> {
  bool _showArchived = true;
  String _sort = 'newest';

  @override
  Widget build(BuildContext context) => VanillaGalleryPage(
    title: 'Overlays',
    intro: 'Real dialog, popover, tooltip, and menu triggers for every recipe.',
    sections: [
      VanillaGallerySection(
        label: 'Dialog',
        description: 'A modal, focus-trapped confirmation surface.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaButton.secondary(
            label: 'Open',
            onPressed: () => showRemixDialog<void>(
              context: context,
              barrierLabel: 'Dismiss',
              builder: (dialogContext) => VanillaDialog(
                title: 'Invite teammates',
                description: 'Share this workspace with your collaborators.',
                actions: [
                  VanillaButton.secondary(
                    label: 'Cancel',
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                  VanillaButton(
                    label: 'Send invite',
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
                child: Box(
                  style: BoxStyler().padding(.only(top: VanillaTokens.s3)),
                  child: const VanillaTextField(
                    hintText: 'teammate@example.com',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Popover',
        description: 'Anchored content using the native padding treatment.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaPopover(
            semanticLabel: 'Open quick note popover',
            popoverChild: Box(
              style: BoxStyler().width(250),
              child: ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.start)
                    .spacing(VanillaTokens.s2),
                children: const [
                  VanillaGalleryText('Quick note', emphasized: true),
                  VanillaGalleryText(
                    'Popover content inherits the active theme.',
                  ),
                ],
              ),
            ),
            child: const _OverlayTrigger('Open popover'),
          ),
        ),
      ),
      const VanillaGallerySection(
        label: 'Tooltip',
        description: 'Hover or long-press to reveal contextual help.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaTooltip(
            tooltipSemantics: 'Keyboard shortcut Command K',
            tooltipChild: Text('Search · ⌘K'),
            child: _OverlayTrigger('Hover for shortcut'),
          ),
        ),
      ),
      VanillaGallerySection(
        label: 'Menu',
        description:
            'Submenus, checkbox and radio items use real menu behavior.',
        child: Align(
          alignment: Alignment.centerLeft,
          child: VanillaMenu<String>(
            trigger: const RemixMenuTrigger(
              label: 'Open menu',
              icon: RemixIcons.dotsHorizontal,
            ),
            items: [
              const RemixMenuItem(value: 'duplicate', label: 'Duplicate'),
              const RemixMenuSubmenu(
                label: 'Share',
                items: [
                  RemixMenuItem(value: 'share-link', label: 'Copy link'),
                  RemixMenuItem(value: 'share-email', label: 'Email'),
                ],
              ),
              const RemixMenuDivider(),
              RemixMenuCheckboxItem(
                value: 'archived',
                label: 'Show archived',
                checked: _showArchived,
                onChanged: (checked) => setState(() => _showArchived = checked),
              ),
              const RemixMenuDivider(),
              RemixMenuRadioGroup(
                value: _sort,
                onChanged: (value) => setState(() => _sort = value),
                items: const [
                  RemixMenuRadioItem(value: 'newest', label: 'Newest'),
                  RemixMenuRadioItem(value: 'oldest', label: 'Oldest'),
                ],
              ),
            ],
            onSelected: (value) =>
                showVanillaGalleryToast(context, '$value selected'),
          ),
        ),
      ),
    ],
  );
}

class _OverlayTrigger extends StatelessWidget {
  const _OverlayTrigger(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => VanillaBadge.outline(label: label);
}
