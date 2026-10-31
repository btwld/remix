import 'package:demo/helpers/catalog.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();
final _tabState = ValueNotifier('tab1');

@widgetbook.UseCase(name: 'Tabs Component', type: RemixTabs)
Widget buildTabsUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Center(
            child: ListenableBuilder(
              listenable: _tabState,
              builder: (context, child) {
                return RemixTabs(
                  selectedTabId: _tabState.value,
                  onChanged: (id) => _tabState.value = id,
                  child: ColumnBox(
                    style: FlexBoxStyler().spacing(12),
                    children: [
                      FortalTabBar(
                        child: RowBox(
                          children: [
                            FortalTab(tabId: 'tab1', label: 'Tab 1'),
                            FortalTab(tabId: 'tab2', label: 'Tab 2'),
                          ],
                        ),
                      ),
                      const RowBox(
                        children: [
                          FortalTabView(
                            tabId: 'tab1',
                            child: Text('Content of tab 1'),
                          ),
                          FortalTabView(
                            tabId: 'tab2',
                            child: Text('Content of tab 2'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Catalog', type: RemixTabs)
Widget buildTabsCatalogUseCase(BuildContext context) {
  return CatalogMatrix(
    cellWidth: 220,
    columns: labelsOf(FortalTabsSize.values),
    rows: noRowAxis,
    cell: (row, column) => RemixTabs(
      selectedTabId: 'one',
      child: FortalTabBar(
        child: RowBox(
          children: [
            FortalTab(
              tabId: 'one',
              label: 'One',
              size: FortalTabsSize.values[column],
            ),
            FortalTab(
              tabId: 'two',
              label: 'Two',
              size: FortalTabsSize.values[column],
            ),
          ],
        ),
      ),
    ),
  );
}
