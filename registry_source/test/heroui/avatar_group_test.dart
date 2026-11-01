import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/avatar.dart';
import 'package:registry_source/src/heroui/components/avatar_group.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';

import '../helpers/heroui.dart';

const _tolerance = 1.5 / 255;

Widget _group(
  List<HeroUiAvatarSize> sizes, {
  HeroUiAvatarGroupOverlap overlap = .clip,
  bool grid = false,
  TextDirection direction = TextDirection.ltr,
}) => Directionality(
  textDirection: direction,
  child: HeroUiAvatarGroup(
    overlap: overlap,
    grid: grid,
    children: [
      for (final (index, size) in sizes.indexed)
        HeroUiAvatar(size: size, label: String.fromCharCode(65 + index)),
    ],
  ),
);

List<HeroUiAvatarSize> _same(HeroUiAvatarSize size) => [size, size, size];

Future<void> _pump(
  WidgetTester tester,
  Widget group, {
  String mode = 'light',
}) async {
  await tester.pumpHeroUi(group, mode: mode);
  await tester.pumpAndSettle();
}

Finder get _avatars => find.byType(HeroUiAvatar);

/// The seam masks the group adds; each avatar's own clip is a different one.
List<ClipPath> _seams(WidgetTester tester) => tester
    .widgetList<ClipPath>(
      find.descendant(
        of: find.byType(HeroUiAvatarGroup),
        matching: find.byType(ClipPath),
      ),
    )
    .where((clip) => '${clip.clipper.runtimeType}' == '_SeamClipper')
    .toList();

/// `--avatar-group-overlap`, from a three-avatar case: the group is three
/// avatars less two overlaps wide.
double _overlap(HeroUiCase group) =>
    (3 * group.size.height - group.size.width) / 2;

/// `--avatar-group-seam`: the spread of `0 0 0 2px var(--background)` on the
/// ring cases.
double _seam() => cssShadows(
  heroUiCase('avatar-group-ring-md-0').styles['boxShadow']!,
).single.spreadRadius;

