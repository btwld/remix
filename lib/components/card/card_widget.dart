part of 'card.dart';

class RxCard extends StatelessWidget {
  const RxCard({
    super.key,
    required this.children,
    this.type = CardVariant.solid,
    this.style,
  });

  /// The list of child widgets to be displayed inside the card.
  final List<Widget> children;

  final CardVariant type;

  /// Additional custom styling for the card.
  ///
  /// This allows you to override or extend the default card styling.
  final Style? style;

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      style: _buildCustomCardStyle(style, [type]),
      builder: (context) {
        final spec = CardSpec.of(context);

        return spec.container(
          child: spec.flex(
            direction: Axis.vertical,
            children: children,
          ),
        );
      },
    );
  }
}
