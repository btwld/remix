import 'package:mix/mix.dart';

class RemixSpace {
  RemixSpace();

  final space1 = const SpaceToken('--space-1');
  final space2 = const SpaceToken('--space-2');
  final space3 = const SpaceToken('--space-3');
  final space4 = const SpaceToken('--space-4');
  final space5 = const SpaceToken('--space-5');
  final space6 = const SpaceToken('--space-6');
  final space7 = const SpaceToken('--space-7');
  final space8 = const SpaceToken('--space-8');
  final space9 = const SpaceToken('--space-9');

  operator [](int index) {
    return call(index);
  }

  SpaceToken call(int step) {
    switch (step) {
      case 1:
        return space1;
      case 2:
        return space2;
      case 3:
        return space3;
      case 4:
        return space4;
      case 5:
        return space5;
      case 6:
        return space6;
      case 7:
        return space7;
      case 8:
        return space8;
      case 9:
        return space9;
      default:
        throw Exception(
          'Invalid space step: $step found. Space step should be between 1 and 9.',
        );
    }
  }
}

final _s = RemixSpace();
final remixSpaceTokens = <SpaceToken, double>{
  _s.space1: 4,
  _s.space2: 8,
  _s.space3: 12,
  _s.space4: 16,
  _s.space5: 24,
  _s.space6: 32,
  _s.space7: 40,
  _s.space8: 48,
  _s.space9: 64,
};
