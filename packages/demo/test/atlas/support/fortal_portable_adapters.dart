import 'package:flutter/material.dart';
import 'package:mix_atlas/mix_atlas.dart';
import 'package:mix_atlas_capture/producer.dart';
import 'package:remix/remix.dart';

typedef _StylesForRow = Map<String, Object> Function(AtlasRow row);
typedef _RecipeProperties = Map<String, Object?> Function(AtlasRow row);

AtlasPortableComponentBuilder buildFortalAccordionPortable(
  ComponentAtlas atlas,
) {
  return _buildComponent(
    atlas,
    properties: [
      _string('title', 'What is Fortal?'),
      _icon('leadingIcon', 'info_outline'),
      _icon('trailingIcon', 'add'),
      _string('content', 'A component recipe built with Remix and Mix.'),
      _boolean('expanded'),
      _boolean('enabled', defaultValue: true),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'root', kind: .flexBox),
      ComponentSlotDefinition(id: 'trigger', kind: .flexBox),
      ComponentSlotDefinition(id: 'leadingIcon', kind: .icon),
      ComponentSlotDefinition(id: 'title', kind: .text),
      ComponentSlotDefinition(id: 'trailingIcon', kind: .icon),
      ComponentSlotDefinition(id: 'content', kind: .box),
      ComponentSlotDefinition(id: 'contentText', kind: .text),
    ],
    nodes: [
      _node('root', .flexBox, 'root', const ['trigger', 'content']),
      _node('trigger', .flexBox, 'trigger', const [
        'leadingIcon',
        'title',
        'trailingIcon',
      ]),
      _node(
        'leadingIcon',
        .icon,
        'leadingIcon',
        const [],
        bindings: const {'icon': AtlasPortableBinding.property('leadingIcon')},
      ),
      _node(
        'title',
        .text,
        'title',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('title')},
      ),
      _node(
        'trailingIcon',
        .icon,
        'trailingIcon',
        const [],
        bindings: const {'icon': AtlasPortableBinding.property('trailingIcon')},
      ),
      _node('content', .box, 'content', const [
        'contentText',
      ], visibleWhen: _propertyEquals('expanded', true)),
      _node(
        'contentText',
        .text,
        'contentText',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('content')},
      ),
    ],
    root: 'root',
    stylesForRow: (row) {
      final style = fortalAccordionStyler(
        variant: _enumValue(FortalAccordionVariant.values, row, 'variant'),
        size: _enumValue(FortalAccordionSize.values, row, 'size'),
      );

      return {
        'root': FlexBoxStyler()
            .direction(.vertical)
            .crossAxisAlignment(.stretch)
            .width(240),
        'trigger': _flex(style, (value) => value.$trigger),
        'leadingIcon': _iconStyle(style, (value) => value.$leadingIcon),
        'title': _text(
          style,
          (value) => value.$title,
        ).wrap(WidgetModifierConfig.flexible(fit: .tight)),
        'trailingIcon': _iconStyle(style, (value) => value.$trailingIcon),
        'content': _withoutBoxConstraints(
          _box(style, (value) => value.$content),
        ).wrap(WidgetModifierConfig.clipRect(clipBehavior: .hardEdge)),
        'contentText': TextStyler().wrap(
          WidgetModifierConfig.padding(EdgeInsetsMix(top: 8)),
        ),
      };
    },
    semantics: _semantics(
      'button',
      label: 'title',
      enabled: 'enabled',
      extra: const {'expanded': AtlasPortableBinding.property('expanded')},
    ),
  );
}

AtlasPortableComponentBuilder buildFortalAvatarPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [_string('label', 'LF')],
    slots: const [
      ComponentSlotDefinition(id: 'container', kind: .box),
      ComponentSlotDefinition(id: 'label', kind: .text),
    ],
    nodes: [
      _node('container', .box, 'container', const ['label']),
      _node(
        'label',
        .text,
        'label',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('label')},
      ),
    ],
    root: 'container',
    stylesForRow: (row) {
      final style = fortalAvatarStyler(
        variant: _enumValue(FortalAvatarVariant.values, row, 'variant'),
        size: _enumValue(FortalAvatarSize.values, row, 'size'),
      );

      return {
        'container': _box(
          style,
          (value) => value.$container,
        ).alignment(.center),
        'label': _text(style, (value) => value.$label),
      };
    },
    semantics: _semantics('image', label: 'label'),
  );
}

AtlasPortableComponentBuilder buildFortalBadgePortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [_string('label', 'New')],
    slots: const [
      ComponentSlotDefinition(id: 'container', kind: .box),
      ComponentSlotDefinition(id: 'label', kind: .text),
    ],
    nodes: [
      _node('container', .box, 'container', const ['label']),
      _node(
        'label',
        .text,
        'label',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('label')},
      ),
    ],
    root: 'container',
    stylesForRow: (row) {
      final style = fortalBadgeStyler(
        variant: _enumValue(FortalBadgeVariant.values, row, 'variant'),
        size: _enumValue(FortalBadgeSize.values, row, 'size'),
      );

      return {
        'container': _box(style, (value) => value.$container),
        'label': _text(style, (value) => value.$label),
      };
    },
    semantics: _semantics('status', label: 'label'),
  );
}

AtlasPortableComponentBuilder buildFortalCalloutPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _icon('icon', 'info_outline'),
      _string('text', 'Helpful information.'),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'container', kind: .flexBox),
      ComponentSlotDefinition(id: 'icon', kind: .icon),
      ComponentSlotDefinition(id: 'text', kind: .text),
    ],
    nodes: [
      _node('container', .flexBox, 'container', const ['icon', 'text']),
      _node(
        'icon',
        .icon,
        'icon',
        const [],
        bindings: const {'icon': AtlasPortableBinding.property('icon')},
      ),
      _node(
        'text',
        .text,
        'text',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('text')},
      ),
    ],
    root: 'container',
    stylesForRow: (row) {
      final style = fortalCalloutStyler(
        variant: _enumValue(FortalCalloutVariant.values, row, 'variant'),
        size: _enumValue(FortalCalloutSize.values, row, 'size'),
      );

      return {
        'container': _flex(style, (value) => value.$container).width(360),
        'icon': _iconStyle(style, (value) => value.$icon),
        'text': _text(style, (value) => value.$text),
      };
    },
    semantics: _semantics('status', label: 'text'),
  );
}

AtlasPortableComponentBuilder buildFortalCardPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _string('avatarRecipe', 'solid-size2', values: const ['solid-size2']),
      _string('avatarState', 'default', values: const ['default']),
      _string('initials', 'LF'),
      _string('name', 'Leo Farias'),
      _string('role', 'Flutter engineer'),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'container', kind: .box),
      ComponentSlotDefinition(id: 'content', kind: .flexBox),
      ComponentSlotDefinition(id: 'details', kind: .flexBox),
      ComponentSlotDefinition(id: 'name', kind: .text),
      ComponentSlotDefinition(id: 'role', kind: .text),
    ],
    nodes: [
      _node('container', .box, 'container', const ['content']),
      _node('content', .flexBox, 'content', const ['avatar', 'details']),
      AtlasPortableNode(
        id: 'avatar',
        kind: .nestedComponent,
        children: const [],
        componentId: 'avatar',
        recipeBinding: const AtlasPortableBinding.property('avatarRecipe'),
        stateBinding: const AtlasPortableBinding.property('avatarState'),
        propertyBindings: const {
          'label': AtlasPortableBinding.property('initials'),
        },
      ),
      _node('details', .flexBox, 'details', const ['name', 'role']),
      _node(
        'name',
        .text,
        'name',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('name')},
      ),
      _node(
        'role',
        .text,
        'role',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('role')},
      ),
    ],
    root: 'container',
    stylesForRow: (row) {
      final style = fortalCardStyler(
        variant: _enumValue(FortalCardVariant.values, row, 'variant'),
        size: _enumValue(FortalCardSize.values, row, 'size'),
      );

      return {
        'container': _box(style, (value) => value.$container),
        'content': FlexBoxStyler()
            .direction(.horizontal)
            .mainAxisSize(.min)
            .spacing(10),
        'details': FlexBoxStyler()
            .direction(.vertical)
            .mainAxisSize(.min)
            .crossAxisAlignment(.start),
        'name': TextStyler(),
        'role': TextStyler(),
      };
    },
    semantics: _semantics('none', label: 'name'),
  );
}

