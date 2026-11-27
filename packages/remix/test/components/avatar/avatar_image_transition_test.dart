import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

/// An image whose load the test settles explicitly.
class _ControlledImage extends ImageProvider<_ControlledImage> {
  final Completer<ImageInfo> _completer = Completer<ImageInfo>();

  void fail() => _completer.completeError(StateError('offline'));

  Future<void> load(WidgetTester tester) async {
    final image = await tester.runAsync(
      () => createTestImage(width: 1, height: 1),
    );
    _completer.complete(ImageInfo(image: image!));
  }

  @override
  Future<_ControlledImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    _ControlledImage key,
    ImageDecoderCallback decode,
  ) => OneFrameImageStreamCompleter(_completer.future);
}

const _transition = RemixAvatarImageTransition(
  duration: Duration(milliseconds: 200),
  blurSigma: 4,
);

Widget _avatar(ImageProvider image, {RemixAvatarImageTransition? transition}) {
  return RemixAvatar(
    backgroundImage: image,
    label: 'JD',
    style: transition == null
        ? const AvatarStyler.create()
        : AvatarStyler().imageTransition(transition),
  );
}

/// Effective opacity painted over [finder]: the product of its Opacity
/// ancestors.
double _opacityOf(WidgetTester tester, Finder finder) {
  return tester
      .widgetList<Opacity>(
        find.ancestor(of: finder, matching: find.byType(Opacity)),
      )
      .fold(1.0, (value, opacity) => value * opacity.opacity);
}

Finder get _image => find.byType(RawImage);

Finder get _blur =>
    find.ancestor(of: _image, matching: find.byType(ImageFiltered));

void main() {
  tearDown(
    () => imageCache
      ..clear()
      ..clearLiveImages(),
  );

  group('AvatarSpec.imageTransition', () {
    testWidgets('null swaps the image in on its first frame', (tester) async {
      final image = _ControlledImage();
      await tester.pumpRemixApp(_avatar(image));
      expect(_opacityOf(tester, find.text('JD')), 1);

      await image.load(tester);
      await tester.pump();

      expect(_opacityOf(tester, _image), 1);
      expect(_blur, findsNothing);
      expect(_opacityOf(tester, find.text('JD')), 0);
    });

    testWidgets('fades a loaded image in from the blur', (tester) async {
      final image = _ControlledImage();
      await tester.pumpRemixApp(_avatar(image, transition: _transition));
      expect(_opacityOf(tester, find.text('JD')), 1);

      await image.load(tester);
      await tester.pump();
      expect(_opacityOf(tester, _image), 0);
      expect(_blur, findsOneWidget);

      await tester.pump(const Duration(milliseconds: 100));
      expect(_opacityOf(tester, _image), closeTo(0.5, 0.01));
      expect(_blur, findsOneWidget);

      await tester.pump(const Duration(milliseconds: 100));
      expect(_opacityOf(tester, _image), 1);
      expect(_blur, findsNothing);
    });

    testWidgets('hides the fallback while loading and fades it in on error', (
      tester,
    ) async {
      final image = _ControlledImage();
      await tester.pumpRemixApp(
        _avatar(
          image,
          transition: const RemixAvatarImageTransition(
            duration: Duration(milliseconds: 200),
            showFallbackWhileLoading: false,
          ),
        ),
      );
      expect(_opacityOf(tester, find.text('JD')), 0);
      expect(find.text('JD'), findsOneWidget);

      image.fail();
      await tester.pump();
      expect(_opacityOf(tester, find.text('JD')), 0);

      await tester.pump(const Duration(milliseconds: 100));
      expect(_opacityOf(tester, find.text('JD')), closeTo(0.5, 0.01));

      await tester.pump(const Duration(milliseconds: 100));
      expect(_opacityOf(tester, find.text('JD')), 1);
    });

    testWidgets('a visible fallback shows a failure without a fade', (
      tester,
    ) async {
      final image = _ControlledImage();
      await tester.pumpRemixApp(_avatar(image, transition: _transition));

      image.fail();
      await tester.pump();

      expect(_opacityOf(tester, find.text('JD')), 1);
    });

    testWidgets('reduced motion shows the image at once, without blur', (
      tester,
    ) async {
      final image = _ControlledImage();
      await tester.pumpRemixApp(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: _avatar(image, transition: _transition),
        ),
      );

      await image.load(tester);
      await tester.pump();

      expect(_opacityOf(tester, _image), 1);
      expect(_blur, findsNothing);
    });

    testWidgets('a synchronously loaded image never animates', (tester) async {
      final image = MemoryImage(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
        ),
      );
      await tester.pumpRemixApp(const SizedBox());
      await tester.runAsync(
        () => precacheImage(image, tester.element(find.byType(SizedBox))),
      );

      await tester.pumpRemixApp(_avatar(image, transition: _transition));

      expect(_opacityOf(tester, _image), 1);
      expect(_blur, findsNothing);
    });
  });
}
