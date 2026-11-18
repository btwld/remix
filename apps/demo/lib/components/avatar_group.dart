import 'package:demo/helpers/catalog.dart';
import 'package:flutter/widgets.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _studio = [
  FortalAvatarGroupMember('Iara Moreira', initials: 'IM', accent: .caju),
  FortalAvatarGroupMember('Tomás Braga', initials: 'TB', accent: .mar),
  FortalAvatarGroupMember('Lia Fontes', initials: 'LF', accent: .ceu),
  FortalAvatarGroupMember('Caio Nóbrega', initials: 'CN', accent: .serra),
  FortalAvatarGroupMember('Rita Sales', initials: 'RS', accent: .sol),
  FortalAvatarGroupMember('Davi Prado', initials: 'DP', accent: .duna),
];

@widgetbook.UseCase(name: 'Avatar Group Component', type: FortalAvatarGroup)
Widget buildAvatarGroupUseCase(BuildContext context) => Center(
  child: FortalAvatarGroup(
    members: _studio
        .take(
          context.knobs.int.slider(
            label: 'members',
            initialValue: 6,
            min: 1,
            max: _studio.length,
          ),
        )
        .toList(),
    max: context.knobs.int.slider(
      label: 'max',
      initialValue: 4,
      min: 1,
      max: _studio.length,
    ),
    size: context.knobs.object.dropdown(
      label: 'size',
      options: FortalAvatarGroupSize.values,
      labelBuilder: (size) => size.name,
      initialOption: FortalAvatarGroupSize.size2,
    ),
    highContrast: context.knobs.boolean(label: 'highContrast'),
  ),
);

@widgetbook.UseCase(name: 'Catalog', type: FortalAvatarGroup)
Widget buildAvatarGroupCatalogUseCase(BuildContext context) => CatalogMatrix(
  cellWidth: 280,
  columns: labelsOf(FortalAvatarGroupSize.values),
  rows: const ['members', 'overflow'],
  cell: (row, column) => FortalAvatarGroup(
    members: row == 0 ? _studio.take(3).toList() : _studio,
    size: FortalAvatarGroupSize.values[column],
  ),
);
