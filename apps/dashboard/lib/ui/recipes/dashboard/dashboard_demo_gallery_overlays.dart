import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_gallery_scaffold.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_ui.dart';

class UiGalleryOverlaysPage extends StatefulWidget {
  const UiGalleryOverlaysPage({super.key});

  @override
  State<UiGalleryOverlaysPage> createState() => _UiGalleryOverlaysPageState();
}

class _UiGalleryOverlaysPageState extends State<UiGalleryOverlaysPage> {
  bool _showArchived = true;
  String _sort = 'newest';

  @override
  Widget build(BuildContext context) {
    return UiGalleryPage(
      title: 'Overlays',
      intro:
          'Real dialog, popover, tooltip, and menu triggers for every recipe.',
      sections: [
        UiGallerySection(
          label: 'Dialog',
          description:
              'Both viewport alignments across the complete four-size scale.',
          child: UiGalleryMatrix<Alignment, UiDialogSize>(
            rows: const [Alignment.topCenter, Alignment.center],
            rowLabelBuilder: (align) =>
                align == Alignment.topCenter ? 'Top' : 'Center',
            columnLabelBuilder: enumLabel,
            columns: UiDialogSize.values,
            cellBuilder: (context, align, size) => UiButton.soft(
              size: .size1,
              semanticLabel:
                  'Open ${align == Alignment.topCenter ? 'Top' : 'Center'} ${enumLabel(size)} dialog',
              onPressed: () => showRemixDialog<void>(
                context: context,
                barrierLabel: 'Dismiss',
                builder: (dialogContext) => UiDialog(
                  align: align,
                  size: size,
                  title: 'Invite teammates',
                  description: 'Share this workspace with your collaborators.',
                  actions: [
                    UiButton.soft(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      label: 'Cancel',
                    ),
                    UiButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      label: 'Send invite',
                    ),
                  ],
                  child: Box(
                    style: BoxStyler().padding(.only(top: 12)),
                    child: const UiTextField(hintText: 'teammate@example.com'),
                  ),
                ),
              ),
              label: 'Open',
            ),
          ),
        ),
        UiGallerySection(
          label: 'Popover',
          description: 'Anchored content with all four padding presets.',
          child: WrapBox(
            style: WrapBoxStyler().spacing(14).runSpacing(14),
            children: [
              for (final size in UiPopoverSize.values)
                UiPopover(
                  size: size,
                  semanticLabel: 'Open ${enumLabel(size)} popover',
                  popoverChild: Box(
                    style: BoxStyler().width(250),
                    child: ColumnBox(
                      style: FlexBoxStyler()
                          .mainAxisSize(.min)
                          .crossAxisAlignment(.start)
                          .spacing(8),
                      children: const [
                        UiText('Quick note'),
                        UiText(
                          'Popover content inherits the active theme scope.',
                        ),
                      ],
                    ),
                  ),
                  child: _OverlayTrigger('Popover ${enumLabel(size)}'),
                ),
            ],
          ),
        ),
        const UiGallerySection(
          label: 'Tooltip',
          description:
              'Hover or long-press the trigger to reveal contextual help.',
          child: UiTooltip(
            tooltipSemantics: 'Keyboard shortcut Command K',
            tooltipChild: Text('Search · ⌘K'),
            child: _OverlayTrigger('Hover for shortcut'),
          ),
        ),
        UiGallerySection(
          label: 'Menu',
          description: 'Solid and soft menus at both supported density sizes.',
          child: UiGalleryEnumMatrix(
            rows: UiMenuVariant.values,
            columns: UiMenuSize.values,
            cellBuilder: (context, variant, size) => UiMenu<String>(
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
        UiGallerySection(
          label: 'Toast',
          description:
              'Non-blocking status notifications and undo actions hosted by RemixToastScope.',
          child: WrapBox(
            style: WrapBoxStyler().spacing(12).runSpacing(12),
            children: [
              UiButton.soft(
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
              UiButton.outline(
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
      UiBadge.surface(size: .size3, highContrast: true, label: label);
}
