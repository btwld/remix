import 'package:flutter/widgets.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:remix/remix.dart';
import 'dashboard_demo_ui.dart';

import 'dashboard_demo_text.dart';
import 'dashboard_demo_gallery_scaffold.dart';

class GalleryOverlaysPage extends StatefulWidget {
  const GalleryOverlaysPage({super.key});

  @override
  State<GalleryOverlaysPage> createState() => _GalleryOverlaysPageState();
}

class _GalleryOverlaysPageState extends State<GalleryOverlaysPage> {
  bool _showArchived = true;
  String _sort = 'newest';

  @override
  Widget build(BuildContext context) {
    return GalleryPage(
      title: 'Overlays',
      intro:
          'Real dialog, popover, tooltip, and menu triggers for every recipe.',
      sections: [
        GallerySection(
          label: 'Dialog',
          description:
              'Both viewport alignments across the complete four-size scale.',
          child: GalleryMatrix<Alignment, FortalDialogSize>(
            rows: const [Alignment.topCenter, Alignment.center],
            rowLabelBuilder: (align) =>
                align == Alignment.topCenter ? 'Top' : 'Center',
            columnLabelBuilder: enumLabel,
            columns: FortalDialogSize.values,
            cellBuilder: (context, align, size) => FortalButton.soft(
              size: .size1,
              semanticLabel:
                  'Open ${align == Alignment.topCenter ? 'Top' : 'Center'} ${enumLabel(size)} dialog',
              onPressed: () => showRemixDialog<void>(
                context: context,
                barrierLabel: 'Dismiss',
                builder: (dialogContext) => FortalDialog(
                  align: align,
                  size: size,
                  title: 'Invite teammates',
                  description: 'Share this workspace with your collaborators.',
                  actions: [
                    FortalButton.soft(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      label: 'Cancel',
                    ),
                    FortalButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      label: 'Send invite',
                    ),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: FortalTextField(hintText: 'teammate@example.com'),
                  ),
                ),
              ),
              label: 'Open',
            ),
          ),
        ),
        GallerySection(
          label: 'Popover',
          description: 'Anchored content with all four padding presets.',
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (final size in FortalPopoverSize.values)
                FortalPopover(
                  size: size,
                  semanticLabel: 'Open ${enumLabel(size)} popover',
                  popoverChild: const SizedBox(
                    width: 250,
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .start,
                      spacing: 8,
                      children: [
                        FortalText('Quick note'),
                        FortalText(
                          'Popover content inherits the active Fortal scope.',
                        ),
                      ],
                    ),
                  ),
                  child: _OverlayTrigger('Popover ${enumLabel(size)}'),
                ),
            ],
          ),
        ),
        const GallerySection(
          label: 'Tooltip',
          description:
              'Hover or long-press the trigger to reveal contextual help.',
          child: FortalTooltip(
            tooltipSemantics: 'Keyboard shortcut Command K',
            tooltipChild: Text('Search · ⌘K'),
            child: _OverlayTrigger('Hover for shortcut'),
          ),
        ),
        GallerySection(
          label: 'Menu',
          description: 'Solid and soft menus at both supported density sizes.',
          child: GalleryEnumMatrix(
            rows: FortalMenuVariant.values,
            columns: FortalMenuSize.values,
            cellBuilder: (context, variant, size) => FortalMenu<String>(
              variant: variant,
              size: size,
              trigger: const RemixMenuTrigger(
                label: 'Open menu',
                icon: RemixIcons.dotsHorizontal,
              ),
              items: <RemixMenuItemData<String>>[
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
                  onChanged: (checked) =>
                      setState(() => _showArchived = checked),
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
              onSelected: (value) => showRemixToast(
                context,
                RemixToastData(
                  title: '$value selected',
                  icon: RemixIcons.checkCircled,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The anchor for a popover or tooltip.
///
/// A surface badge, not a button: the overlay owns the gesture, so an
/// interactive control here would either fight it or render disabled.
class _OverlayTrigger extends StatelessWidget {
  const _OverlayTrigger(this.label);
  final String label;

  @override
  Widget build(BuildContext context) =>
      FortalBadge.surface(size: .size3, highContrast: true, label: label);
}
