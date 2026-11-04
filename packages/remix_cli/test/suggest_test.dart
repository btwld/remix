import 'package:remix_cli/src/suggest.dart';
import 'package:test/test.dart';

void main() {
  test('a transposition is one edit', () {
    expect(didYouMean('lsit', ['list', 'add']), 'Did you mean list?');
  });

  test('suggests within two edits and nothing at three', () {
    expect(didYouMean('buttn', ['button']), 'Did you mean button?');
    expect(didYouMean('btn', ['button']), isNull);
  });

  test('a prefix of three or more characters suggests longer names', () {
    expect(
      didYouMean('data', ['data_table', 'data_list', 'card']),
      'Did you mean data_list or data_table?',
    );
    expect(didYouMean('da', ['data_table']), isNull);
  });

  test('keeps the three nearest, ties alphabetical', () {
    expect(
      didYouMean('card', ['cards', 'card_x', 'bard', 'cart', 'far']),
      'Did you mean bard, cards, or cart?',
    );
  });

  test('null when nothing is close', () {
    expect(didYouMean('shadcn', ['vanilla', 'fortal', 'heroui']), isNull);
    expect(didYouMean('button', const <String>[]), isNull);
  });
}
