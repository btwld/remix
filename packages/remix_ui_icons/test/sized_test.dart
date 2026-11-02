import 'package:flutter_test/flutter_test.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:remix_ui_icons/sized.dart';

void main() {
  test('picks the master for a size by the pack rule', () {
    const set = OutlineIconSets.search;
    expect(set.at(8), OutlineIcons.search12);
    expect(set.at(12), OutlineIcons.search12);
    expect(set.at(12.5), OutlineIcons.search16);
    expect(set.at(16), OutlineIcons.search16);
    expect(set.at(16.5), OutlineIcons.search);
    expect(set.at(48), OutlineIcons.search);
  });

  test('holds each style and family separately', () {
    expect(OutlineIconSets.searchFilled.s16, OutlineIcons.searchFilled16);
    expect(RoundedIconSets.home.s12, RoundedIcons.home12);
    expect(OutlineIconSets.search.masters, [
      OutlineIcons.search12,
      OutlineIcons.search16,
      OutlineIcons.search,
    ]);
  });

  test('sets compare by their masters', () {
    expect(
      OutlineIconSets.home,
      const RemixIconSet(
        OutlineIcons.home12,
        OutlineIcons.home16,
        OutlineIcons.home,
      ),
    );
    expect(OutlineIconSets.home, isNot(OutlineIconSets.homeFilled));
  });
}