AtlasPortableComponentBuilder buildFortalDividerPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    slots: const [ComponentSlotDefinition(id: 'container', kind: .box)],
    nodes: [_node('container', .box, 'container', const [])],
    root: 'container',
    stylesForRow: (row) {
      final style = fortalDividerStyler(
        size: _enumValue(FortalDividerSize.values, row, 'size'),
      );

      return {'container': _box(style, (value) => value.$container).width(180)};
    },
    semantics: _semantics('none'),
  );
}

AtlasPortableComponentBuilder buildFortalButtonPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _string('label', 'Button'),
      _icon('leadingIcon', 'add', isRequired: false),
      _boolean('enabled', defaultValue: true),
      _boolean('loading'),
      _number('spinnerSize', 16),
      _duration('spinnerDuration', 800),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'root', kind: .stackBox),
      ComponentSlotDefinition(id: 'container', kind: .flexBox),
      ComponentSlotDefinition(id: 'iconFrame', kind: .box),
      ComponentSlotDefinition(id: 'icon', kind: .icon),
      ComponentSlotDefinition(id: 'label', kind: .text),
    ],
    nodes: [
      _node('root', .stackBox, 'root', const ['container', 'spinner']),
      _node('container', .flexBox, 'container', const ['iconFrame', 'label']),
      _node('iconFrame', .box, 'iconFrame', const [
        'icon',
      ], visibleWhen: _propertyPresent('leadingIcon')),
      _node(
        'icon',
        .icon,
        'icon',
        const [],
        bindings: const {'icon': AtlasPortableBinding.property('leadingIcon')},
        visibleWhen: _propertyEquals('loading', false),
        maintain: const {'size', 'state', 'animation'},
      ),
      _node(
        'label',
        .text,
        'label',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('label')},
        visibleWhen: _propertyEquals('loading', false),
        maintain: const {'size', 'state', 'animation'},
      ),
      AtlasPortableNode(
        id: 'spinner',
        kind: .spinner,
        children: const [],
        visibleWhen: _propertyEquals('loading', true),
        bindings: const {
          'size': AtlasPortableBinding.property('spinnerSize'),
          'strokeWidth': AtlasPortableBinding.token(
            kind: 'space',
            name: 'fortal.border.width.1',
          ),
          'color': AtlasPortableBinding.token(
            kind: 'color',
            name: 'fortal.gray.8',
          ),
          'duration': AtlasPortableBinding.property('spinnerDuration'),
        },
      ),
    ],
    root: 'root',
    recipeProperties: (row) => {
      'spinnerSize': _buttonSpinnerSize(row.values['size']!.id),
    },
    stylesForRow: (row) {
      final style = RemixButton.composeStyle(
        fortalButtonStyler(
          variant: _enumValue(FortalButtonVariant.values, row, 'variant'),
          size: _enumValue(FortalButtonSize.values, row, 'size'),
        ),
      );

      return {
        'root': StackBoxStyler(stackAlignment: .center),
        'container': _flex(style, (value) => value.$container),
        'iconFrame': BoxStyler(),
        'icon': _iconStyle(style, (value) => value.$icon),
        'label': _text(style, (value) => value.$label),
      };
    },
    semantics: _semantics(
      'button',
      label: 'label',
      enabled: 'enabled',
      extra: const {'liveRegion': AtlasPortableBinding.property('loading')},
    ),
    diagnostics: const [_callbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalIconButtonPortable(
  ComponentAtlas atlas,
) {
  return _buildComponent(
    atlas,
    properties: [
      _string('label', 'Add'),
      _icon('icon', 'add'),
      _boolean('enabled', defaultValue: true),
      _boolean('loading'),
      _boolean('thickSpinner'),
      _number('spinnerSize', 16),
      _duration('spinnerDuration', 800),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'container', kind: .box),
      ComponentSlotDefinition(id: 'root', kind: .stackBox),
      ComponentSlotDefinition(id: 'spinnerFrame', kind: .box),
      ComponentSlotDefinition(id: 'icon', kind: .icon),
    ],
    nodes: [
      _node('container', .box, 'container', const ['root']),
      _node('root', .stackBox, 'root', const ['icon', 'spinnerFrame']),
      _node(
        'icon',
        .icon,
        'icon',
        const [],
        bindings: const {'icon': AtlasPortableBinding.property('icon')},
        visibleWhen: _propertyEquals('loading', false),
        maintain: const {'size', 'state', 'animation'},
      ),
      _node(
        'spinnerFrame',
        .box,
        'spinnerFrame',
        const ['regularSpinner', 'thickSpinner'],
        visibleWhen: _propertyEquals('loading', true),
      ),
      AtlasPortableNode(
        id: 'regularSpinner',
        kind: .spinner,
        children: const [],
        visibleWhen: _propertyEquals('thickSpinner', false),
        bindings: const {
          'size': AtlasPortableBinding.property('spinnerSize'),
          'strokeWidth': AtlasPortableBinding.token(
            kind: 'space',
            name: 'fortal.border.width.1',
          ),
          'color': AtlasPortableBinding.token(
            kind: 'color',
            name: 'fortal.gray.8',
          ),
          'duration': AtlasPortableBinding.property('spinnerDuration'),
        },
      ),
      AtlasPortableNode(
        id: 'thickSpinner',
        kind: .spinner,
        children: const [],
        visibleWhen: _propertyEquals('thickSpinner', true),
        bindings: const {
          'size': AtlasPortableBinding.property('spinnerSize'),
          'strokeWidth': AtlasPortableBinding.token(
            kind: 'space',
            name: 'fortal.border.width.2',
          ),
          'color': AtlasPortableBinding.token(
            kind: 'color',
            name: 'fortal.gray.8',
          ),
          'duration': AtlasPortableBinding.property('spinnerDuration'),
        },
      ),
    ],
    root: 'container',
    recipeProperties: (row) => {
      'spinnerSize': _buttonSpinnerSize(row.values['size']!.id),
      'thickSpinner': row.values['variant']!.id == 'ghost',
    },
    stylesForRow: (row) {
      final style = fortalIconButtonStyler(
        variant: _enumValue(FortalIconButtonVariant.values, row, 'variant'),
        size: _enumValue(FortalIconButtonSize.values, row, 'size'),
      );

      return {
        'container': _box(style, (value) => value.$container),
        'root': StackBoxStyler(stackAlignment: .center),
        'spinnerFrame': BoxStyler(),
        'icon': _iconStyle(style, (value) => value.$icon),
      };
    },
    semantics: _semantics(
      'button',
      label: 'label',
      enabled: 'enabled',
      extra: const {'liveRegion': AtlasPortableBinding.property('loading')},
    ),
    diagnostics: const [_callbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalCheckboxPortable(
  ComponentAtlas atlas,
) {
  return _buildComponent(
    atlas,
    properties: [
      _string('label', 'Accept terms'),
      _boolean('selected'),
      _boolean('enabled', defaultValue: true),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'container', kind: .box),
      ComponentSlotDefinition(id: 'indicator', kind: .icon),
    ],
    nodes: [
      _node('container', .box, 'container', const ['indicator']),
      _node(
        'indicator',
        .icon,
        'indicator',
        const [],
        bindings: const {'icon': AtlasPortableBinding.literal('check_rounded')},
        visibleWhen: const ComponentVisibilityCondition.widgetState(
          state: 'selected',
          operator: .active,
        ),
      ),
    ],
    root: 'container',
    stylesForRow: (row) {
      final style = fortalCheckboxStyler(
        variant: _enumValue(FortalCheckboxVariant.values, row, 'variant'),
        size: _enumValue(FortalCheckboxSize.values, row, 'size'),
      );

      return {
        'container': _box(style, (value) => value.$container),
        'indicator': _iconStyle(style, (value) => value.$indicator),
      };
    },
    semantics: _semantics(
      'checkbox',
      label: 'label',
      enabled: 'enabled',
      extra: const {'checked': AtlasPortableBinding.property('selected')},
    ),
    diagnostics: const [_callbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalRadioPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _string('label', 'Atlas option'),
      _boolean('selected'),
      _boolean('enabled', defaultValue: true),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'container', kind: .box),
      ComponentSlotDefinition(id: 'indicator', kind: .box),
    ],
    nodes: [
      _node('container', .box, 'container', const ['indicator']),
      _node(
        'indicator',
        .box,
        'indicator',
        const [],
        visibleWhen: const ComponentVisibilityCondition.widgetState(
          state: 'selected',
          operator: .active,
        ),
      ),
    ],
    root: 'container',
    stylesForRow: (row) {
      final style = fortalRadioStyler(
        variant: _enumValue(FortalRadioVariant.values, row, 'variant'),
        size: _enumValue(FortalRadioSize.values, row, 'size'),
      );

      return {
        'container': _box(style, (value) => value.$container),
        'indicator': _box(style, (value) => value.$indicator),
      };
    },
    semantics: _semantics(
      'radio',
      label: 'label',
      enabled: 'enabled',
      extra: const {'checked': AtlasPortableBinding.property('selected')},
    ),
    diagnostics: const [_callbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalSwitchPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _string('label', 'Notifications'),
      _boolean('selected'),
      _boolean('enabled', defaultValue: true),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'container', kind: .box),
      ComponentSlotDefinition(id: 'thumb', kind: .box),
    ],
    nodes: [
      _node('container', .box, 'container', const ['thumb']),
      _node('thumb', .box, 'thumb', const []),
    ],
    root: 'container',
    stylesForRow: (row) {
      final style = RemixSwitchStyler()
          .alignment(.centerLeft)
          .onSelected(RemixSwitchStyler().alignment(.centerRight))
          .merge(
            fortalSwitchStyler(
              variant: _enumValue(FortalSwitchVariant.values, row, 'variant'),
              size: _enumValue(FortalSwitchSize.values, row, 'size'),
            ),
          );

      return {
        'container': _box(style, (value) => value.$container),
        'thumb': _canonicalizeShapeDecoration(
          _box(style, (value) => value.$thumb),
        ),
      };
    },
    semantics: _semantics(
      'switch',
      label: 'label',
      enabled: 'enabled',
      extra: const {'toggled': AtlasPortableBinding.property('selected')},
    ),
    diagnostics: const [_callbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalTogglePortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _string('label', 'Bold'),
      _icon('icon', 'format_bold'),
      _boolean('selected'),
      _boolean('enabled', defaultValue: true),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'container', kind: .flexBox),
      ComponentSlotDefinition(id: 'icon', kind: .icon),
      ComponentSlotDefinition(id: 'label', kind: .text),
    ],
    nodes: [
      _node('container', .flexBox, 'container', const ['icon', 'label']),
      _node(
        'icon',
        .icon,
        'icon',
        const [],
        bindings: const {'icon': AtlasPortableBinding.property('icon')},
      ),
      _node(
        'label',
        .text,
        'label',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('label')},
      ),
    ],
    root: 'container',
    stylesForRow: (row) {
      final style = fortalToggleStyler(
        variant: _enumValue(FortalToggleVariant.values, row, 'variant'),
        size: _enumValue(FortalToggleSize.values, row, 'size'),
      );

      return {
        'container': _flex(style, (value) => value.$container),
        'icon': _iconStyle(style, (value) => value.$icon),
        'label': _text(style, (value) => value.$label),
      };
    },
    semantics: _semantics(
      'button',
      label: 'label',
      enabled: 'enabled',
      extra: const {'selected': AtlasPortableBinding.property('selected')},
    ),
    diagnostics: const [_callbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalProgressPortable(
  ComponentAtlas atlas,
) {
  return _buildComponent(
    atlas,
    properties: [_number('value', 0.5)],
    slots: const [
      ComponentSlotDefinition(id: 'outer', kind: .box),
      ComponentSlotDefinition(id: 'container', kind: .box),
      ComponentSlotDefinition(id: 'stack', kind: .stackBox),
      ComponentSlotDefinition(id: 'track', kind: .box),
      ComponentSlotDefinition(id: 'indicator', kind: .box),
      ComponentSlotDefinition(id: 'trackContainer', kind: .box),
    ],
    nodes: [
      _node('outer', .box, 'outer', const ['container']),
      _node('container', .box, 'container', const ['stack']),
      _node('stack', .stackBox, 'stack', const [
        'track',
        'indicatorWidth',
        'trackContainer',
      ]),
      _node('track', .box, 'track', const []),
      AtlasPortableNode(
        id: 'indicatorWidth',
        kind: .fractionalPosition,
        children: const ['indicator'],
        bindings: const {
          'widthFactor': AtlasPortableBinding.property('value'),
          'alignment': AtlasPortableBinding.literal('centerLeft'),
        },
      ),
      _node('indicator', .box, 'indicator', const []),
      _node('trackContainer', .box, 'trackContainer', const []),
    ],
    root: 'outer',
    stylesForRow: (row) {
      final style = fortalProgressStyler(
        variant: _enumValue(FortalProgressVariant.values, row, 'variant'),
        size: _enumValue(FortalProgressSize.values, row, 'size'),
      );
      final height = _progressHeight(row.values['size']!.id);

      return {
        'outer': BoxStyler().width(180),
        'container': _withoutBoxConstraints(
          _box(style, (value) => value.$container),
        ).width(180).height(height),
        'stack': StackBoxStyler(stackAlignment: .centerLeft),
        'track': _withoutBoxConstraints(
          _box(style, (value) => value.$track),
        ).width(180).height(height),
        'indicator': _box(style, (value) => value.$indicator),
        'trackContainer': _box(style, (value) => value.$trackContainer),
      };
    },
    semantics: _semantics(
      'progressIndicator',
      extra: const {'value': AtlasPortableBinding.property('value')},
    ),
  );
}

AtlasPortableComponentBuilder buildFortalSliderPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _number('value', 0.55),
      _number('rangeFactor', 0.55),
      _number('thumbFactor', 0.55),
      _boolean('enabled', defaultValue: true),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'outer', kind: .box),
      ComponentSlotDefinition(id: 'stack', kind: .stackBox),
      ComponentSlotDefinition(id: 'trackFrame', kind: .box),
      ComponentSlotDefinition(id: 'trackStack', kind: .stackBox),
      ComponentSlotDefinition(id: 'track', kind: .box),
      ComponentSlotDefinition(id: 'range', kind: .box),
      ComponentSlotDefinition(id: 'positionFrame', kind: .box),
      ComponentSlotDefinition(id: 'thumbAlign', kind: .stackBox),
      ComponentSlotDefinition(id: 'thumb', kind: .box),
    ],
    nodes: [
      _node('outer', .box, 'outer', const ['stack']),
      _node('stack', .stackBox, 'stack', const ['trackFrame', 'positionFrame']),
      _node('trackFrame', .box, 'trackFrame', const ['trackStack']),
      _node('trackStack', .stackBox, 'trackStack', const [
        'track',
        'rangeWidth',
      ]),
      _node('track', .box, 'track', const []),
      AtlasPortableNode(
        id: 'rangeWidth',
        kind: .fractionalPosition,
        children: const ['range'],
        bindings: const {
          'widthFactor': AtlasPortableBinding.property('rangeFactor'),
          'alignment': AtlasPortableBinding.literal('centerLeft'),
        },
      ),
      _node('range', .box, 'range', const []),
      _node('positionFrame', .box, 'positionFrame', const ['thumbWidth']),
      AtlasPortableNode(
        id: 'thumbWidth',
        kind: .fractionalPosition,
        children: const ['thumbAlign'],
        bindings: const {
          'widthFactor': AtlasPortableBinding.property('thumbFactor'),
          'alignment': AtlasPortableBinding.literal('centerLeft'),
        },
      ),
      _node('thumbAlign', .stackBox, 'thumbAlign', const ['thumb']),
      _node('thumb', .box, 'thumb', const []),
    ],
    root: 'outer',
    recipeProperties: (row) => {
      'rangeFactor': _sliderRangeFactor(row.values['size']!.id, 0.55),
      'thumbFactor': _sliderThumbFactor(row.values['size']!.id, 0.55),
    },
    stylesForRow: (row) {
      final style = fortalSliderStyler(
        variant: _enumValue(FortalSliderVariant.values, row, 'variant'),
        size: _enumValue(FortalSliderSize.values, row, 'size'),
      );
      final metrics = _sliderMetrics(row.values['size']!.id);
      final availableWidth = 180 - metrics.thumb;
      final paintedTrackWidth = availableWidth + metrics.track;

      return {
        'outer': BoxStyler().width(180).height(metrics.height),
        'stack': StackBoxStyler(stackAlignment: .centerLeft),
        'trackFrame': BoxStyler()
            .width(paintedTrackWidth)
            .height(metrics.track)
            .marginX((180 - paintedTrackWidth) / 2),
        'trackStack': StackBoxStyler(stackAlignment: .centerLeft),
        'track': _sliderLine(
          style,
          range: false,
          paintedWidth: paintedTrackWidth,
        ),
        'range': _sliderLine(
          style,
          range: true,
          paintedWidth: paintedTrackWidth,
        ),
        'positionFrame': BoxStyler()
            .width(availableWidth)
            .height(metrics.height)
            .marginX(metrics.thumb / 2),
        'thumbAlign': StackBoxStyler(stackAlignment: .centerRight),
        'thumb': _canonicalizeShapeDecoration(
          _box(style, (value) => value.$thumb),
        ),
      };
    },
    semantics: _semantics(
      'slider',
      enabled: 'enabled',
      extra: const {'value': AtlasPortableBinding.property('value')},
    ),
    diagnostics: const [_callbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalSpinnerPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _number('spinnerSize', 20),
      _number('strokeWidth', 2),
      _duration('duration', 800),
    ],
    slots: const [],
    nodes: [
      AtlasPortableNode(
        id: 'spinner',
        kind: .spinner,
        children: [],
        bindings: {
          'size': AtlasPortableBinding.property('spinnerSize'),
          'strokeWidth': AtlasPortableBinding.property('strokeWidth'),
          'color': AtlasPortableBinding.token(
            kind: 'color',
            name: 'fortal.accent.9',
          ),
          'duration': AtlasPortableBinding.property('duration'),
        },
      ),
    ],
    root: 'spinner',
    recipeProperties: (row) {
      final metrics = _spinnerMetrics(row.values['size']!.id);

      return {'spinnerSize': metrics.size, 'strokeWidth': metrics.stroke};
    },
    stylesForRow: (_) => const {},
    semantics: _semantics(
      'progressIndicator',
      extra: const {'liveRegion': AtlasPortableBinding.literal(true)},
    ),
  );
}

