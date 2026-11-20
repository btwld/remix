import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

Iterable<({String uri, int line})> dartDirectiveUris(
  String source, {
  required String path,
}) sync* {
  final parsed = parseString(content: source, path: path);
  for (final directive in parsed.unit.directives) {
    for (final literal in _uriLiterals(directive)) {
      if (literal.stringValue case final uri?) {
        yield (
          uri: uri,
          line: parsed.lineInfo.getLocation(literal.offset).lineNumber,
        );
      }
    }
  }
}

Iterable<StringLiteral> _uriLiterals(Directive directive) sync* {
  if (directive is UriBasedDirective) yield directive.uri;
  if (directive is NamespaceDirective) {
    for (final configuration in directive.configurations) {
      yield configuration.uri;
    }
  }
  if (directive case PartOfDirective(uri: final uri?)) yield uri;
}
