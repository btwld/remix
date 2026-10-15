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

class PlaygroundGalleryOverlaysPage extends StatefulWidget {
  const PlaygroundGalleryOverlaysPage({super.key});

  @override
  State<PlaygroundGalleryOverlaysPage> createState() =>
      _PlaygroundGalleryOverlaysPageState();
}

class _PlaygroundGalleryOverlaysPageState
    extends State<PlaygroundGalleryOverlaysPage> {
  bool _showArchived = true;
  String _sort = 'newest';

  @override
  Widget build(BuildContext context) => PlaygroundGalleryPage(
    title: 'Overlays',
    intro: 'Real dialog, popover, tooltip, and menu triggers for every recipe.',
    sections: [
      PlaygroundGallerySection(
        label: 'Dialog',
        description: 'A modal, focus-trapped confirmation surface.',
        child: Box(
          style: BoxStyler().alignment(.centerStart),
          child: PlaygroundButton.secondary(
            label: 'Open',
            onPressed: () => showRemixDialog<void>(
              context: context,
              barrierLabel: 'Dismiss',
              builder: (dialogContext) => PlaygroundDialog(
                title: 'Invite teammates',
                description: 'Share this workspace with your collaborators.',
                actions: [
                  PlaygroundButton.secondary(
                    label: 'Cancel',
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                  PlaygroundButton(
                    label: 'Send invite',
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
                child: Box(
                  style: BoxStyler().padding(.only(top: PlaygroundTokens.s3)),
                  child: const PlaygroundTextField(
                    hintText: 'teammate@example.com',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Popover',
        description: 'Anchored content using the native padding treatment.',
        child: Box(
          style: BoxStyler().alignment(.centerStart),
          child: PlaygroundPopover(
            semanticLabel: 'Open quick note popover',
            popoverChild: Box(
              style: BoxStyler().width(250),
              child: ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.start)
                    .spacing(PlaygroundTokens.s2),
                children: const [
                  PlaygroundGalleryText('Quick note', emphasized: true),
                  PlaygroundGalleryText(
                    'Popover content inherits the active theme.',
                  ),
                ],
              ),
            ),
            child: const _OverlayTrigger('Open popover'),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Tooltip',
        description: 'Hover or long-press to reveal contextual help.',
        child: Box(
          style: BoxStyler().alignment(.centerStart),
          child: PlaygroundTooltip(
            tooltipSemantics: 'Keyboard shortcut Command K',
            tooltipChild: Text('Search · ⌘K'),
            child: _OverlayTrigger('Hover for shortcut'),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Menu',
        description:
            'Submenus, checkbox and radio items use real menu behavior.',
        child: Box(
          style: BoxStyler().alignment(.centerStart),
          child: PlaygroundMenu<String>(
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
                showPlaygroundGalleryToast(context, '$value selected'),
          ),
        ),
      ),
      PlaygroundGallerySection(
        label: 'Toast',
        description:
            'Non-blocking status notifications and undo actions hosted by RemixToastScope.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s3)
              .runSpacing(PlaygroundTokens.s3),
          children: [
            PlaygroundButton.secondary(
              label: 'Show toast',
              onPressed: () => showRemixToast(
                context,
                const RemixToastData(
                  title: 'Changes saved',
                  description: 'Your workspace settings are up to date.',
                  icon: RemixIcons.checkCircled,
                ),
              ),
            ),
            PlaygroundButton.outline(
              label: 'Show action toast',
              onPressed: () => showRemixToast(
                context,
                RemixToastData(
                  title: 'Deployment queued',
                  description: 'Production rollout starts in 30 seconds.',
                  icon: RemixIcons.bell,
                  action: RemixToastAction(label: 'Undo', onPressed: () {}),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _OverlayTrigger extends StatelessWidget {
  const _OverlayTrigger(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => PlaygroundBadge.outline(label: label);
}