AtlasPortableComponentBuilder buildFortalDialogPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _string('title', 'Revoke access'),
      _string(
        'description',
        'This application will no longer be accessible to the user.',
      ),
      _string('buttonState', 'default', values: const ['default']),
      _string('cancelRecipe', 'ghost-size2', values: const ['ghost-size2']),
      _string('revokeRecipe', 'solid-size2', values: const ['solid-size2']),
      _string('cancelLabel', 'Cancel'),
      _string('revokeLabel', 'Revoke'),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'outer', kind: .box),
      ComponentSlotDefinition(id: 'container', kind: .box),
      ComponentSlotDefinition(id: 'body', kind: .flexBox),
      ComponentSlotDefinition(id: 'title', kind: .text),
      ComponentSlotDefinition(id: 'description', kind: .text),
      ComponentSlotDefinition(id: 'actions', kind: .flexBox),
    ],
    nodes: [
      _node('outer', .box, 'outer', const ['container']),
      _node('container', .box, 'container', const ['body']),
      _node('body', .flexBox, 'body', const [
        'title',
        'description',
        'actions',
      ]),
      _node(
        'title',
        .text,
        'title',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('title')},
      ),
      _node(
        'description',
        .text,
        'description',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('description')},
      ),
      _node('actions', .flexBox, 'actions', const ['cancel', 'revoke']),
      AtlasPortableNode(
        id: 'cancel',
        kind: .nestedComponent,
        children: const [],
        componentId: 'button',
        recipeBinding: const AtlasPortableBinding.property('cancelRecipe'),
        stateBinding: const AtlasPortableBinding.property('buttonState'),
        propertyBindings: const {
          'label': AtlasPortableBinding.property('cancelLabel'),
          'leadingIcon': AtlasPortableBinding.literal(null),
        },
      ),
      AtlasPortableNode(
        id: 'revoke',
        kind: .nestedComponent,
        children: const [],
        componentId: 'button',
        recipeBinding: const AtlasPortableBinding.property('revokeRecipe'),
        stateBinding: const AtlasPortableBinding.property('buttonState'),
        propertyBindings: const {
          'label': AtlasPortableBinding.property('revokeLabel'),
          'leadingIcon': AtlasPortableBinding.literal(null),
        },
      ),
    ],
    root: 'outer',
    stylesForRow: (_) {
      final style = fortalDialogStyler();

      return {
        'outer': BoxStyler().width(340),
        'container': _box(style, (value) => value.$container),
        'body': FlexBoxStyler()
            .direction(.vertical)
            .mainAxisSize(.min)
            .crossAxisAlignment(.start),
        'title': _text(style, (value) => value.$title),
        'description': _text(style, (value) => value.$description),
        'actions': _flex(style, (value) => value.$actions),
      };
    },
    semantics: _semantics('dialog', label: 'title'),
    diagnostics: const [_callbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalMenuPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _string('label', 'Actions'),
      _icon('icon', 'keyboard_arrow_down'),
      _boolean('enabled', defaultValue: true),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'container', kind: .flexBox),
      ComponentSlotDefinition(id: 'icon', kind: .icon),
      ComponentSlotDefinition(id: 'label', kind: .text),
    ],
    nodes: [
      _node('container', .flexBox, 'container', const ['icon', 'label']),
      _node(
        'icon',
        .icon,
        'icon',
        const [],
        bindings: const {'icon': AtlasPortableBinding.property('icon')},
      ),
      _node(
        'label',
        .text,
        'label',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('label')},
      ),
    ],
    root: 'container',
    stylesForRow: (row) {
      final style = RemixMenuStyler()
          .trigger(RemixMenuTriggerStyler().mainAxisSize(.min))
          .merge(
            fortalMenuStyler(
              variant: _enumValue(FortalMenuVariant.values, row, 'variant'),
              size: _enumValue(FortalMenuSize.values, row, 'size'),
            ),
          );

      return {
        'container': _menuTriggerFlex(style, (value) => value.$container),
        'icon': _menuTriggerIcon(style, (value) => value.$icon),
        'label': _menuTriggerText(style, (value) => value.$label),
      };
    },
    semantics: _semantics('button', label: 'label', enabled: 'enabled'),
    diagnostics: const [_overlayAndCallbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalSelectPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _string('label', 'Apple'),
      _icon('indicator', 'keyboard_arrow_down'),
      _boolean('enabled', defaultValue: true),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'container', kind: .flexBox),
      ComponentSlotDefinition(id: 'label', kind: .text),
      ComponentSlotDefinition(id: 'icon', kind: .icon),
    ],
    nodes: [
      _node('container', .flexBox, 'container', const ['label', 'icon']),
      _node(
        'label',
        .text,
        'label',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('label')},
      ),
      _node(
        'icon',
        .icon,
        'icon',
        const [],
        bindings: const {'icon': AtlasPortableBinding.property('indicator')},
      ),
    ],
    root: 'container',
    stylesForRow: (row) {
      final style = RemixSelectStyler()
          .trigger(RemixSelectTriggerStyler().mainAxisSize(.min))
          .merge(
            fortalSelectStyler(
              variant: _enumValue(FortalSelectVariant.values, row, 'variant'),
              size: _enumValue(FortalSelectSize.values, row, 'size'),
            ),
          );

      return {
        'container': _selectTriggerFlex(
          style,
          (value) => value.$container,
        ).wrap(WidgetModifierConfig.intrinsicWidth()),
        'label': _selectTriggerText(
          style,
          (value) => value.$label,
        ).wrap(WidgetModifierConfig.flexible(fit: .tight)),
        'icon': _selectTriggerIcon(style, (value) => value.$icon),
      };
    },
    semantics: _semantics('button', label: 'label', enabled: 'enabled'),
    diagnostics: const [_overlayAndCallbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalTabsPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _string('tab', 'first', values: const ['first', 'second']),
      _string('firstLabel', 'Overview'),
      _string('secondLabel', 'Activity'),
      _string('firstContent', 'Overview content'),
      _string('secondContent', 'Activity content'),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'outer', kind: .box),
      ComponentSlotDefinition(id: 'root', kind: .flexBox),
      ComponentSlotDefinition(id: 'bar', kind: .flexBox),
      ComponentSlotDefinition(id: 'viewRow', kind: .flexBox),
      ComponentSlotDefinition(id: 'firstFrameSelected', kind: .box),
      ComponentSlotDefinition(id: 'firstTabSelected', kind: .flexBox),
      ComponentSlotDefinition(id: 'firstLabelSelected', kind: .text),
      ComponentSlotDefinition(id: 'firstFrameDefault', kind: .box),
      ComponentSlotDefinition(id: 'firstTabDefault', kind: .flexBox),
      ComponentSlotDefinition(id: 'firstLabelDefault', kind: .text),
      ComponentSlotDefinition(id: 'secondFrameSelected', kind: .box),
      ComponentSlotDefinition(id: 'secondTabSelected', kind: .flexBox),
      ComponentSlotDefinition(id: 'secondLabelSelected', kind: .text),
      ComponentSlotDefinition(id: 'secondFrameDefault', kind: .box),
      ComponentSlotDefinition(id: 'secondTabDefault', kind: .flexBox),
      ComponentSlotDefinition(id: 'secondLabelDefault', kind: .text),
      ComponentSlotDefinition(id: 'firstView', kind: .box),
      ComponentSlotDefinition(id: 'firstContent', kind: .text),
      ComponentSlotDefinition(id: 'secondView', kind: .box),
      ComponentSlotDefinition(id: 'secondContent', kind: .text),
    ],
    nodes: [
      _node('outer', .box, 'outer', const ['root']),
      _node('root', .flexBox, 'root', const ['bar', 'viewRow']),
      _node('bar', .flexBox, 'bar', const [
        'firstFrameSelected',
        'firstFrameDefault',
        'secondFrameSelected',
        'secondFrameDefault',
      ]),
      ..._tabNodes(
        id: 'first',
        selected: true,
        labelProperty: 'firstLabel',
        visibleWhen: _propertyEquals('tab', 'first'),
      ),
      ..._tabNodes(
        id: 'first',
        selected: false,
        labelProperty: 'firstLabel',
        visibleWhen: _propertyEquals('tab', 'second'),
      ),
      ..._tabNodes(
        id: 'second',
        selected: true,
        labelProperty: 'secondLabel',
        visibleWhen: _propertyEquals('tab', 'second'),
      ),
      ..._tabNodes(
        id: 'second',
        selected: false,
        labelProperty: 'secondLabel',
        visibleWhen: _propertyEquals('tab', 'first'),
      ),
      _node('viewRow', .flexBox, 'viewRow', const ['firstView', 'secondView']),
      _node('firstView', .box, 'firstView', const [
        'firstContent',
      ], visibleWhen: _propertyEquals('tab', 'first')),
      _node(
        'firstContent',
        .text,
        'firstContent',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('firstContent')},
      ),
      _node('secondView', .box, 'secondView', const [
        'secondContent',
      ], visibleWhen: _propertyEquals('tab', 'second')),
      _node(
        'secondContent',
        .text,
        'secondContent',
        const [],
        bindings: const {
          'text': AtlasPortableBinding.property('secondContent'),
        },
      ),
    ],
    root: 'outer',
    stylesForRow: (_) {
      final barStyle = fortalTabBarStyler();
      final tabStyle = fortalTabStyler();
      final viewStyle = fortalTabViewStyler();

      return {
        'outer': BoxStyler().width(280),
        'root': FlexBoxStyler().direction(.vertical).spacing(12),
        'bar': _flex(barStyle, (value) => value.$container).spacing(0),
        'viewRow': FlexBoxStyler().direction(.horizontal),
        'firstFrameSelected': _tabFrame(selected: false),
        'firstTabSelected': _flex(tabStyle, (value) => value.$container),
        'firstLabelSelected': _text(tabStyle, (value) => value.$label),
        'firstFrameDefault': _tabFrame(selected: false),
        'firstTabDefault': _flex(tabStyle, (value) => value.$container),
        'firstLabelDefault': _text(tabStyle, (value) => value.$label),
        'secondFrameSelected': _tabFrame(selected: false),
        'secondTabSelected': _flex(tabStyle, (value) => value.$container),
        'secondLabelSelected': _text(tabStyle, (value) => value.$label),
        'secondFrameDefault': _tabFrame(selected: false),
        'secondTabDefault': _flex(tabStyle, (value) => value.$container),
        'secondLabelDefault': _text(tabStyle, (value) => value.$label),
        'firstView': _box(viewStyle, (value) => value.$container),
        'firstContent': TextStyler(),
        'secondView': _box(viewStyle, (value) => value.$container),
        'secondContent': TextStyler(),
      };
    },
    semantics: _semantics(
      'tab',
      label: 'tab',
      extra: const {'selected': AtlasPortableBinding.literal(true)},
    ),
    diagnostics: const [_callbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalTextFieldPortable(
  ComponentAtlas atlas,
) {
  return _buildComponent(
    atlas,
    properties: [
      _string('label', 'Email'),
      _string('hint', 'name@example.com'),
      _string('helperText', 'Required'),
      _icon('leadingIcon', 'email_outlined'),
      _boolean('enabled', defaultValue: true),
      _boolean('error'),
      _number('cursorWidth', 1.5),
    ],
    slots: const [
      ComponentSlotDefinition(id: 'outer', kind: .box),
      ComponentSlotDefinition(id: 'root', kind: .flexBox),
      ComponentSlotDefinition(id: 'label', kind: .text),
      ComponentSlotDefinition(id: 'container', kind: .flexBox),
      ComponentSlotDefinition(id: 'leadingIcon', kind: .icon),
      ComponentSlotDefinition(id: 'hint', kind: .text),
      ComponentSlotDefinition(id: 'helperText', kind: .text),
    ],
    nodes: [
      _node('outer', .box, 'outer', const ['root']),
      _node('root', .flexBox, 'root', const [
        'label',
        'container',
        'helperText',
      ]),
      _node(
        'label',
        .text,
        'label',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('label')},
      ),
      _node('container', .flexBox, 'container', const ['leadingIcon', 'hint']),
      _node(
        'leadingIcon',
        .icon,
        'leadingIcon',
        const [],
        bindings: const {'icon': AtlasPortableBinding.property('leadingIcon')},
      ),
      _node(
        'hint',
        .text,
        'hint',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('hint')},
      ),
      _node(
        'helperText',
        .text,
        'helperText',
        const [],
        bindings: const {'text': AtlasPortableBinding.property('helperText')},
      ),
    ],
    root: 'outer',
    stylesForRow: (row) {
      final variant = _enumValue(FortalTextFieldVariant.values, row, 'variant');
      final style = fortalTextFieldStyler(
        variant: variant,
        size: _enumValue(FortalTextFieldSize.values, row, 'size'),
      );

      return {
        'outer': BoxStyler().width(220),
        'root': FlexBoxStyler()
            .direction(.vertical)
            .mainAxisSize(.min)
            .crossAxisAlignment(.start),
        'label': _text(style, (value) => value.$label),
        'container': _flex(
          style,
          (value) => value.$container,
        ).height(_textFieldContainerHeight(row.values['size']!.id)),
        'leadingIcon': IconStyler(
          color: variant == FortalTextFieldVariant.surface
              ? FortalTokens.gray10()
              : FortalTokens.accent10(),
          size: 16,
        ),
        'hint': _text(
          style,
          (value) => value.$hintText,
        ).wrap(WidgetModifierConfig.flexible(fit: .tight)),
        'helperText': _text(style, (value) => value.$helperText),
      };
    },
    semantics: _semantics(
      'textField',
      label: 'label',
      enabled: 'enabled',
      extra: const {
        'hint': AtlasPortableBinding.property('hint'),
        'invalid': AtlasPortableBinding.property('error'),
        'required': AtlasPortableBinding.literal(true),
      },
    ),
    diagnostics: const [_editingAndCallbacksOmitted],
  );
}

