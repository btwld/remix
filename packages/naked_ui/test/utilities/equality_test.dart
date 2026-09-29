import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

class _Point with NakedEquatable {
  const _Point(this.x, this.y);

  final int x;
  final int y;

  @override
  List<Object?> get props => [x, y];
}

class _OtherPoint with NakedEquatable {
  const _OtherPoint(this.x, this.y);

  final int x;
  final int y;

  @override
  List<Object?> get props => [x, y];
}

class _Collections with NakedEquatable {
  const _Collections(this.list, this.set, this.map);

  final List<int> list;
  final Set<String> set;
  final Map<String, int> map;

  @override
  List<Object?> get props => [list, set, map];
}

class _TestState extends NakedState {
  _TestState({required super.states, required this.label});

  final String label;

  @override
  List<Object?> get props => [...super.props, label];
}

void main() {
  group('NakedEquatable', () {
    test('compares by props', () {
      expect(const _Point(1, 2), const _Point(1, 2));
      expect(const _Point(1, 2).hashCode, const _Point(1, 2).hashCode);
      expect(const _Point(1, 2), isNot(const _Point(2, 1)));
    });

    test('different runtime types are never equal', () {
      expect(const _Point(1, 2), isNot(const _OtherPoint(1, 2)));
    });

    test('compares collections deeply', () {
      final a = _Collections(const [1, 2], const {'a'}, const {'k': 1});

      expect(a, _Collections(const [1, 2], const {'a'}, const {'k': 1}));
      expect(
        a.hashCode,
        _Collections(const [1, 2], const {'a'}, const {'k': 1}).hashCode,
      );
      expect(a, isNot(_Collections(const [2, 1], const {'a'}, const {'k': 1})));
      expect(a, isNot(_Collections(const [1, 2], const {'b'}, const {'k': 1})));
      expect(a, isNot(_Collections(const [1, 2], const {'a'}, const {'k': 2})));
    });

    test('sets compare without regard to order', () {
      final a = _Collections(const [], {'a', 'b'}, const {});
      final b = _Collections(const [], {'b', 'a'}, const {});

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('NakedState', () {
    test('derives equality from states plus subclass props', () {
      final a = _TestState(
        states: {WidgetState.hovered, WidgetState.focused},
        label: 'a',
      );
      final b = _TestState(
        states: {WidgetState.focused, WidgetState.hovered},
        label: 'a',
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(_TestState(states: {WidgetState.hovered}, label: 'a')));
      expect(
        a,
        isNot(
          _TestState(
            states: {WidgetState.hovered, WidgetState.focused},
            label: 'b',
          ),
        ),
      );
    });
  });
}
