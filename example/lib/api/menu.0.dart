import 'package:flutter/material.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

// Inspired by Alignui
// https://www.alignui.com/docs/v1.2/ui/dropdown

void main() {
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
      child: RemixMenu(
        positioning: const OverlayPositionConfig(
          offset: Offset(0, 8),
          followerAnchor: Alignment.topCenter,
          targetAnchor: Alignment.bottomCenter,
        ),
        overlayBuilder: (BuildContext context, RawMenuOverlayInfo info) {
          return RemixCard(
            style: RemixCardStyle()
                .color(Colors.white)
                .borderRadiusAll(const Radius.circular(12))
                .borderAll(color: Colors.blueGrey.shade100)
                .width(info.anchorRect.width * 1.5)
                .paddingAll(12)
                .shadow(
                  BoxShadowMix()
                      .color(Colors.blueGrey.withValues(alpha: 0.1))
                      .blurRadius(3)
                      .offset(const Offset(0, 3)),
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RemixMenuItem(
                  value: 'History',
                  leadingIcon: Icons.history,
                  label: 'History',
                  style: menuItemStyle,
                ),
                RemixMenuItem(
                  value: 'Settings',
                  leadingIcon: Icons.settings,
                  label: 'Settings',
                  style: menuItemStyle,
                ),
                RemixDivider(
                  style: RemixDividerStyle()
                      .color(Colors.blueGrey.shade100)
                      .height(1)
                      .marginY(6),
                ),
                RemixMenuItem(
                  value: 'Logout',
                  leadingIcon: Icons.logout,
                  label: 'Logout',
                  style: menuItemStyle
                      .leadingIcon(IconStyler().color(Colors.redAccent))
                      .onHovered(RemixMenuItemStyle()
                          .color(Colors.redAccent.withValues(alpha: 0.1))),
                ),
              ],
            ),
          );
        },
        onSelected: (value) {
          print(value);
        },
        controller: controller,
        child: RemixButton(
          label: 'Open Menu',
          style: RemixButtonStyle()
              .color(Colors.white)
              .height(40)
              .paddingX(14)
              .borderRadiusAll(const Radius.circular(12))
              .borderAll(color: Colors.blueGrey.shade100)
              .labelColor(Colors.blueGrey.shade700)
              .labelFontWeight(FontWeight.w400)
              .shadow(
                BoxShadowMix()
                    .color(Colors.blueGrey.withValues(alpha: 0.1))
                    .blurRadius(3)
                    .offset(const Offset(0, 3)),
              ),
          onPressed: () {
            controller.open();
          },
        ),
      ),
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