AtlasPortableComponentBuilder buildFortalTooltipPortable(ComponentAtlas atlas) {
  return _buildComponent(
    atlas,
    properties: [
      _string('label', 'Helpful context'),
      _string('buttonLabel', 'Hover me'),
      _string('buttonRecipe', 'solid-size2', values: const ['solid-size2']),
      _string(
        'buttonState',
        'default',
        values: const ['default', 'hovered', 'focused'],
      ),
    ],
    slots: const [],
    nodes: [
      AtlasPortableNode(
        id: 'trigger',
        kind: .nestedComponent,
        children: [],
        componentId: 'button',
        recipeBinding: AtlasPortableBinding.property('buttonRecipe'),
        stateBinding: AtlasPortableBinding.property('buttonState'),
        propertyBindings: {
          'label': AtlasPortableBinding.property('buttonLabel'),
          'leadingIcon': AtlasPortableBinding.literal(null),
        },
      ),
    ],
    root: 'trigger',
    stylesForRow: (_) => const {},
    semantics: _semantics('tooltip', label: 'label'),
    diagnostics: const [_overlayAndCallbacksOmitted],
  );
}

double _buttonSpinnerSize(String size) => switch (size) {
  'size1' => 12,
  'size2' => 16,
  'size3' => 20,
  'size4' => 24,
  _ => throw ArgumentError.value(size, 'size'),
};