void main() {
  test('overlaps follow HeroUI', () {
    expect(HeroUiAvatarGroupOverlap.values.map((o) => o.name), [
      'clip',
      'ring',
    ]);
  });

  for (final overlap in HeroUiAvatarGroupOverlap.values) {
    testWidgets('${overlap.name} stacks avatars like upstream', (tester) async {
      for (final size in HeroUiAvatarSize.values) {
        await _pump(tester, _group(_same(size), overlap: overlap));
        final upstream = heroUiCase(
          'avatar-group-${overlap.name}-${size.name}',
        );
        final avatar = upstream.size.height;
        expect(
          tester.getSize(find.byType(HeroUiAvatarGroup)),
          upstream.size,
          reason: size.name,
        );
        // avatar-group.css: each avatar after the first starts 0.5rem early.
        for (var i = 0; i < 3; i++) {
          expect(
            tester.getTopLeft(_avatars.at(i)).dx -
                tester.getTopLeft(find.byType(HeroUiAvatarGroup)).dx,
            i * (avatar - _overlap(upstream)),
            reason: '${size.name} $i',
          );
        }
      }
    });
  }

  testWidgets('mixed sizes overlap by each avatar\'s own width', (
    tester,
  ) async {
    const sizes = [
      HeroUiAvatarSize.sm,
      HeroUiAvatarSize.lg,
      HeroUiAvatarSize.md,
    ];
    final overlap = _overlap(heroUiCase('avatar-group-clip-md'));
    // Every size agrees on the overlap, so it is not scaled by the avatar.
    for (final size in HeroUiAvatarSize.values) {
      expect(
        _overlap(heroUiCase('avatar-group-clip-${size.name}')),
        overlap,
        reason: size.name,
      );
    }

    await _pump(tester, _group(sizes));
    final dimensions = [for (final size in sizes) heroUiAvatarDimension(size)];
    final tallest = dimensions.reduce((a, b) => a > b ? a : b);
    expect(
      tester.getSize(find.byType(HeroUiAvatarGroup)),
      Size(dimensions.reduce((a, b) => a + b) - 2 * overlap, tallest),
    );

    final groupLeft = tester.getTopLeft(find.byType(HeroUiAvatarGroup)).dx;
    var start = 0.0;
    for (final (index, dimension) in dimensions.indexed) {
      final rect = tester.getRect(_avatars.at(index));
      expect(rect.size, Size.square(dimension), reason: '$index');
      expect(rect.left - groupLeft, start, reason: '$index');
      start += dimension - overlap;
    }
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('ring draws the background seam around every avatar in $mode', (
      tester,
    ) async {
      await _pump(tester, _group(_same(.md), overlap: .ring), mode: mode);
      final upstream = heroUiCase('avatar-group-ring-md-0', mode: mode);
      final seam = cssShadows(upstream.styles['boxShadow']!).single;
      final rings = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(HeroUiAvatarGroup),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .where((decoration) => decoration.boxShadow != null)
          .toList();

      expect(rings, hasLength(3));
      for (final ring in rings) {
        final shadow = ring.boxShadow!.single;
        expect(shadow.spreadRadius, seam.spreadRadius);
        expect(shadow.blurRadius, seam.blurRadius);
        expect(shadow.offset, seam.offset);
        expect(shadow.color, isSameColorAs(seam.color, threshold: _tolerance));
      }
    });
  }

  testWidgets('ring radius follows avatar size and custom radius tokens', (
    tester,
  ) async {
    for (final radius in [4.0, 8.0]) {
      for (final size in HeroUiAvatarSize.values) {
        await tester.pumpHeroUi(
          _group([size], overlap: .ring),
          theme: HeroUiThemeData.light(radius: radius),
        );
        await tester.pumpAndSettle();
        final avatar = tester
            .widgetList<DecoratedBox>(
              find.descendant(
                of: _avatars,
                matching: find.byType(DecoratedBox),
              ),
            )
            .map((box) => box.decoration)
            .whereType<BoxDecoration>()
            .single;
        final ring = tester
            .widgetList<DecoratedBox>(
              find.descendant(
                of: find.byType(HeroUiAvatarGroup),
                matching: find.byType(DecoratedBox),
              ),
            )
            .map((box) => box.decoration)
            .whereType<BoxDecoration>()
            .singleWhere((decoration) => decoration.boxShadow != null);
        if (radius == 4 && size == .sm) {
          expect(tester.getSize(_avatars), const Size.square(32));
          expect(avatar.borderRadius, BorderRadius.circular(8));
        }
        expect(
          ring.borderRadius,
          avatar.borderRadius,
          reason: '${size.name} with radius token $radius',
        );
      }
    }
  });

  testWidgets('clip cuts the next avatar out of every avatar but the last', (
    tester,
  ) async {
    await _pump(tester, _group(_same(.md)));
    final clips = _seams(tester);
    expect(clips, hasLength(2));

    // avatar-group.css: the cut is a circle centred 100% + size/2 - overlap
    // from the avatar's start with a radius of size/2 + seam, so it reaches
    // back to size - overlap - seam.
    final dimension = heroUiAvatarDimension(.md);
    final edge =
        dimension - _overlap(heroUiCase('avatar-group-clip-md')) - _seam();
    final path = clips.first.clipper!.getClip(Size.square(dimension));
    expect(path.contains(Offset(edge - .5, dimension / 2)), isTrue);
    expect(path.contains(Offset(edge + .5, dimension / 2)), isFalse);
    expect(path.contains(Offset(dimension / 4, dimension / 2)), isTrue);
  });

  testWidgets('mixed sizes cut each avatar by its own size', (tester) async {
    const sizes = [
      HeroUiAvatarSize.sm,
      HeroUiAvatarSize.lg,
      HeroUiAvatarSize.md,
    ];
    await _pump(tester, _group(sizes));
    final clips = _seams(tester);
    expect(clips, hasLength(2));

    final overlap = _overlap(heroUiCase('avatar-group-clip-md'));
    final seam = _seam();
    for (final (index, size) in sizes.take(2).indexed) {
      final dimension = heroUiAvatarDimension(size);
      // The cut's centre and radius use the avatar's own `--avatar-size`.
      final centerX = dimension + dimension / 2 - overlap;
      final radius = dimension / 2 + seam;
      final path = clips[index].clipper!.getClip(Size.square(dimension));
      final y = dimension / 2;
      expect(path.contains(Offset(centerX - radius - .5, y)), isTrue);
      expect(path.contains(Offset(centerX - radius + .5, y)), isFalse);
    }
  });

  testWidgets('clip mirrors in right-to-left text', (tester) async {
    await _pump(tester, _group(_same(.md), direction: TextDirection.rtl));
    final clip = _seams(tester).first;
    final dimension = heroUiAvatarDimension(.md);
    final path = clip.clipper!.getClip(Size.square(dimension));
    // The cut sits at 0% - size/2 + overlap, so it reaches overlap + seam in.
    final edge = _overlap(heroUiCase('avatar-group-clip-md')) + _seam();
    expect(path.contains(Offset(edge + .5, dimension / 2)), isTrue);
    expect(path.contains(Offset(edge - .5, dimension / 2)), isFalse);
    expect(path.contains(Offset(dimension * .9, dimension / 2)), isTrue);
  });

  testWidgets('grid wraps avatars with a 12px gap', (tester) async {
    await _pump(tester, _group(_same(.md), grid: true));
    final upstream = heroUiCase('avatar-group-grid');
    expect(tester.getSize(find.byType(HeroUiAvatarGroup)), upstream.size);
    expect(
      tester.getTopLeft(_avatars.at(1)).dx -
          tester.getTopRight(_avatars.at(0)).dx,
      upstream.px('gap'),
    );
  });
}
