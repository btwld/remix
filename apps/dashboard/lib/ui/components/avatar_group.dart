import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'avatar.dart';

/// The sizes an avatar group comes in: the first four avatar sizes. Pixel
/// values are at 100% theme scaling.
enum UiAvatarGroupSize {
  /// 24px avatars, 4px apart.
  size1,

  /// 32px avatars, 4px apart. The default.
  size2,

  /// 40px avatars, 8px apart.
  size3,

  /// 48px avatars, 8px apart.
  size4,
}

/// One person in a [UiAvatarGroup].
@immutable
class UiAvatarGroupMember {
  const UiAvatarGroupMember(
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
  final UiAccentColor? accent;
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
class UiAvatarGroup extends StatelessWidget {
  const UiAvatarGroup({
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
  final List<UiAvatarGroupMember> members;

  /// The avatar size, and the space between avatars.
  final UiAvatarGroupSize size;

  /// How many avatars the row shows, the count included.
  ///
  /// Up to [max] members all show. With more, the first `max - 1` show and
  /// a solid `+N` counts the rest, up to `99+`, so `max: 1` shows only the
  /// count.
  final int max;

  /// Strengthens every avatar as [UiAvatar.highContrast] does.
  final bool highContrast;

  /// Replaces the announced list of names.
  final String? semanticLabel;

  /// Merged last into every avatar, the count included.
  final AvatarStyler style;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();

    final (avatarSize, gap) = switch (size) {
      .size1 => (UiAvatarSize.size1, UiTokens.space1()),
      .size2 => (UiAvatarSize.size2, UiTokens.space1()),
      .size3 => (UiAvatarSize.size3, UiTokens.space2()),
      .size4 => (UiAvatarSize.size4, UiTokens.space2()),
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
                UiAvatar.soft(
                  label: member.initials,
                  foregroundImage: member.image,
                  size: avatarSize,
                  highContrast: highContrast,
                  fallbackLength: _fallbackLength(member.initials),
                  style: style,
                ),
              ),
            if (rest > 0)
              UiAvatar.solid(
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
Widget _tinted(UiAccentColor? accent, Widget avatar) => accent == null
    ? avatar
    : UiTheme(accent: accent, hasBackground: false, child: avatar);

/// The avatar's one- or two-character fallback typography for [label].
int _fallbackLength(String label) => label.characters.length == 1 ? 1 : 2;
