import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/app_bar.dart';
import 'package:registry_source/src/heroui/components/button.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('the bar sits on background over a separator in $mode', (
      tester,
    ) async {
      late AppBarSpec spec;
      await tester.pumpHeroUi(
        Builder(
          builder: (context) {
            spec = heroUiAppBarStyle().resolve(context).spec;
            return const SizedBox.shrink();
          },
        ),
        mode: mode,
      );

      final surface = spec.container.spec.decoration! as BoxDecoration;
      final row = spec.toolbar.spec.decoration! as BoxDecoration;
      expect(surface.color, heroUiToken(HeroUiTokens.background, mode));
      expect(
        (row.border! as Border).bottom,
        BorderSide(color: heroUiToken(HeroUiTokens.separator, mode)),
      );
      expect(spec.toolbarHeight, heroUiAppBarToolbarHeight);
      expect(spec.toolbarHeight, 64);
      expect(
        spec.toolbar.spec.padding,
        const EdgeInsets.symmetric(horizontal: 16),
      );
      expect(spec.spacing, 12);
      expect(spec.actions.spec.flex?.spec.spacing, 12);

      // `text-base` semibold in `foreground`.
      final title = spec.title.spec.style!;
      expect(title.fontSize, 16);
      expect(title.fontWeight, FontWeight.w600);
      expect(title.color, heroUiToken(HeroUiTokens.foreground, mode));
    });
  }

  for (final width in [1024.0, 375.0]) {
    testWidgets('renders a heading and actions without Material at $width', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpHeroUi(
        SizedBox(
          width: width,
          child: HeroUiAppBar(
            title: 'Orders',
            actions: [HeroUiButton(label: 'Export', onPressed: () {})],
          ),
        ),
        width: width,
      );

      expect(tester.getSize(find.byType(HeroUiAppBar)).height, 64);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Orders')),
        isSemantics(label: 'Orders', isHeader: true),
      );
      expect(find.text('Export'), findsOneWidget);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });
  }
}
