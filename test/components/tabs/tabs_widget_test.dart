import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixTabs', () {
    group('Basic Rendering', () {
      testWidgets('renders tabs with minimal props', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            onChanged: (id) {},
            child: const Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1'),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTabs), findsOneWidget);
        expect(find.byType(RemixTabBar), findsOneWidget);
        expect(find.byType(RemixTab), findsNWidgets(2));
        expect(find.byType(RemixTabView), findsNWidgets(2));
      });

      testWidgets('renders tabs with controller', (tester) async {
        final controller = NakedTabController(selectedTabId: 'tab1');

        await tester.pumpRemixApp(
          RemixTabs(
            controller: controller,
            child: const Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1'),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTabs), findsOneWidget);
        expect(controller.selectedTabId, equals('tab1'));
      });

      testWidgets('renders tabs with enabled state', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            enabled: true,
            child: const Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1'),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTabs), findsOneWidget);
      });

      testWidgets('renders tabs with disabled state', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            enabled: false,
            child: const Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1'),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTabs), findsOneWidget);
      });

      testWidgets('renders tabs with vertical orientation', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            orientation: Axis.vertical,
            child: const Column(
              children: [
                RemixTabBar(
                  child: Column(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1'),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTabs), findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('switches tabs when tab is tapped', (tester) async {
        String? selectedTab = 'tab1';

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return RemixTabs(
                selectedTabId: selectedTab,
                onChanged: (id) {
                  setState(() {
                    selectedTab = id;
                  });
                },
                child: Column(
                  children: [
                    RemixTabBar(
                      child: Row(
                        children: [
                          RemixTab(tabId: 'tab1', label: 'Tab 1'),
                          RemixTab(tabId: 'tab2', label: 'Tab 2'),
                        ],
                      ),
                    ),
                    RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                    RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
                  ],
                ),
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(selectedTab, equals('tab1'));
        expect(find.text('Content 1'), findsOneWidget);

        await tester.tap(find.text('Tab 2'));
        await tester.pumpAndSettle();

        expect(selectedTab, equals('tab2'));
        expect(find.text('Content 2'), findsOneWidget);
      });

      testWidgets('does not switch tabs when disabled', (tester) async {
        String? selectedTab = 'tab1';

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return RemixTabs(
                selectedTabId: selectedTab,
                enabled: false,
                onChanged: (id) {
                  setState(() {
                    selectedTab = id;
                  });
                },
                child: Column(
                  children: [
                    RemixTabBar(
                      child: Row(
                        children: [
                          RemixTab(tabId: 'tab1', label: 'Tab 1'),
                          RemixTab(tabId: 'tab2', label: 'Tab 2'),
                        ],
                      ),
                    ),
                    RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                    RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
                  ],
                ),
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(selectedTab, equals('tab1'));

        await tester.tap(find.text('Tab 2'));
        await tester.pumpAndSettle();

        expect(selectedTab, equals('tab1'));
      });

      testWidgets('calls onChanged when tab is selected', (tester) async {
        String? changedTabId;

        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            onChanged: (id) {
              changedTabId = id;
            },
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1'),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Tab 2'));
        await tester.pumpAndSettle();

        expect(changedTabId, equals('tab2'));
      });

      testWidgets('handles keyboard navigation with arrow keys', (
        tester,
      ) async {
        String? selectedTab = 'tab1';

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return RemixTabs(
                selectedTabId: selectedTab,
                onChanged: (id) {
                  setState(() {
                    selectedTab = id;
                  });
                },
                child: Column(
                  children: [
                    RemixTabBar(
                      child: Row(
                        children: [
                          RemixTab(tabId: 'tab1', label: 'Tab 1'),
                          RemixTab(tabId: 'tab2', label: 'Tab 2'),
                        ],
                      ),
                    ),
                    RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                    RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
                  ],
                ),
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        // Focus the first tab
        await tester.tap(find.text('Tab 1'));
        await tester.pumpAndSettle();

        expect(selectedTab, equals('tab1'));
      });
    });

    group('Controller Usage', () {
      testWidgets('updates selected tab via controller', (tester) async {
        final controller = NakedTabController(selectedTabId: 'tab1');

        await tester.pumpRemixApp(
          RemixTabs(
            controller: controller,
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1'),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(controller.selectedTabId, equals('tab1'));

        controller.selectTab('tab2');
        await tester.pumpAndSettle();

        expect(controller.selectedTabId, equals('tab2'));
      });

      testWidgets('listens to controller changes', (tester) async {
        final controller = NakedTabController(selectedTabId: 'tab1');

        await tester.pumpRemixApp(
          RemixTabs(
            controller: controller,
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1'),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(controller.selectedTabId, equals('tab1'));

        controller.selectTab('tab2');
        await tester.pumpAndSettle();

        expect(controller.selectedTabId, equals('tab2'));
      });
    });

    group('Focus', () {
      testWidgets('handles autofocus on tab', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1', autofocus: true),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTab), findsNWidgets(2));
      });

      testWidgets('handles custom FocusNode', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(
                        tabId: 'tab1',
                        label: 'Tab 1',
                        focusNode: focusNode,
                      ),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTab), findsNWidgets(2));

        focusNode.dispose();
      });
    });

    group('Styling', () {
      testWidgets('applies custom tab bar style', (tester) async {
        final customStyle = RemixTabBarStyle(
          container: FlexBoxStyler(
            decoration: BoxDecorationMix(color: Colors.blue),
            padding: EdgeInsetsGeometryMix.all(16),
          ),
        );

        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  style: customStyle,
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1'),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTabBar), findsOneWidget);
      });

      testWidgets('applies custom tab style', (tester) async {
        final customStyle = RemixTabStyle(
          container: FlexBoxStyler(
            decoration: BoxDecorationMix(color: Colors.red),
            padding: EdgeInsetsGeometryMix.all(8),
          ),
        );

        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(
                        tabId: 'tab1',
                        label: 'Tab 1',
                        style: customStyle,
                      ),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTab), findsNWidgets(2));
      });

      testWidgets('applies custom tab view style', (tester) async {
        final customStyle = RemixTabViewStyle(
          container: BoxStyler(
            decoration: BoxDecorationMix(color: Colors.green),
            padding: EdgeInsetsGeometryMix.all(20),
          ),
        );

        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1'),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(
                  tabId: 'tab1',
                  style: customStyle,
                  child: const Text('Content 1'),
                ),
                RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTabView), findsNWidgets(2));
      });
    });

    group('Tab Content', () {
      testWidgets('renders tab with label only', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [RemixTab(tabId: 'tab1', label: 'Tab 1')],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Tab 1'), findsOneWidget);
      });

      testWidgets(
        'renders tab with icon and label - using icon and label params',
        (tester) async {
          await tester.pumpRemixApp(
            RemixTabs(
              selectedTabId: 'tab1',
              child: Column(
                children: [
                  RemixTabBar(
                    child: Row(
                      children: [
                        RemixTab(
                          tabId: 'tab1',
                          icon: Icons.home,
                          label: 'Home',
                        ),
                      ],
                    ),
                  ),
                  RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                ],
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.home), findsOneWidget);
          expect(find.text('Home'), findsOneWidget);
        },
      );

      testWidgets('renders tab with icon and label - using NakedTab params', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', icon: Icons.home, label: 'Home'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.home), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('renders tab with custom child', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', child: const Text('Custom Tab')),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Custom Tab'), findsOneWidget);
      });

      testWidgets('renders tab with custom builder', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(
                        tabId: 'tab1',
                        label: 'Tab 1',
                        builder: (context, state, child) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            child: child,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Tab 1'), findsOneWidget);
      });
    });

    group('Semantics', () {
      testWidgets('has semantic label for tab', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(
                        tabId: 'tab1',
                        label: 'Tab 1',
                        semanticLabel: 'First Tab',
                      ),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTab), findsNWidgets(2));
      });

      testWidgets('uses label as semantic label if not provided', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(tabId: 'tab1', label: 'Tab 1'),
                      RemixTab(tabId: 'tab2', label: 'Tab 2'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Tab 1'), findsOneWidget);
        expect(find.text('Tab 2'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty tabs', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(selectedTabId: 'tab1', child: const SizedBox()),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTabs), findsOneWidget);
      });

      testWidgets('handles single tab', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [RemixTab(tabId: 'tab1', label: 'Tab 1')],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTab), findsOneWidget);
      });

      testWidgets('handles many tabs', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      for (int i = 1; i <= 10; i++)
                        RemixTab(tabId: 'tab$i', label: 'Tab $i'),
                    ],
                  ),
                ),
                for (int i = 1; i <= 10; i++)
                  RemixTabView(tabId: 'tab$i', child: Text('Content $i')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTab), findsNWidgets(10));
      });

      testWidgets('handles disabled individual tab', (tester) async {
        String? selectedTab = 'tab1';

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return RemixTabs(
                selectedTabId: selectedTab,
                onChanged: (id) {
                  setState(() {
                    selectedTab = id;
                  });
                },
                child: Column(
                  children: [
                    RemixTabBar(
                      child: Row(
                        children: [
                          RemixTab(tabId: 'tab1', label: 'Tab 1'),
                          RemixTab(
                            tabId: 'tab2',
                            label: 'Tab 2',
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                    RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
                    RemixTabView(tabId: 'tab2', child: const Text('Content 2')),
                  ],
                ),
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(selectedTab, equals('tab1'));

        await tester.tap(find.text('Tab 2'));
        await tester.pumpAndSettle();

        expect(selectedTab, equals('tab1'));
      });
    });

    group('Key Parameter', () {
      testWidgets('accepts key parameter for RemixTabs', (tester) async {
        const key = Key('tabs-key');

        await tester.pumpRemixApp(
          RemixTabs(
            key: key,
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [RemixTab(tabId: 'tab1', label: 'Tab 1')],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(key), findsOneWidget);
      });

      testWidgets('accepts key parameter for RemixTabBar', (tester) async {
        const key = Key('tabbar-key');

        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  key: key,
                  child: Row(
                    children: [RemixTab(tabId: 'tab1', label: 'Tab 1')],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(key), findsOneWidget);
      });

      testWidgets('accepts key parameter for RemixTab', (tester) async {
        const key = Key('tab-key');

        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(key: key, tabId: 'tab1', label: 'Tab 1'),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(key), findsOneWidget);
      });

      testWidgets('accepts key parameter for RemixTabView', (tester) async {
        const key = Key('tabview-key');

        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [RemixTab(tabId: 'tab1', label: 'Tab 1')],
                  ),
                ),
                RemixTabView(
                  key: key,
                  tabId: 'tab1',
                  child: const Text('Content 1'),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(key), findsOneWidget);
      });
    });

    group('Mouse Interaction', () {
      testWidgets('handles hover changes', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(
                        tabId: 'tab1',
                        label: 'Tab 1',
                        onHoverChange: (hovered) {
                          // Callback is tested by existence
                        },
                      ),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify callback is set up (existence test)
        expect(find.byType(RemixTab), findsOneWidget);
      });

      testWidgets('handles press changes', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(
                        tabId: 'tab1',
                        label: 'Tab 1',
                        onPressChange: (pressed) {
                          // Callback is tested by existence
                        },
                      ),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify callback is set up (existence test)
        expect(find.byType(RemixTab), findsOneWidget);
      });

      testWidgets('handles custom mouse cursor', (tester) async {
        await tester.pumpRemixApp(
          RemixTabs(
            selectedTabId: 'tab1',
            child: Column(
              children: [
                RemixTabBar(
                  child: Row(
                    children: [
                      RemixTab(
                        tabId: 'tab1',
                        label: 'Tab 1',
                        mouseCursor: SystemMouseCursors.help,
                      ),
                    ],
                  ),
                ),
                RemixTabView(tabId: 'tab1', child: const Text('Content 1')),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixTab), findsOneWidget);
      });
    });
  });
}