({double thumb, double track, double height}) _sliderMetrics(String size) {
  return switch (size) {
    'size1' => (thumb: 13, track: 6, height: 19),
    'size2' => (thumb: 16, track: 8, height: 24),
    'size3' => (thumb: 19, track: 10, height: 29),
    _ => throw ArgumentError.value(size, 'size'),
  };
}

double _sliderRangeFactor(String size, double value) {
  final metrics = _sliderMetrics(size);
  final availableWidth = 180 - metrics.thumb;
  final paintedTrackWidth = availableWidth + metrics.track;

  return (availableWidth * value + metrics.track) / paintedTrackWidth;
}

double _sliderThumbFactor(String size, double value) {
  final metrics = _sliderMetrics(size);
  final availableWidth = 180 - metrics.thumb;

  return value + metrics.thumb / (2 * availableWidth);
}

double _textFieldContainerHeight(String size) {
  return switch (size) {
    'size1' => 33,
    'size2' => 44,
    'size3' => 53,
    _ => throw ArgumentError.value(size, 'size'),
  };
}

({double size, double stroke}) _spinnerMetrics(String size) {
  return switch (size) {
    'size1' => (size: 16, stroke: 1.5),
    'size2' => (size: 20, stroke: 2),
    'size3' => (size: 24, stroke: 2.5),
    _ => throw ArgumentError.value(size, 'size'),
  };
}

