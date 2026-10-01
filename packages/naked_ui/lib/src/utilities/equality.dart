import 'package:flutter/foundation.dart';

/// Recursive structural equality and hashing for collections.
///
/// Maps and sets compare without regard to order; lists compare in order.
/// Used by [NakedEquatable] so a props list can hold collections directly.
@immutable
class DeepCollectionEquality {
  /// Creates a deep collection equality.
  const DeepCollectionEquality();

  bool _mapsEqual(Map map1, Map map2) {
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (!map2.containsKey(key) || !equals(map1[key], map2[key])) {
        return false;
      }
    }

    return true;
  }

  bool _iterablesEqual(Iterable iter1, Iterable iter2) {
    if (iter1.length != iter2.length) return false;
    if (iter1 is List && iter2 is List) {
      for (int i = 0; i < iter1.length; i++) {
        if (!equals(iter1[i], iter2[i])) return false;
      }

      return true;
    }

    return false;
  }

  bool _setsEqual(Set set1, Set set2) {
    if (set1.length != set2.length) return false;
    final unmatched = set2.toList();
    for (final value in set1) {
      final match = unmatched.indexWhere(
        (candidate) => equals(value, candidate),
      );
      if (match == -1) return false;
      unmatched.removeAt(match);
    }

    return true;
  }

  /// Whether [obj1] and [obj2] are deeply equal.
  bool equals(Object? obj1, Object? obj2) {
    if (identical(obj1, obj2)) return true;
    if (obj1 == null || obj2 == null) return false;

    if (obj1 is Map) return obj2 is Map && _mapsEqual(obj1, obj2);
    if (obj1 is Set) return obj2 is Set && _setsEqual(obj1, obj2);
    if (obj1 is Iterable)
      return obj2 is Iterable && _iterablesEqual(obj1, obj2);

    return obj1 == obj2;
  }

  /// A hash for [obj] consistent with [equals].
  int hash(Object? obj) {
    if (obj is Map) {
      return Object.hashAllUnordered(
        obj.entries.map((entry) => Object.hash(entry.key, hash(entry.value))),
      );
    }
    if (obj is Set) return Object.hashAllUnordered(obj.map(hash));
    if (obj is List) return Object.hashAll(obj.map(hash));

    return obj.hashCode;
  }
}

const _equality = DeepCollectionEquality();

/// Deep equality between two props lists.
bool propsEquals(List<Object?> a, List<Object?> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (!_equality.equals(a[i], b[i])) return false;
  }

  return true;
}

/// Deep hash of [props], combined with [runtimeType]. Paired with
/// [propsEquals] so `==` and `hashCode` stay consistent.
int propsHash(Type runtimeType, List<Object?> props) {
  var hash = runtimeType.hashCode;
  for (final prop in props) {
    hash = Object.hash(hash, _equality.hash(prop));
  }

  return hash;
}

/// Value equality derived from a list of properties.
///
/// Implement [props] and both [operator ==] and [hashCode] follow, with deep
/// comparison of any collections in the list. Objects of different
/// [runtimeType] are never equal.
///
/// ```dart
/// class Point with NakedEquatable {
///   const Point(this.x, this.y);
///
///   final int x;
///   final int y;
///
///   @override
///   List<Object?> get props => [x, y];
/// }
/// ```
mixin NakedEquatable {
  /// The properties equality and hashing are computed from.
  List<Object?> get props;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NakedEquatable &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);
}
