import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by Gov UK Design System
// https://design-system.service.gov.uk/components/tabs/

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: TabsExample(),
      ),
    ),
  );
}

class TabsExample extends StatefulWidget {
  const TabsExample({super.key});

  @override
  State<TabsExample> createState() => _TabsExampleState();
}

class _TabsExampleState extends State<TabsExample> {
  String _tab = 'tab1';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: RemixTabs(
          selectedTabId: _tab,
          onChanged: (id) => setState(() => _tab = id),
          style: style,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RemixTabBar(
                child: Row(
                  children: [
                    RemixTab(
                      tabId: 'tab1',
                      style: tabStyle,
                      child: const Text('Tab 1'),
                    ),
                    RemixTab(
                      tabId: 'tab2',
                      style: tabStyle,
                      child: const Text('Tab 2'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RemixTabsStyle get style {
    return RemixTabsStyle().color(Colors.blue).tab(RemixTabStyle()
        .container(FlexBoxStyler().color(Colors.red).size(100, 100)));
  }

  RemixTabStyle get tabStyle {
    return RemixTabStyle()
        .container(FlexBoxStyler().color(Colors.red).size(100, 100))
        .label(TextStyler().color(Colors.white));
  }
}
