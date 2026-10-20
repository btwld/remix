import 'package:demo/helpers/catalog.dart';
import 'package:demo/helpers/use_case_state.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Remix', type: RemixDisclosure)
Widget buildRemixDisclosureUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 360,
        child: RemixDisclosure(
          defaultExpanded: true,
          trigger: const Text('When will my order arrive?'),
          content: const Text(
            'Standard delivery takes 3–5 business days. Tracking is sent '
            'as soon as your order leaves the warehouse.',
          ),
          triggerBuilder: (context, state, child) =>
              _DisclosureTrigger(expanded: state.isExpanded, child: child!),
          style: _remixDisclosureStyle(),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Fortal', type: RemixDisclosure)
Widget buildFortalDisclosureUseCase(BuildContext context) {
  final knobState = WidgetbookState.of(context);
  final expanded = context.knobs.boolean(label: 'Expanded', initialValue: true);

  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 360,
        child: FortalDisclosure(
          expanded: expanded,
          onExpandedChanged: (value) {
            knobState.updateKnob('Expanded', value);
          },
          enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
          variant: context.knobs.object.dropdown(
            label: 'Variant',
            options: FortalDisclosureVariant.values,
            labelBuilder: (variant) => variant.name,
            initialOption: FortalDisclosureVariant.surface,
          ),
          size: context.knobs.object.dropdown(
            label: 'Size',
            options: FortalDisclosureSize.values,
            labelBuilder: (size) => size.name,
            initialOption: FortalDisclosureSize.size2,
          ),
          trigger: const Text('Account details'),
          content: const Text(
            'Your profile, contact information, and preferences are kept '
            'together in this section.',
          ),
          triggerBuilder: (context, state, child) =>
              _DisclosureTrigger(expanded: state.isExpanded, child: child!),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Catalog', type: RemixDisclosure)
Widget buildDisclosureCatalogUseCase(BuildContext context) {
  return CatalogMatrix(
    cellWidth: 300,
    columns: labelsOf(FortalDisclosureSize.values),
    rows: labelsOf(FortalDisclosureVariant.values),
    cell: (row, column) => SizedBox(
      width: 280,
      child: FortalDisclosure(
        defaultExpanded: true,
        variant: FortalDisclosureVariant.values[row],
        size: FortalDisclosureSize.values[column],
        trigger: const Text('Shipping details'),
        content: const Text('Delivery takes 3–5 business days.'),
        triggerBuilder: (context, state, child) =>
            _DisclosureTrigger(expanded: state.isExpanded, child: child!),
      ),
    ),
  );
}

DisclosureStyler _remixDisclosureStyle() {
  final border = BorderSideMix(color: FortalTokens.gray6(), width: 1);

  return DisclosureStyler()
      .container(
        BoxStyler()
            .clipBehavior(.antiAlias)
            .borderRadius(.circular(12))
            .border(.all(border))
            .color(FortalTokens.colorSurface()),
      )
      .trigger(
        BoxStyler()
            .width(.infinity)
            .alignment(.centerLeft)
            .padding(.all(16))
            .color(FortalTokens.gray2()),
      )
      .content(
        BoxStyler()
            .width(.infinity)
            .padding(.all(16))
            .foregroundDecoration(
              BoxDecorationMix(border: BoxBorderMix.top(border)),
            ),
      )
      .onHovered(
        DisclosureStyler().trigger(BoxStyler().color(FortalTokens.gray3())),
      )
      .onPressed(
        DisclosureStyler().trigger(BoxStyler().color(FortalTokens.gray4())),
      )
      .onFocusVisible(
        DisclosureStyler().trigger(
          BoxStyler().border(
            .all(BorderSideMix(color: FortalTokens.accent9(), width: 2)),
          ),
        ),
      )
      .onDisabled(
        DisclosureStyler().trigger(BoxStyler().color(FortalTokens.gray3())),
      );
}

class _DisclosureTrigger extends StatelessWidget {
  const _DisclosureTrigger({required this.expanded, required this.child});

  final bool expanded;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: child),
        AnimatedRotation(
          turns: expanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ],
    );
  }
}
