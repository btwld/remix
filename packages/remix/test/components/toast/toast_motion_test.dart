import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

const _transitionKey = ValueKey('toast-transition');
const _iconData = IconData(0xe000);

Widget _host(Widget child) {
  return MixScope.empty(
    child: WidgetsApp(
      color: const Color(0xFFFFFFFF),
      builder: (context, _) => Overlay.wrap(child: child),
    ),
  );
}

Future<void> _show(
  WidgetTester tester, {
  ToastStyler style = const ToastStyler.create(),
  RemixToastData data = const RemixToastData(title: 'Saved'),
}) async {
  final controller = RemixToastController();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    _host(
      RemixToastScope(
        controller: controller,
        style: style,
        child: const SizedBox.expand(),
      ),
    ),
  );
  controller.showToast(data);
  await tester.pump();
}

double _opacity(WidgetTester tester) => tester
    .widget<Opacity>(
      find.ancestor(
        of: find.byType(RemixToast),
        matching: find.byType(Opacity),
      ),
    )
    .opacity;

void main() {
  group('RemixToastScope motion', () {
    testWidgets('fades in over 180 ms on easeOutCubic by default', (
      tester,
    ) async {
      await _show(tester);

      expect(
        tester
            .widget<NakedToastScope<RemixToastData>>(
              find.byType(NakedToastScope<RemixToastData>),
            )
            .animationStyle,
        const AnimationStyle(
          curve: Curves.easeOutCubic,
          duration: Duration(milliseconds: 180),
          reverseDuration: Duration(milliseconds: 120),
        ),
      );
      await tester.pump(const Duration(milliseconds: 90));
      expect(_opacity(tester), closeTo(Curves.easeOutCubic.transform(.5), .01));
      await tester.pump(const Duration(milliseconds: 90));
      expect(_opacity(tester), 1);
    });

    testWidgets('a style animationStyle paces the entrance; unset fields '
        'keep the defaults', (tester) async {
      await _show(
        tester,
        style: ToastStyler().animationStyle(
          const AnimationStyle(
            curve: Curves.linear,
            duration: Duration(milliseconds: 400),
          ),
        ),
      );

      expect(
        tester
            .widget<NakedToastScope<RemixToastData>>(
              find.byType(NakedToastScope<RemixToastData>),
            )
            .animationStyle,
        const AnimationStyle(
          curve: Curves.linear,
          duration: Duration(milliseconds: 400),
          reverseDuration: Duration(milliseconds: 120),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(_opacity(tester), closeTo(.5, .01));
    });

    testWidgets('a style transitionBuilder replaces the fade and slide', (
      tester,
    ) async {
      RemixToastPlacement? placement;
      Animation<double>? animation;
      await _show(
        tester,
        style: ToastStyler().transitionBuilder((context, value, side, child) {
          animation = value;
          placement = side;
          return ScaleTransition(
            key: _transitionKey,
            scale: value,
            child: child,
          );
        }),
      );

      expect(placement, RemixToastPlacement.bottomEnd);
      expect(animation!.status, AnimationStatus.forward);
      expect(
        find.ancestor(
          of: find.byType(RemixToast),
          matching: find.byKey(_transitionKey),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.byType(RemixToast),
          matching: find.byType(Opacity),
        ),
        findsNothing,
      );
    });

    testWidgets('a per-toast style does not change the scope motion', (
      tester,
    ) async {
      await _show(
        tester,
        data: RemixToastData(
          title: 'Saved',
          style: ToastStyler().animationStyle(
            const AnimationStyle(duration: Duration(seconds: 2)),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 180));
      expect(_opacity(tester), 1);
    });
  });

  group('ToastSpec.iconContainer', () {
    Future<Rect> iconRect(WidgetTester tester, ToastStyler style) async {
      await tester.pumpWidget(
        _host(
          Center(
            child: RemixToast(title: 'Saved', icon: _iconData, style: style),
          ),
        ),
      );
      return tester.getRect(find.byType(Icon));
    }

    testWidgets('wraps the icon in a styled box', (tester) async {
      final bare = await iconRect(tester, ToastStyler());
      final boxed = await iconRect(
        tester,
        ToastStyler().iconContainer(BoxStyler().padding(.all(7))),
      );

      expect(boxed.size, bare.size);
      expect(
        tester.getSize(
          find
              .ancestor(of: find.byType(Icon), matching: find.byType(Box))
              .first,
        ),
        bare.size + const Offset(14, 14),
      );
    });

    testWidgets('leaves the icon bare by default', (tester) async {
      await iconRect(tester, ToastStyler());

      // The nearest box is the toast surface, which also holds the title.
      final nearestBox = find
          .ancestor(of: find.byType(Icon), matching: find.byType(Box))
          .first;
      expect(
        find.descendant(of: nearestBox, matching: find.text('Saved')),
        findsOneWidget,
      );
    });
  });
}
