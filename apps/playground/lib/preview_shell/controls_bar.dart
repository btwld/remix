import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../ui/ui.dart';
import 'presets.dart';

/// Chrome above the preview viewport.
///
/// This sits outside the viewport's own app host, so it cannot reach a Material
/// ancestor and is built from the playground's installed recipes instead. That
/// is also the point: the shell dogfoods the same source `remix add` installs.
class ControlsBar extends StatelessWidget {
  const ControlsBar({
    super.key,
    required this.brightness,
    required this.size,
    required this.onChange,
  });

  final Brightness brightness;
  final Size size;

  final void Function({Brightness? brightness, Size? size}) onChange;

  @override
  Widget build(BuildContext context) {
    final previewControls = <Widget>[
      PlaygroundSegmentedControl<Brightness>(
        items: const [
          RemixSegmentedControlItem(value: Brightness.light, label: 'Light'),
          RemixSegmentedControlItem(value: Brightness.dark, label: 'Dark'),
        ],
        selectedValue: brightness,
        onChanged: (selection) => onChange(brightness: selection),
      ),
      const SizedBox(width: 16),
      _PresetChip(
        label: 'Mobile',
        onTap: () => onChange(size: ViewportPresets.mobile),
      ),
      const SizedBox(width: 8),
      _PresetChip(
        label: 'Tablet',
        onTap: () => onChange(size: ViewportPresets.tablet),
      ),
      const SizedBox(width: 8),
      _PresetChip(
        label: 'Desktop',
        onTap: () => onChange(size: ViewportPresets.desktop),
      ),
    ];
    final sizeControls = <Widget>[
      const Text('W', style: _labelStyle),
      const SizedBox(width: 6),
      _SizeField(
        initial: size.width.round(),
        onSubmitted: (w) =>
            onChange(size: Size(w.toDouble().clamp(200, 3000), size.height)),
      ),
      const SizedBox(width: 12),
      const Text('H', style: _labelStyle),
      const SizedBox(width: 6),
      _SizeField(
        initial: size.height.round(),
        onSubmitted: (h) =>
            onChange(size: Size(size.width, h.toDouble().clamp(200, 3000))),
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(bottom: BorderSide(color: Color(0x1F000000))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >=
                900 * MediaQuery.textScalerOf(context).scale(1)) {
              return Row(
                children: [...previewControls, const Spacer(), ...sizeControls],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: previewControls),
                ),
                const SizedBox(height: 8),
                Row(children: sizeControls),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Matches the label role Material's `labelMedium` filled before the migration.
const _labelStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Color(0xFF1C2024),
);

class _PresetChip extends StatelessWidget {
  const _PresetChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PlaygroundButton(
      variant: .outline,
      size: .small,
      label: label,
      onPressed: onTap,
    );
  }
}

class _SizeField extends StatefulWidget {
  const _SizeField({required this.initial, required this.onSubmitted});

  final int initial;
  final ValueChanged<int> onSubmitted;

  @override
  State<_SizeField> createState() => _SizeFieldState();
}

class _SizeFieldState extends State<_SizeField> {
  late final controller = TextEditingController(
    text: widget.initial.toString(),
  );

  @override
  void didUpdateWidget(_SizeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial) {
      controller.text = widget.initial.toString();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: PlaygroundTextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onSubmitted: (text) {
          final value = int.tryParse(text);
          if (value != null) {
            widget.onSubmitted(value);
          }
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }
}
