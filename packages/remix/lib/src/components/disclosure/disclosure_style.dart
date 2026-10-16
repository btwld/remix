part of 'disclosure.dart';

final _onExpandedDisclosureVariant = ContextVariant(
  'onExpanded',
  (context) => NakedDisclosureState.maybeOf(context)?.isExpanded ?? false,
);

final _onCollapsedDisclosureVariant = ContextVariant(
  'onCollapsed',
  (context) => !(NakedDisclosureState.maybeOf(context)?.isExpanded ?? false),
);

extension RemixDisclosureStylerRemixHelpers on DisclosureStyler {
  DisclosureStyler onExpanded(DisclosureStyler value) {
    return variant(_onExpandedDisclosureVariant, value);
  }

  DisclosureStyler onCollapsed(DisclosureStyler value) {
    return variant(_onCollapsedDisclosureVariant, value);
  }
}
