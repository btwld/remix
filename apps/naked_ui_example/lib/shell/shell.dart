import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

import 'package:naked_ui/naked_ui.dart';

import '../registry.dart';
import '../src/example_button.dart';

const _chrome = Color(0xFFE7E0EC);
const _border = Color(0xFFCAC4D0);
const _selectedTint = Color(0x143D3D3D);

class KitchenShell extends StatefulWidget {
  const KitchenShell({super.key, this.initialDemoId, this.embed = false});

  final String? initialDemoId;
  final bool embed;

  @override
  State<KitchenShell> createState() => _KitchenShellState();
}

class _KitchenShellState extends State<KitchenShell> {
  String _filter = '';
  Demo? _selected;

  @override
  void initState() {
    super.initState();
    if (widget.initialDemoId != null) {
      _selected = DemoRegistry.find(widget.initialDemoId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embed) {
      final demo = _selected ?? DemoRegistry.demos.first;
      return _DemoScaffold(demo: demo, embed: true);
    }

    final categories = DemoRegistry.byCategory();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The shell hosts on WidgetsApp, so this stands in for AppBar.
        ColoredBox(
          color: _chrome,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: const Text(
              'Naked Kitchen Sink',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 320,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: _border),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: NakedTextField(
                                    onChanged: (v) => setState(
                                      () => _filter = v.toLowerCase(),
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                    cursorColor: const Color(0xFF3D3D3D),
                                    builder: (context, state, editableText) =>
                                        editableText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          for (final entry in categories.entries)
                            _CategoryList(
                              title: entry.key,
                              demos: entry.value
                                  .where(
                                    (d) =>
                                        _filter.isEmpty ||
                                        d.title.toLowerCase().contains(
                                          _filter,
                                        ) ||
                                        d.tags.any((t) => t.contains(_filter)),
                                  )
                                  .toList(),
                              onTap: (demo) {
                                setState(() => _selected = demo);
                              },
                              selectedId: _selected?.id,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 1,
                child: ColoredBox(color: _border, child: SizedBox.expand()),
              ),
              Expanded(
                child: _DemoScaffold(
                  demo: _selected ?? DemoRegistry.demos.first,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.title,
    required this.demos,
    required this.onTap,
    this.selectedId,
  });

  final String title;
  final List<Demo> demos;
  final ValueChanged<Demo> onTap;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    if (demos.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        for (final d in demos)
          NakedButton(
            onPressed: () => onTap(d),
            builder: (context, state, child) => ColoredBox(
              color: d.id == selectedId
                  ? _selectedTint
                  : state.isHovered
                  ? const Color(0x0A3D3D3D)
                  : const Color(0x00000000),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(d.title, style: const TextStyle(fontSize: 14)),
              ),
            ),
          ),
      ],
    );
  }
}

class _DemoScaffold extends StatelessWidget {
  const _DemoScaffold({required this.demo, this.embed = false});

  final Demo demo;
  final bool embed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!embed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: _chrome,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    demo.title,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ExampleButton(
                  label: 'Fullscreen',
                  subtle: true,
                  onPressed: () {
                    final uri = Uri(path: '/#/${'component'}/${demo.id}');
                    // On the web this opens the gh-pages URL; locally it’s fine.
                    debugPrint(uri.toString());
                  },
                ),
                if (demo.sourceUrl != null)
                  ExampleButton(
                    label: 'Source',
                    subtle: true,
                    onPressed: () {
                      // A real app might use url_launcher; we avoid runtime deps here.
                      debugPrint('Source: ${demo.sourceUrl}');
                    },
                  ),
              ],
            ),
          ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: demo.builder(context),
            ),
          ),
        ),
      ],
    );
  }
}
