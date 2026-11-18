import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _team = [
  FortalAvatarGroupMember('Ana Lima', initials: 'AL', accent: .caju),
  FortalAvatarGroupMember('Bruno Reis', initials: 'BR', accent: .ceu),
  FortalAvatarGroupMember('Clara Mota', initials: 'CM', accent: .serra),
  FortalAvatarGroupMember('Davi Nunes', initials: 'D'),
  FortalAvatarGroupMember('Elis Prado', initials: 'EP', accent: .sol),
  FortalAvatarGroupMember('Flávio Sá', initials: 'FS', accent: .duna),
];

void main() {
  test('defaults to size2, four avatars and the normal contrast', () {
    const group = FortalAvatarGroup(members: _team);

    expect(group.size, FortalAvatarGroupSize.size2);
    expect(group.max, 4);
    expect(group.highContrast, isFalse);
  });

  group('geometry', () {
    for (final (size, avatar, dimension, gap) in const [
      (FortalAvatarGroupSize.size1, FortalAvatarSize.size1, 24.0, 4.0),
      (FortalAvatarGroupSize.size2, FortalAvatarSize.size2, 32.0, 4.0),
      (FortalAvatarGroupSize.size3, FortalAvatarSize.size3, 40.0, 8.0),
      (FortalAvatarGroupSize.size4, FortalAvatarSize.size4, 48.0, 8.0),
    ]) {
      testWidgets('${size.name} spaces ${dimension}px avatars ${gap}px apart', (
        tester,
      ) async {
        await tester.pumpRemixApp(
          FortalAvatarGroup(members: _team.take(3).toList(), size: size),
        );

        final avatars = _avatars(tester);
        expect(avatars.map((avatar) => avatar.size), everyElement(avatar));
        final rects = _avatarRects(tester);
        expect(rects, hasLength(3));
        for (final rect in rects) {
          expect(rect.size, Size.square(dimension));
        }
        for (var index = 1; index < rects.length; index++) {
          expect(rects[index].left - rects[index - 1].right, gap);
        }
        expect(
          tester.getSize(find.byType(FortalAvatarGroup)),
          Size(3 * dimension + 2 * gap, dimension),
        );
      });
    }

    testWidgets('spacing scales with the theme', (tester) async {
      await tester.pumpWidget(
        FortalTheme(
          accent: .mar,
          scaling: .percent110,
          child: WidgetsApp(
            color: const Color(0xFFFFFFFF),
            builder: (_, _) => Center(
              child: FortalAvatarGroup(
                members: _team.take(2).toList(),
                size: .size3,
              ),
            ),
          ),
        ),
      );

      final rects = _avatarRects(tester);
      expect(rects.first.width, closeTo(44, 1e-9));
      expect(rects.last.left - rects.first.right, closeTo(8.8, 1e-9));
    });
  });

  group('members', () {
    // `max` counts every visible slot, the count included.
    testWidgets('more members than max show max - 1 and a solid count', (
      tester,
    ) async {
      await tester.pumpRemixApp(const FortalAvatarGroup(members: _team));

      final avatars = _avatars(tester);
      expect(avatars, hasLength(4));
      expect(avatars.map((avatar) => avatar.label), ['AL', 'BR', 'CM', '+3']);
      expect(avatars.map((avatar) => avatar.variant), [
        ...List.filled(3, FortalAvatarVariant.soft),
        FortalAvatarVariant.solid,
      ]);
      // Two characters, the count included, take the two-character type.
      expect(avatars.map((avatar) => avatar.fallbackLength), [2, 2, 2, 2]);
    });

    for (final (name, count, max, labels) in const [
      ('exactly max members show them all', 4, 4, ['AL', 'BR', 'CM', 'D']),
      (
        'one more than max shows a count of two',
        5,
        4,
        ['AL', 'BR', 'CM', '+2'],
      ),
      ('max one shows only the count', 6, 1, ['+6']),
      ('max one with one member shows it', 1, 1, ['AL']),
      (
        'a max above the members shows them all',
        6,
        8,
        ['AL', 'BR', 'CM', 'D', 'EP', 'FS'],
      ),
    ]) {
      testWidgets(name, (tester) async {
        await tester.pumpRemixApp(
          FortalAvatarGroup(members: _team.take(count).toList(), max: max),
        );

        expect(_avatars(tester).map((avatar) => avatar.label), labels);
      });
    }

    testWidgets('the count stops at 99+', (tester) async {
      final crowd = [
        for (var index = 0; index < 150; index++)
          FortalAvatarGroupMember('Member $index', initials: 'M'),
      ];
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(FortalAvatarGroup(members: crowd));

      final avatars = _avatars(tester);
      expect(avatars.map((avatar) => avatar.label), ['M', 'M', 'M', '99+']);
      expect(avatars.last.fallbackLength, 2);
      expect(tester.takeException(), isNull);
      // Every name is still announced, past the cap as well.
      expect(
        find.bySemanticsLabel(crowd.map((member) => member.name).join(', ')),
        findsOneWidget,
      );
      semantics.dispose();

      // 102 members leave 99 past the three shown; one more passes the cap.
      for (final (count, label) in const [(102, '+99'), (103, '99+')]) {
        await tester.pumpRemixApp(
          FortalAvatarGroup(members: crowd.take(count).toList()),
        );
        expect(_avatars(tester).last.label, label, reason: '$count');
      }
    });

    testWidgets('an empty group draws nothing', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(const FortalAvatarGroup(members: []));

      expect(find.byType(FortalAvatar), findsNothing);
      expect(tester.getSize(find.byType(FortalAvatarGroup)), Size.zero);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });

    testWidgets('an image shows over the initials', (tester) async {
      final image = MemoryImage(_transparentPixel);
      await tester.pumpRemixApp(
        FortalAvatarGroup(
          members: [
            FortalAvatarGroupMember('Ana Lima', initials: 'AL', image: image),
          ],
        ),
      );

      final avatar = _avatars(tester).single;
      expect(avatar.foregroundImage, image);
      expect(avatar.label, 'AL');
    });
  });

  group('colour', () {
    for (final mode in const [FortalThemeMode.light, FortalThemeMode.dark]) {
      testWidgets('each member takes its own accent in ${mode.name}', (
        tester,
      ) async {
        // Four members and a count of two: an accent-less member and the
        // count both keep the ambient accent.
        await tester.pumpRemixApp(
          const FortalAvatarGroup(members: _team, max: 5),
          accent: .mar,
          mode: mode,
        );

        final fills = _fills(tester);
        Future<Color> token(ColorToken token, FortalAccentColor accent) =>
            resolveInFortalTheme(
              tester,
              (context) => MixScope.tokenOf(token, context),
              accent: accent,
              mode: mode,
            );
        // Resolve after reading the group: each resolution pumps a new tree.
        expect(fills[0], await token(FortalTokens.accentA3, .caju));
        expect(fills[1], await token(FortalTokens.accentA3, .ceu));
        expect(fills[2], await token(FortalTokens.accentA3, .serra));
        // No accent of its own keeps the ambient one, as does the count.
        expect(fills[3], await token(FortalTokens.accentA3, .mar));
        expect(fills[4], await token(FortalTokens.accentSolid, .mar));
      });
    }

    testWidgets('high contrast strengthens every avatar', (tester) async {
      await tester.pumpRemixApp(
        const FortalAvatarGroup(
          members: [FortalAvatarGroupMember('Davi Nunes', initials: 'DN')],
          max: 1,
          highContrast: true,
        ),
      );
      expect(
        _avatars(tester).map((avatar) => avatar.highContrast),
        everyElement(isTrue),
      );

      await tester.pumpRemixApp(
        const FortalAvatarGroup(members: _team, max: 1, highContrast: true),
        accent: .mar,
      );
      final fills = _fills(tester);
      final accent12 = await resolveInFortalTheme(
        tester,
        (context) => MixScope.tokenOf(FortalTokens.accent12, context),
        accent: .mar,
      );
      expect(fills.last, accent12);
    });

    testWidgets('a caller style merges last into every avatar', (tester) async {
      const fill = Color(0xFF123456);
      await tester.pumpRemixApp(
        FortalAvatarGroup(
          members: _team,
          max: 3,
          style: AvatarStyler().color(fill),
        ),
      );

      expect(_fills(tester), [fill, fill, fill]);
    });
  });

  group('semantics', () {
    testWidgets('the group is one node naming every member', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(const FortalAvatarGroup(members: _team));

      final names = _team.map((member) => member.name).join(', ');
      expect(find.bySemanticsLabel(names), findsOneWidget);
      // Neither the initials nor the count are announced on their own.
      expect(find.bySemanticsLabel('AL'), findsNothing);
      expect(find.bySemanticsLabel('+2'), findsNothing);
      semantics.dispose();
    });

    testWidgets('a semantic label replaces the names', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(
        const FortalAvatarGroup(
          members: _team,
          semanticLabel: 'Six people edit this',
        ),
      );

      expect(find.bySemanticsLabel('Six people edit this'), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('Ana Lima')), findsNothing);
      semantics.dispose();
    });

    testWidgets('the group takes no focus', (tester) async {
      await tester.pumpRemixApp(const FortalAvatarGroup(members: _team));

      final focusable = find.byWidgetPredicate(
        (widget) => widget is Focus && widget.canRequestFocus != false,
      );
      expect(
        find.descendant(
          of: find.byType(FortalAvatarGroup),
          matching: focusable,
        ),
        findsNothing,
      );
    });
  });

  group('layout direction and text scale', () {
    testWidgets('right to left starts the row from the right', (tester) async {
      await tester.pumpRemixApp(
        const FortalAvatarGroup(members: _team),
        textDirection: .rtl,
      );

      final rects = _avatarRects(tester);
      for (var index = 1; index < rects.length; index++) {
        expect(rects[index].right, lessThan(rects[index - 1].left));
      }
      expect(_avatars(tester).first.label, 'AL');
    });

    testWidgets('200% text keeps the avatar squares', (tester) async {
      await tester.pumpRemixApp(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: FortalAvatarGroup(members: _team, size: .size1),
        ),
        textDirection: .rtl,
      );

      expect(tester.takeException(), isNull);
      for (final rect in _avatarRects(tester)) {
        expect(rect.size, const Size.square(24));
      }
    });
  });
}

List<FortalAvatar> _avatars(WidgetTester tester) =>
    tester.widgetList<FortalAvatar>(find.byType(FortalAvatar)).toList();

Iterable<Finder> _each(Finder finder) => [
  for (var index = 0; index < finder.evaluate().length; index++)
    finder.at(index),
];

List<Rect> _avatarRects(WidgetTester tester) => [
  for (final avatar in _each(find.byType(FortalAvatar))) tester.getRect(avatar),
];

/// The painted fill of each avatar, in order.
List<Color?> _fills(WidgetTester tester) => [
  for (final avatar in _each(find.byType(FortalAvatar)))
    tester
        .widgetList<DecoratedBox>(
          find.descendant(of: avatar, matching: find.byType(DecoratedBox)),
        )
        .map((box) => box.decoration)
        .whereType<BoxDecoration>()
        .map((decoration) => decoration.color)
        .firstWhere((color) => color != null),
];

/// A 1×1 transparent PNG.
final _transparentPixel = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);
