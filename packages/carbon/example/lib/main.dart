import 'package:carbon/carbon.dart';
import 'package:flutter/material.dart';

void main() => runApp(const CarbonGalleryApp());

class CarbonGalleryApp extends StatelessWidget {
  const CarbonGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Carbon for Flutter',
      debugShowCheckedModeBanner: false,
      home: CarbonGalleryPage(),
    );
  }
}

class CarbonGalleryPage extends StatefulWidget {
  const CarbonGalleryPage({super.key});

  @override
  State<CarbonGalleryPage> createState() => _CarbonGalleryPageState();
}

class _CarbonGalleryPageState extends State<CarbonGalleryPage> {
  CarbonTheme _theme = CarbonTheme.white;
  CarbonSize _size = CarbonSize.lg;
  bool _loading = false;

  // Demo-only backgrounds pulled from the primitive palette so the page chrome
  // tracks the selected theme.
  Color get _background => switch (_theme) {
        CarbonTheme.white => CarbonPalette.white,
        CarbonTheme.g10 => CarbonPalette.gray10,
        CarbonTheme.g90 => CarbonPalette.gray90,
        CarbonTheme.g100 => CarbonPalette.gray100,
      };

  Color get _onBackground =>
      _theme.isDark ? CarbonPalette.gray10 : CarbonPalette.gray100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: CarbonScope(
          theme: _theme,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Carbon for Flutter',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: _onBackground)),
                const SizedBox(height: 4),
                Text('Foundation + Button vertical slice',
                    style: TextStyle(fontSize: 14, color: _onBackground)),
                const SizedBox(height: 24),
                _controls(),
                const SizedBox(height: 24),
                _sectionTitle('Button kinds'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final kind in CarbonButtonKind.values)
                      CarbonButton(
                        label: _kindLabel(kind),
                        kind: kind,
                        size: _size,
                        loading: _loading,
                        onPressed: () {},
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                _sectionTitle('Disabled'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final kind in [
                      CarbonButtonKind.primary,
                      CarbonButtonKind.secondary,
                      CarbonButtonKind.tertiary,
                      CarbonButtonKind.ghost,
                    ])
                      CarbonButton(
                        label: _kindLabel(kind),
                        kind: kind,
                        size: _size,
                        onPressed: null,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _controls() {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _labeled(
          'Theme',
          DropdownButton<CarbonTheme>(
            value: _theme,
            dropdownColor: _background,
            style: TextStyle(color: _onBackground),
            onChanged: (v) => setState(() => _theme = v ?? _theme),
            items: [
              for (final t in CarbonTheme.values)
                DropdownMenuItem(value: t, child: Text(t.name)),
            ],
          ),
        ),
        _labeled(
          'Size',
          DropdownButton<CarbonSize>(
            value: _size,
            dropdownColor: _background,
            style: TextStyle(color: _onBackground),
            onChanged: (v) => setState(() => _size = v ?? _size),
            items: [
              for (final s in CarbonSize.values)
                DropdownMenuItem(value: s, child: Text(s.name)),
            ],
          ),
        ),
        _labeled(
          'Loading',
          Switch(
            value: _loading,
            onChanged: (v) => setState(() => _loading = v),
          ),
        ),
      ],
    );
  }

  Widget _labeled(String label, Widget child) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: TextStyle(color: _onBackground)),
        child,
      ],
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: _onBackground),
      );

  String _kindLabel(CarbonButtonKind kind) => switch (kind) {
        CarbonButtonKind.primary => 'Primary',
        CarbonButtonKind.secondary => 'Secondary',
        CarbonButtonKind.tertiary => 'Tertiary',
        CarbonButtonKind.ghost => 'Ghost',
        CarbonButtonKind.danger => 'Danger',
        CarbonButtonKind.dangerTertiary => 'Danger tertiary',
        CarbonButtonKind.dangerGhost => 'Danger ghost',
      };
}