double _progressHeight(String size) {
  return switch (size) {
    'size1' => 4,
    'size2' => 8,
    'size3' => 12,
    _ => throw ArgumentError.value(size, 'size'),
  };
}

BoxStyler _sliderLine(
  RemixSliderStyler style, {
  required bool range,
  required double paintedWidth,
}) {
  final color = _lastPropValue<Color>(
    range ? style.$rangeColor : style.$trackColor,
  );
  final width = _lastPropValue<double>(
    range ? style.$rangeWidth : style.$trackWidth,
  );
  var result = BoxStyler();
  if (color != null) result = result.color(color);
  if (width != null) result = result.height(width);
  result = result
      .width(paintedWidth)
      .borderRadiusAll(const Radius.circular(999));
  final variants = <VariantStyle<BoxSpec>>[];
  for (final variant
      in style.$variants ?? const <VariantStyle<RemixSliderSpec>>[]) {
    if (variant.value is! RemixSliderStyler) {
      throw StateError('Slider variants must retain RemixSliderStyler values.');
    }
    variants.add(
      VariantStyle(
        variant.variant,
        _sliderLine(
          variant.value as RemixSliderStyler,
          range: range,
          paintedWidth: paintedWidth,
        ),
      ),
    );
  }

  return variants.isEmpty ? result : result.variants(variants);
}

BoxStyler _withoutBoxConstraints(BoxStyler style) {
  return BoxStyler.create(
    alignment: style.$alignment,
    padding: style.$padding,
    margin: style.$margin,
    decoration: style.$decoration,
    foregroundDecoration: style.$foregroundDecoration,
    transform: style.$transform,
    transformAlignment: style.$transformAlignment,
    clipBehavior: style.$clipBehavior,
    variants: [
      for (final variant in style.$variants ?? const <VariantStyle<BoxSpec>>[])
        VariantStyle(
          variant.variant,
          _withoutBoxConstraints(variant.value as BoxStyler),
        ),
    ],
    modifier: style.$modifier,
    animation: style.$animation,
  );
}

BoxStyler _canonicalizeShapeDecoration(BoxStyler style) {
  if (style.$decoration?.$directives?.isNotEmpty ?? false) {
    throw StateError('Slider thumb decoration directives are unsupported.');
  }
  var result = BoxStyler.create(
    alignment: style.$alignment,
    padding: style.$padding,
    margin: style.$margin,
    constraints: style.$constraints,
    foregroundDecoration: style.$foregroundDecoration,
    transform: style.$transform,
    transformAlignment: style.$transformAlignment,
    clipBehavior: style.$clipBehavior,
    variants: [
      for (final variant in style.$variants ?? const <VariantStyle<BoxSpec>>[])
        VariantStyle(
          variant.variant,
          _canonicalizeShapeDecoration(variant.value as BoxStyler),
        ),
    ],
    modifier: style.$modifier,
    animation: style.$animation,
  );
  for (final source
      in style.$decoration?.sources ?? const <PropSource<Decoration>>[]) {
    if (source is! MixSource<Decoration>) {
      throw StateError('Slider thumb decorations must be Mix sources.');
    }
    final decoration = switch (source.mix) {
      final BoxDecorationMix value => value,
      final ShapeDecorationMix value => _circleShapeAsBox(value),
      final value => throw StateError(
        'Unsupported slider thumb decoration ${value.runtimeType}.',
      ),
    };
    result = result.merge(BoxStyler(decoration: decoration));
  }

  return result;
}

