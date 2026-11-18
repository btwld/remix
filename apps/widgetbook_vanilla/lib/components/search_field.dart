import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Search Field', type: VanillaSearchField)
Widget buildVanillaSearchFieldUseCase(BuildContext context) =>
    const Scaffold(body: Center(child: _SearchFieldScene()));

/// An empty field, one holding a query so its clear button shows, and a
/// disabled one.
class _SearchFieldScene extends StatefulWidget {
  const _SearchFieldScene();

  @override
  State<_SearchFieldScene> createState() => _SearchFieldSceneState();
}

class _SearchFieldSceneState extends State<_SearchFieldScene> {
  final _query = TextEditingController(text: 'Northstar');

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final label = rtl ? 'البحث في العملاء' : 'Search customers';
    final hint = rtl ? 'ابحث في العملاء…' : 'Search customers…';
    return SizedBox(
      width: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 24,
        children: [
          VanillaSearchField(semanticLabel: label, hintText: hint),
          VanillaSearchField(
            semanticLabel: label,
            hintText: hint,
            controller: _query,
          ),
          VanillaSearchField(
            semanticLabel: label,
            hintText: rtl ? 'غير متاح' : 'Disabled',
            enabled: false,
          ),
        ],
      ),
    );
  }
}
