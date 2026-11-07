import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import 'ui/ui.dart';

void main() => runApp(const SampleApp());

class SampleApp extends StatefulWidget {
  const SampleApp({super.key});

  @override
  State<SampleApp> createState() => _SampleAppState();
}

class _SampleAppState extends State<SampleApp> {
  AcmeThemeMode mode = AcmeThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Launchpad — fortal preset',
      color: const Color(0xFFF8FAFC),
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      builder: (context, child) => AcmeTheme(
        theme: const AcmeThemeData.light(accent: AcmeAccentColor.mar),
        darkTheme: const AcmeThemeData.dark(accent: AcmeAccentColor.mar),
        mode: mode,
        child: Builder(
          builder: (context) {
            final dark = AcmeTheme.of(context).brightness == Brightness.dark;
            return DefaultTextStyle(
              style: TextStyle(
                fontFamily: RemixFonts.geist,
                fontSize: 14,
                color: dark ? const Color(0xFFF1F1F1) : const Color(0xFF202020),
              ),
              child: child!,
            );
          },
        ),
      ),
      home: Builder(
        builder: (context) {
          final dark = AcmeTheme.of(context).brightness == Brightness.dark;
          return WorkspacePage(
            dark: dark,
            onTheme: () => setState(
              () => mode = dark ? AcmeThemeMode.light : AcmeThemeMode.dark,
            ),
          );
        },
      ),
    );
  }
}

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key, required this.dark, required this.onTheme});
  final bool dark;
  final VoidCallback onTheme;

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  final name = TextEditingController(text: 'Launchpad');
  bool summary = true;
  bool saving = false;
  int saves = 0;
  String destination = 'settings';
  String status = 'No changes saved yet.';

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  Future<void> save() async {
    setState(() => saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      saving = false;
      saves += 1;
      status =
          'Saved ${name.text}. Save count: $saves. Summary: ${summary ? 'on' : 'off'}.';
    });
  }

  Future<void> invite() async {
    final confirmed = await showRemixDialog<bool>(
      context: context,
      barrierLabel: 'Close invitation preview',
      builder: (context) => Center(
        child: AcmeDialog(
          title: 'Invite a teammate',
          description:
              'This sample records your choice locally. It sends no invitation.',
          actions: [
            AcmeButton.outline(
              label: 'Cancel',
              onPressed: () => Navigator.pop(context, false),
            ),
            AcmeButton.solid(
              label: 'Confirm',
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true && mounted) {
      setState(() => status = 'Invitation confirmed in this sample.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final foreground = widget.dark
        ? const Color(0xFFFAFAFA)
        : const Color(0xFF171717);
    final muted = widget.dark
        ? const Color(0xFFA3A3A3)
        : const Color(0xFF737373);
    final background = widget.dark
        ? const Color(0xFF0A0A0A)
        : const Color(0xFFFAFAFA);
    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: RemixFonts.geist,
        color: foreground,
        fontSize: 15,
        height: 1.5,
      ),
      child: ColoredBox(
        color: background,
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 230,
                child: AcmeSidebar<String>(
                  semanticLabel: 'Workspace navigation',
                  style: SidebarStyler().sectionLabel(
                    TextStyler().fontFamily(RemixFonts.geist),
                  ),
                  header: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'LAUNCHPAD',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  sections: const [
                    RemixSidebarSection(
                      label: 'WORKSPACE',
                      destinations: [
                        RemixSidebarDestination(
                          value: 'overview',
                          label: 'Overview',
                        ),
                        RemixSidebarDestination(
                          value: 'settings',
                          label: 'Settings',
                        ),
                        RemixSidebarDestination(
                          value: 'billing',
                          label: 'Billing',
                          enabled: false,
                        ),
                      ],
                    ),
                  ],
                  selectedValue: destination,
                  onSelected: (value) => setState(() => destination = value),
                  footer: Text(
                    'fortal preset\nApplication-owned source',
                    style: TextStyle(fontSize: 12, color: muted),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 44,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 820),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'WORKSPACE / ${destination.toUpperCase()}',
                                  style: TextStyle(
                                    color: muted,
                                    fontSize: 12,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              AcmeButton.outline(
                                label: widget.dark
                                    ? 'Use light theme'
                                    : 'Use dark theme',
                                onPressed: widget.onTheme,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text(
                            destination == 'settings'
                                ? 'Workspace settings'
                                : 'Workspace overview',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'A real Flutter application built from the fortal preset.',
                            style: TextStyle(color: muted),
                          ),
                          const SizedBox(height: 32),
                          AcmeCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'General',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Set the workspace name and your email preference.',
                                  style: TextStyle(color: muted),
                                ),
                                const SizedBox(height: 24),
                                AcmeTextField(
                                  controller: name,
                                  label: 'Workspace name',
                                  semanticLabel: 'Workspace name',
                                  helperText:
                                      'The application owns this text field recipe.',
                                ),
                                const SizedBox(height: 16),
                                AcmeCheckbox(
                                  label: 'Send a weekly summary',
                                  selected: summary,
                                  onChanged: (value) =>
                                      setState(() => summary = value ?? false),
                                ),
                                const SizedBox(height: 24),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    AcmeButton.solid(
                                      label: 'Save changes',
                                      loading: saving,
                                      onPressed: save,
                                    ),
                                    AcmeButton.outline(
                                      label: 'Preview invitation',
                                      onPressed: invite,
                                    ),
                                    AcmeButton.outline(
                                      label: 'Delete workspace',
                                      enabled: false,
                                      onPressed: () => setState(
                                        () => status =
                                            'ERROR: disabled action ran.',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          AcmeCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'One instance override',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'This button uses the same recipe with a local style override.',
                                  style: TextStyle(color: muted),
                                ),
                                const SizedBox(height: 20),
                                AcmeButton.solid(
                                  label: 'Run preview',
                                  style: ButtonStyler()
                                      .color(const Color(0xFF0E7490))
                                      .label(.color(const Color(0xFFFFFFFF)))
                                      .onPressed(
                                        ButtonStyler().color(
                                          const Color(0xFF164E63),
                                        ),
                                      )
                                      .onHovered(
                                        ButtonStyler().color(
                                          const Color(0xFF155E75),
                                        ),
                                      )
                                      .borderRadius(
                                        .all(const Radius.circular(999)),
                                      ),
                                  onPressed: () => setState(
                                    () => status =
                                        'Preview completed. The instance override keeps the callback.',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Source: lib/ui/  ·  Config: remix.yaml  ·  Preset: fortal',
                            style: TextStyle(color: muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
