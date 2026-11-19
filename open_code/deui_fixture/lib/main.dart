import 'package:flutter/widgets.dart';

import 'ui/ui.dart';

/// Runs a small application composed entirely from installed Deui source.
void main() => runApp(const AcmeApp());

/// A review gallery of every installed Deui recipe, in the system's mode.
class AcmeApp extends StatelessWidget {
  /// Creates the example application.
  const AcmeApp({super.key, this.mode});

  /// The appearance to show; null follows the system.
  final AcmeThemeMode? mode;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFFFCFCFC),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      debugShowCheckedModeBanner: false,
      home: AcmeTheme(mode: mode, child: const AcmeGallery()),
    );
  }
}

/// Every Deui recipe once, as a consumer would compose them.
class AcmeGallery extends StatefulWidget {
  /// Creates the gallery.
  const AcmeGallery({super.key});

  @override
  State<AcmeGallery> createState() => _AcmeGalleryState();
}

class _AcmeGalleryState extends State<AcmeGallery> {
  bool _on = true;
  bool? _checked = true;
  String? _choice = 'Claude';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final variant in AcmeButtonVariant.values)
            AcmeButton(
              label: variant.name,
              variant: variant,
              onPressed: () {},
            ),
          AcmeButton(label: 'Large', size: .large, onPressed: () {}),
          AcmeButton(label: 'Small', size: .small, onPressed: () {}),
          AcmeButton(label: 'Loading', loading: true, onPressed: () {}),
          const AcmeButton(label: 'Disabled'),
          for (final color in AcmeColor.values)
            AcmeBadge(color: color, label: color.name),
          SizedBox(
            width: 280,
            child: AcmeTextField(hintText: 'Ask anything', onChanged: (_) {}),
          ),
          AcmeSwitch(
            selected: _on,
            label: 'Switch',
            onChanged: (value) => setState(() => _on = value),
          ),
          AcmeCheckbox(
            selected: _checked,
            label: 'Checkbox',
            onChanged: (value) => setState(() => _checked = value),
          ),
          const AcmeSpinner(),
          const SizedBox(width: 160, child: AcmeProgress(value: .4)),
          const AcmeAvatar(label: 'D'),
          const AcmeSkeleton(),
          for (final status in AcmeAlertStatus.values)
            SizedBox(
              width: 280,
              child: AcmeAlert(text: status.name),
            ),
          Text(_choice ?? ''),
        ],
      ),
    );
  }
}
