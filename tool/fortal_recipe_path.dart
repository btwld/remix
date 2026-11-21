const fortalComponentsPath = 'lib/src/fortal/components';

String fortalRecipePath(Map<String, Object?> family, {String? recipe}) =>
    '$fortalComponentsPath/${recipe ?? family['recipe'] ?? family['id']}.dart';

String fortalGeneratedPath(String path) =>
    path.replaceFirst(RegExp(r'\.dart$'), '.g.dart');