BoxDecorationMix _circleShapeAsBox(ShapeDecorationMix decoration) {
  if (decoration.$shape?.$directives?.isNotEmpty ?? false) {
    throw StateError('Slider thumb shape directives are unsupported.');
  }
  CircleBorderMix? circle;
  for (final source
      in decoration.$shape?.sources ?? const <PropSource<ShapeBorder>>[]) {
    if (source is! MixSource<ShapeBorder> || source.mix is! CircleBorderMix) {
      throw StateError('Slider thumb shape must be a Mix circle border.');
    }
    final next = source.mix as CircleBorderMix;
    circle = circle == null ? next : circle.merge(next);
  }
  if (circle == null) {
    throw StateError('Slider thumb shape must define a circle border.');
  }
  final eccentricity = _lastPropValue(circle.$eccentricity);
  if (eccentricity != null && eccentricity != 0) {
    throw StateError('Eccentric circle borders are not portable.');
  }
  final side = circle.$side == null
      ? null
      : BorderMix.create(
          top: circle.$side,
          right: circle.$side,
          bottom: circle.$side,
          left: circle.$side,
        );

  return BoxDecorationMix.create(
    border: side == null ? null : Prop.mix<BoxBorder>(side),
    shape: Prop.value(BoxShape.circle),
    color: decoration.$color,
    image: decoration.$image,
    gradient: decoration.$gradient,
    boxShadow: decoration.$boxShadow,
  );
}

V? _lastPropValue<V>(Prop<V>? prop) {
  if (prop == null) return null;
  if (prop.$directives?.isNotEmpty ?? false) {
    throw StateError('Fortal scalar projection cannot drop Prop directives.');
  }
  V? result;
  for (final source in prop.sources) {
    result = switch (source) {
      ValueSource<V>(:final value) => value,
      TokenSource<V>(:final token) => token(),
      MixSource<V>() => throw StateError(
        'Fortal scalar projection requires literal or token sources.',
      ),
    };
  }

  return result;
}

FlexBoxStyler _menuTriggerFlex(
  RemixMenuStyler style,
  Prop<StyleSpec<FlexBoxSpec>>? Function(dynamic value) property,
) {
  return _projectLeaf<RemixMenuSpec, FlexBoxSpec>(style, (value) {
        final trigger = _nestedStyle<RemixMenuTriggerSpec>(value.$trigger);

        return trigger == null ? null : property(trigger);
      }, (variants) => FlexBoxStyler(variants: variants))
      as FlexBoxStyler;
}

TextStyler _menuTriggerText(
  RemixMenuStyler style,
  Prop<StyleSpec<TextSpec>>? Function(dynamic value) property,
) {
  return _projectLeaf<RemixMenuSpec, TextSpec>(style, (value) {
        final trigger = _nestedStyle<RemixMenuTriggerSpec>(value.$trigger);

        return trigger == null ? null : property(trigger);
      }, (variants) => TextStyler(variants: variants))
      as TextStyler;
}

IconStyler _menuTriggerIcon(
  RemixMenuStyler style,
  Prop<StyleSpec<IconSpec>>? Function(dynamic value) property,
) {
  return _projectLeaf<RemixMenuSpec, IconSpec>(style, (value) {
        final trigger = _nestedStyle<RemixMenuTriggerSpec>(value.$trigger);

        return trigger == null ? null : property(trigger);
      }, (variants) => IconStyler(variants: variants))
      as IconStyler;
}

FlexBoxStyler _selectTriggerFlex(
  RemixSelectStyler style,
  Prop<StyleSpec<FlexBoxSpec>>? Function(dynamic value) property,
) {
  return _projectLeaf<RemixSelectSpec, FlexBoxSpec>(style, (value) {
        final trigger = _nestedStyle<RemixSelectTriggerSpec>(value.$trigger);

        return trigger == null ? null : property(trigger);
      }, (variants) => FlexBoxStyler(variants: variants))
      as FlexBoxStyler;
}

TextStyler _selectTriggerText(
  RemixSelectStyler style,
  Prop<StyleSpec<TextSpec>>? Function(dynamic value) property,
) {
  return _projectLeaf<RemixSelectSpec, TextSpec>(style, (value) {
        final trigger = _nestedStyle<RemixSelectTriggerSpec>(value.$trigger);

        return trigger == null ? null : property(trigger);
      }, (variants) => TextStyler(variants: variants))
      as TextStyler;
}

IconStyler _selectTriggerIcon(
  RemixSelectStyler style,
  Prop<StyleSpec<IconSpec>>? Function(dynamic value) property,
) {
  return _projectLeaf<RemixSelectSpec, IconSpec>(style, (value) {
        final trigger = _nestedStyle<RemixSelectTriggerSpec>(value.$trigger);

        return trigger == null ? null : property(trigger);
      }, (variants) => IconStyler(variants: variants))
      as IconStyler;
}

Style<S>? _nestedStyle<S extends Spec<S>>(Prop<StyleSpec<S>>? prop) {
  if (prop == null) return null;
  if (prop.$directives?.isNotEmpty ?? false) {
    throw StateError('Fortal nested projection cannot drop Prop directives.');
  }
  Style<S>? result;
  for (final source in prop.sources) {
    if (source is! MixSource<StyleSpec<S>> || source.mix is! Style<S>) {
      throw StateError('Fortal nested styles require Mix style sources.');
    }
    final style = source.mix as Style<S>;
    result = result == null ? style : result.merge(style);
  }

  return result;
}

List<AtlasPortableNode> _tabNodes({
  required String id,
  required bool selected,
  required String labelProperty,
  required ComponentVisibilityCondition visibleWhen,
}) {
  final suffix = selected ? 'Selected' : 'Default';
  final frame =
      '$id'
      'Frame$suffix';
  final tab =
      '$id'
      'Tab$suffix';
  final label =
      '$id'
      'Label$suffix';

  return [
    _node(frame, .box, frame, [tab], visibleWhen: visibleWhen),
    _node(tab, .flexBox, tab, [label]),
    _node(
      label,
      .text,
      label,
      const [],
      bindings: {'text': AtlasPortableBinding.property(labelProperty)},
    ),
  ];
}

BoxStyler _tabFrame({required bool selected}) {
  return BoxStyler()
      .height(40)
      .paddingX(4)
      .alignment(.center)
      .borderBottom(
        color: selected ? FortalTokens.accent9() : Colors.transparent,
        width: FortalTokens.borderWidth2(),
      );
}

const _callbacksOmitted = ComponentDiagnostic(
  code: 'runtime.callbacks_omitted',
  severity: 'info',
  path: 'semantics',
  message: 'Callbacks are intentionally omitted from portable captures.',
);

const _overlayAndCallbacksOmitted = ComponentDiagnostic(
  code: 'runtime.overlay_omitted',
  severity: 'info',
  path: 'anatomy',
  message: 'Interactive overlay behavior is intentionally not executed.',
);

const _editingAndCallbacksOmitted = ComponentDiagnostic(
  code: 'runtime.editing_omitted',
  severity: 'info',
  path: 'anatomy',
  message: 'Editing, selection, and callbacks are intentionally not executed.',
);

