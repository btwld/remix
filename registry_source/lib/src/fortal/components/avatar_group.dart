import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'avatar.dart';

/// The sizes an avatar group comes in: the first four avatar sizes. Pixel
/// values are at 100% theme scaling.
enum FortalAvatarGroupSize {
  /// 24px avatars, 4px apart.
  size1,

  /// 32px avatars, 4px apart. The default.
  size2,

  /// 40px avatars, 8px apart.
  size3,

  /// 48px avatars, 8px apart.
  size4,
}

/// One person in a [FortalAvatarGroup].
@immutable
class FortalAvatarGroupMember {
  const FortalAvatarGroupMember(
    this.name, {
    required this.initials,
    this.image,
    this.accent,
  }) : assert(name != ''),
       assert(initials != '');

  /// The person's name. The group announces it; it is never drawn.
  final String name;

  /// One or two characters, shown until [image] loads, or instead of it.
  final String initials;

  /// The person's picture.
  final ImageProvider<Object>? image;

  /// The accent that tints this member's avatar. Null keeps the ambient one.
  final FortalAccentColor? accent;
}

/// A row of soft avatars for the people behind something, at most [max]
/// wide. When there are more members than that, the last slot is one solid
/// `+N` avatar counting the rest.
///
/// The avatars stand a spacing step apart instead of overlapping. Overlapping
/// avatars need a seam to stay distinct, a ring in the page color or a cut
/// that follows each avatar's corner. Fortal casts no shadow outside floating
/// layers, and each avatar's corner belongs to its own recipe, so the group
/// separates them with space.
///
/// The group is one node to assistive technology. It announces
/// [semanticLabel], or every member's name, the counted ones included.
class FortalAvatarGroup extends StatelessWidget {
  const FortalAvatarGroup({
    super.key,
    required this.members,
    this.size = .size2,
    this.max = 4,
    this.highContrast = false,
    this.semanticLabel,
    this.style = const AvatarStyler.create(),
  }) : assert(max > 0),
       assert(semanticLabel == null || semanticLabel != '');

  /// The people shown, in order.
  final List<FortalAvatarGroupMember> members;

  /// The avatar size, and the space between avatars.
  final FortalAvatarGroupSize size;

  /// How many avatars the row shows, the count included.
  ///
  /// Up to [max] members all show. With more, the first `max - 1` show and
  /// a solid `+N` counts the rest, up to `99+`, so `max: 1` shows only the
  /// count.
  final int max;

  /// Strengthens every avatar as [FortalAvatar.highContrast] does.
  final bool highContrast;

  /// Replaces the announced list of names.
  final String? semanticLabel;

  /// Merged last into every avatar, the count included.
  final AvatarStyler style;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();

    final (avatarSize, gap) = switch (size) {
      .size1 => (FortalAvatarSize.size1, FortalTokens.space1()),
      .size2 => (FortalAvatarSize.size2, FortalTokens.space1()),
      .size3 => (FortalAvatarSize.size3, FortalTokens.space2()),
      .size4 => (FortalAvatarSize.size4, FortalTokens.space2()),
    };
    final shown = members.length <= max ? members.length : max - 1;
    final rest = members.length - shown;
    final count = rest > 99 ? '99+' : '+$rest';

    return Semantics(
      container: true,
      label: semanticLabel ?? members.map((member) => member.name).join(', '),
      child: ExcludeSemantics(
        child: RowBox(
          style: FlexBoxStyler().mainAxisSize(.min).spacing(gap),
          children: [
            for (final member in members.take(shown))
              _tinted(
                member.accent,
                FortalAvatar.soft(
                  label: member.initials,
                  foregroundImage: member.image,
                  size: avatarSize,
                  highContrast: highContrast,
                  fallbackLength: _fallbackLength(member.initials),
                  style: style,
                ),
              ),
            if (rest > 0)
              FortalAvatar.solid(
                label: count,
                size: avatarSize,
                highContrast: highContrast,
                fallbackLength: _fallbackLength(count),
                style: style,
              ),
          ],
        ),
      ),
    );
  }
}

/// [avatar] under [accent], or under the ambient accent when it is null.
Widget _tinted(FortalAccentColor? accent, Widget avatar) => accent == null
    ? avatar
    : FortalTheme(accent: accent, hasBackground: false, child: avatar);

/// The avatar's one- or two-character fallback typography for [label].
int _fallbackLength(String label) => label.characters.length == 1 ? 1 : 2;
