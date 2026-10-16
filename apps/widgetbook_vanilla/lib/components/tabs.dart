import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Tabs', type: VanillaTabBar)
Widget buildVanillaTabsUseCase(BuildContext context) {
  var selected = 'account';
  return Scaffold(
    body: Center(
      child: StatefulBuilder(
        builder: (context, setState) => RemixTabs(
          selectedTabId: selected,
          onChanged: (value) => setState(() => selected = value),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              VanillaTabBar(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VanillaTab(tabId: 'account', label: 'Account'),
                    VanillaTab(tabId: 'billing', label: 'Billing'),
                  ],
                ),
              ),
              VanillaTabView(
                tabId: 'account',
                child: Text('Account settings panel'),
              ),
              VanillaTabView(
                tabId: 'billing',
                child: Text('Billing preferences panel'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