AtlasPortableComponentBuilder _buildComponent(
  ComponentAtlas atlas, {
  List<ComponentPropertyDefinition> properties = const [],
  required List<ComponentSlotDefinition> slots,
  required List<AtlasPortableNode> nodes,
  required String root,
  required _StylesForRow stylesForRow,
  _RecipeProperties recipeProperties = _noRecipeProperties,
  required AtlasPortableSemantics semantics,
  List<ComponentDiagnostic> diagnostics = const [],
}) {
  final builder = AtlasPortableComponentBuilder(
    id: atlas.id,
    label: atlas.label ?? atlas.id,
  );
  for (final axis in atlas.rowAxes) {
    final values = <String>{
      for (final row in atlas.rows) row.values[axis.id]!.id,
    }.toList();
    builder.property(
      ComponentPropertyDefinition(
        id: axis.id,
        kind: .enumeration,
        values: values,
        defaultValue: values.first,
        isRequired: true,
      ),
    );
  }
  for (final property in properties) {
    builder.property(property);
  }
  for (final scenario in atlas.scenarios) {
    builder.state(
      ComponentStateDefinition(
        id: scenario.id,
        label: scenario.label,
        widgetStates: {for (final state in scenario.states) state.name},
        propertyOverrides: scenario.props,
      ),
    );
  }
  for (final slot in slots) {
    builder.slot(slot);
  }
  for (final node in nodes) {
    builder.node(node);
  }
  builder.root(root);
  for (final row in atlas.rows) {
    builder.recipe(
      id: row.id,
      label: row.label,
      properties: {
        for (final axis in atlas.rowAxes) axis.id: row.values[axis.id]!.id,
        ...recipeProperties(row),
      },
      styles: stylesForRow(row),
    );
  }
  builder
    ..semantics(semantics)
    ..oracle(
      ComponentVisualOracle(
        themeId: 'light',
        imagePath: 'light/${atlas.id}.png',
        metadataPath: 'light/${atlas.id}.json',
        evidence: .rendered,
      ),
    )
    ..oracle(
      ComponentVisualOracle(
        themeId: 'dark',
        imagePath: 'dark/${atlas.id}.png',
        metadataPath: 'dark/${atlas.id}.json',
        evidence: .rendered,
      ),
    );
  for (final diagnostic in diagnostics) {
    builder.diagnostic(diagnostic);
  }

  return builder;
}

Map<String, Object?> _noRecipeProperties(AtlasRow _) => const {};

ComponentPropertyDefinition _string(
  String id,
  String defaultValue, {
  List<String>? values,
}) {
  return ComponentPropertyDefinition(
    id: id,
    kind: values == null ? .string : .enumeration,
    values: values ?? const [],
    defaultValue: defaultValue,
    isRequired: true,
  );
}

ComponentPropertyDefinition _boolean(String id, {bool defaultValue = false}) {
  return ComponentPropertyDefinition(
    id: id,
    kind: .boolean,
    defaultValue: defaultValue,
    isRequired: true,
  );
}

ComponentPropertyDefinition _number(String id, double defaultValue) {
  return ComponentPropertyDefinition(
    id: id,
    kind: .number,
    defaultValue: defaultValue,
    isRequired: true,
  );
}

ComponentPropertyDefinition _duration(String id, int milliseconds) {
  return ComponentPropertyDefinition(
    id: id,
    kind: .duration,
    defaultValue: milliseconds,
    isRequired: true,
  );
}

ComponentPropertyDefinition _icon(
  String id,
  String defaultValue, {
  bool isRequired = true,
}) {
  return ComponentPropertyDefinition(
    id: id,
    kind: .icon,
    defaultValue: defaultValue,
    isRequired: isRequired,
  );
}

AtlasPortableSemantics _semantics(
  String role, {
  String? label,
  String? enabled,
  Map<String, AtlasPortableBinding> extra = const {},
}) {
  return AtlasPortableSemantics(
    role: role,
    bindings: {
      if (label != null) 'label': AtlasPortableBinding.property(label),
      if (enabled != null) 'enabled': AtlasPortableBinding.property(enabled),
      ...extra,
    },
  );
}

AtlasPortableNode _node(
  String id,
  ComponentAnatomyNodeKind kind,
  String slot,
  List<String> children, {
  Map<String, AtlasPortableBinding> bindings = const {},
  ComponentVisibilityCondition? visibleWhen,
  Set<String> maintain = const {},
}) {
  return AtlasPortableNode(
    id: id,
    kind: kind,
    slotId: slot,
    children: children,
    bindings: bindings,
    visibleWhen: visibleWhen,
    maintainedFeatures: maintain,
  );
}

ComponentVisibilityCondition _propertyEquals(String property, Object value) {
  return ComponentVisibilityCondition(
    propertyId: property,
    operator: .equals,
    value: value,
  );
}

ComponentVisibilityCondition _propertyPresent(String property) {
  return ComponentVisibilityCondition(propertyId: property, operator: .present);
}

T _enumValue<T extends Enum>(List<T> values, AtlasRow row, String axis) {
  final id = row.values[axis]!.id;

  return values.singleWhere((value) => value.name == id);
}

BoxStyler _box<C extends Spec<C>>(
  Style<C> composite,
  Prop<StyleSpec<BoxSpec>>? Function(dynamic value) property,
) {
  return _projectLeaf<C, BoxSpec>(
        composite,
        property,
        (variants) => BoxStyler(variants: variants),
      )
      as BoxStyler;
}

FlexBoxStyler _flex<C extends Spec<C>>(
  Style<C> composite,
  Prop<StyleSpec<FlexBoxSpec>>? Function(dynamic value) property,
) {
  return _projectLeaf<C, FlexBoxSpec>(
        composite,
        property,
        (variants) => FlexBoxStyler(variants: variants),
      )
      as FlexBoxStyler;
}

TextStyler _text<C extends Spec<C>>(
  Style<C> composite,
  Prop<StyleSpec<TextSpec>>? Function(dynamic value) property,
) {
  return _projectLeaf<C, TextSpec>(
        composite,
        property,
        (variants) => TextStyler(variants: variants),
      )
      as TextStyler;
}

IconStyler _iconStyle<C extends Spec<C>>(
  Style<C> composite,
  Prop<StyleSpec<IconSpec>>? Function(dynamic value) property,
) {
  return _projectLeaf<C, IconSpec>(
        composite,
        property,
        (variants) => IconStyler(variants: variants),
      )
      as IconStyler;
}

Style<L> _projectLeaf<C extends Spec<C>, L extends Spec<L>>(
  Style<C> composite,
  Prop<StyleSpec<L>>? Function(dynamic value) property,
  Style<L> Function(List<VariantStyle<L>> variants) variantStyle, {
  int depth = 0,
}) {
  if (depth > 16) {
    throw StateError('Fortal portable style projection exceeded 16 levels.');
  }
  final prop = property(composite);
  if (prop?.$directives?.isNotEmpty ?? false) {
    throw StateError('Fortal portable styles cannot drop Prop directives.');
  }
  Style<L>? result;
  for (final source in prop?.sources ?? <PropSource<StyleSpec<L>>>[]) {
    if (source is! MixSource<StyleSpec<L>> || source.mix is! Style<L>) {
      throw StateError(
        'Fortal portable styles require built-in Mix leaf sources.',
      );
    }
    final leaf = source.mix as Style<L>;
    result = result == null ? leaf : result.merge(leaf);
  }
  final variants = <VariantStyle<L>>[];
  for (final variant in composite.$variants ?? <VariantStyle<C>>[]) {
    variants.add(
      VariantStyle(
        variant.variant,
        _projectLeaf<C, L>(
          variant.value,
          property,
          variantStyle,
          depth: depth + 1,
        ),
      ),
    );
  }
  if (variants.isNotEmpty) {
    final projectedVariants = variantStyle(variants);
    result = result == null
        ? projectedVariants
        : result.merge(projectedVariants);
  }

  return result ?? variantStyle(const []);
}
