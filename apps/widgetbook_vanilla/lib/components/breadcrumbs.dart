import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Breadcrumbs', type: VanillaBreadcrumbs)
Widget buildVanillaBreadcrumbsUseCase(BuildContext context) {
  final rtl = Directionality.of(context) == TextDirection.rtl;
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 24,
        children: [
          VanillaBreadcrumbs(
            items: [
              VanillaBreadcrumbItem(
                rtl ? 'الرئيسية' : 'Home',
                onPressed: () {},
              ),
              VanillaBreadcrumbItem(
                rtl ? 'المكونات' : 'Components',
                onPressed: () {},
              ),
              VanillaBreadcrumbItem(rtl ? 'مسار التنقل' : 'Breadcrumb'),
            ],
          ),
          // Long steps ellipsize instead of wrapping the trail.
          SizedBox(
            width: 240,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: VanillaBreadcrumbs(
                items: [
                  VanillaBreadcrumbItem(
                    rtl ? 'إدارة مساحة العمل' : 'Workspace administration',
                    onPressed: () {},
                  ),
                  VanillaBreadcrumbItem(
                    rtl
                        ? 'حسابات العملاء والفوترة'
                        : 'Customer accounts and billing',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
