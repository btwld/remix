import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _dotKey = ValueKey('dot');
const _dot = SizedBox(key: _dotKey, width: 10, height: 10);

Widget _avatar({Widget? badge, TextDirection direction = TextDirection.ltr}) {
  return Directionality(
    textDirection: direction,
    child: Center(
      child: RemixAvatar(
        label: 'JD',
        badge: badge,
        style: AvatarStyler()
            .size(40, 40)
            .borderRadius(BorderRadiusGeometryMix.circular(20))
            .clipBehavior(Clip.antiAlias),
      ),
    ),
  );
}

Rect _avatarRect(WidgetTester tester) => tester.getRect(find.byType(Box));

void main() {
  group('RemixAvatar.badge', () {
    testWidgets('adds no layer without a badge', (tester) async {
      await tester.pumpRemixApp(_avatar());

      expect(
        find.descendant(
          of: find.byType(RemixAvatar),
          matching: find.byType(Stack),
        ),
        findsNothing,
      );
    });

    testWidgets('pins the badge to the bottom right corner in LTR', (
      tester,
    ) async {
      await tester.pumpRemixApp(_avatar(badge: _dot));

      final avatar = _avatarRect(tester);
      final dot = tester.getRect(find.byKey(_dotKey));
      expect(dot.bottomRight, avatar.bottomRight);
      expect(dot.size, const Size(10, 10));
    });

    testWidgets('pins the badge to the bottom left corner in RTL', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _avatar(badge: _dot, direction: TextDirection.rtl),
      );

      expect(
        tester.getRect(find.byKey(_dotKey)).bottomLeft,
        _avatarRect(tester).bottomLeft,
      );
    });

    testWidgets('paints the badge outside the container clip', (tester) async {
      await tester.pumpRemixApp(_avatar(badge: _dot));

      expect(
        find.ancestor(of: find.text('JD'), matching: find.byType(ClipPath)),
        findsOneWidget,
      );
      expect(
        find.ancestor(of: find.byKey(_dotKey), matching: find.byType(ClipPath)),
        findsNothing,
      );
      expect(
        find.ancestor(of: find.byKey(_dotKey), matching: find.byType(Box)),
        findsNothing,
      );
    });

    testWidgets('keeps the badge semantics', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpRemixApp(
        _avatar(
          badge: Semantics(label: 'Online', child: _dot),
        ),
      );

      expect(find.bySemanticsLabel('Online'), findsOneWidget);
      handle.dispose();
    });
  });
}
