import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by Alignui
// https://www.alignui.com/docs/v1.2/ui/dropdown

void main() {
  // Enable semantics for web testing/automation
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: deprecated_member_use
  WidgetsBinding.instance.ensureSemantics();

  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: MenuExample(),
      ),
    ),
  );
}

class MenuExample extends StatefulWidget {
  const MenuExample({super.key});

  @override
  State<MenuExample> createState() => _MenuExampleState();
}

class _MenuExampleState extends State<MenuExample> {
  final controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // RemixMenu
          RemixMenu<String>(
            trigger: const RemixMenuTrigger(label: 'Open Remix Menu'),
            items: const [
              RemixMenuItem(
                value: 'History',
                leadingIcon: Icons.history,
                label: 'History',
              ),
              RemixMenuItem(
                value: 'Settings',
                leadingIcon: Icons.settings,
                label: 'Settings',
              ),
              RemixMenuDivider(),
              RemixMenuItem(
                value: 'Logout',
                leadingIcon: Icons.logout,
                label: 'Logout',
              ),
            ],
            positioning: const OverlayPositionConfig(
              offset: Offset(0, 8),
              followerAnchor: Alignment.topCenter,
              targetAnchor: Alignment.bottomCenter,
            ),
            style: menuStyle,
            onSelected: (value) {
              // ignore: avoid_print
              print('RemixMenu: $value');
            },
            controller: controller,
          ),
          const SizedBox(height: 40),
          // Material PopupMenuButton for comparison
          PopupMenuButton<String>(
            onSelected: (value) {
              // ignore: avoid_print
              print('Material Menu: $value');
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'History', child: Text('History')),
              PopupMenuItem(value: 'Settings', child: Text('Settings')),
              PopupMenuDivider(),
              PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
            child: const Text('Open Material Menu'),
          ),
        ],
      ),
    );
  }

  RemixMenuStyle get menuStyle {
    return RemixMenuStyle()
        .trigger(
          RemixMenuTriggerStyle()
              .padding(EdgeInsetsMix.symmetric(horizontal: 14))
              .decoration(
                BoxDecorationMix()
                    .color(Colors.white)
                    .borderRadius(
                        BorderRadiusMix.all(const Radius.circular(12)))
                    .border(BorderMix.all(
                        BorderSideMix(color: Colors.blueGrey.shade100)))
                    .boxShadow([
                  BoxShadowMix(
                    color: Colors.blueGrey.withValues(alpha: 0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ]),
              )
              .constraints(BoxConstraintsMix(minHeight: 40))
              .label(
                TextStyler()
                    .color(Colors.blueGrey.shade700)
                    .fontWeight(FontWeight.w400),
              )
              .onHovered(
                RemixMenuTriggerStyle().color(Colors.red),
              ),
        )
        .overlay(
          FlexBoxStyler(
            padding: EdgeInsetsMix.all(12),
            decoration: BoxDecorationMix(
              color: Colors.white,
              borderRadius: BorderRadiusMix.all(const Radius.circular(12)),
              border: BorderMix.all(
                BorderSideMix(color: Colors.blueGrey.shade100),
              ),
              boxShadow: [
                BoxShadowMix(
                  color: Colors.blueGrey.withValues(alpha: 0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        )
        .item(menuItemStyle)
        .divider(
          RemixDividerStyle()
              .color(Colors.blueGrey.shade100)
              .height(1)
              .marginY(6),
        );
  }

  RemixMenuItemStyle get menuItemStyle {
    return RemixMenuItemStyle()
        .paddingAll(6)
        .leadingIcon(IconStyler().size(20).color(Colors.blueGrey.shade800))
        .spacing(8)
        .borderRadiusAll(const Radius.circular(8))
        .label(TextStyler().color(Colors.blueGrey.shade800))
        .onHovered(
          RemixMenuItemStyle().color(Colors.blueGrey.shade50),
        );
  }
}
