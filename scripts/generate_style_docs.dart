import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

void main() async {
  // Find all _style.dart files
  final libDir = Directory('lib/src/components');
  final styleFiles = <File>[];

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('_style.dart')) {
      styleFiles.add(entity);
    }
  }

  print('Found ${styleFiles.length} style files\n');

  // Process each style file
  for (final file in styleFiles) {
    final componentName = _getComponentName(file.path);
    print('Processing: $componentName');

    final content = await file.readAsString();
    final methods = _extractMethods(content);

    if (methods.isNotEmpty) {
      print('  Found ${methods.length} public methods');

      // Generate markdown documentation
      final markdown = _generateMarkdown(methods);

      // Check if corresponding .mdx file exists
      final docFile = File('docs/components/$componentName.mdx');
      if (await docFile.exists()) {
        await _updateDocumentation(docFile, markdown);
        print('  ✓ Updated documentation');
      } else {
        print('  ⚠ No documentation file found at ${docFile.path}');
      }
    } else {
      print('  No public methods found');
    }
    print('');
  }

  print('Done!');
}

String _getComponentName(String path) {
  // Extract component name from path
  final parts = path.split('/');
  final filename = parts.last;

  return filename.replaceAll('_style.dart', '');
}

class MethodInfo {
  final String name;
  final String returnType;
  final List<Parameter> parameters;
  final String? docComment;

  const MethodInfo({
    required this.name,
    required this.returnType,
    required this.parameters,
    this.docComment,
  });
}

class Parameter {
  final String name;
  final String type;
  final bool isRequired;
  final bool isNamed;
  final String? defaultValue;

  const Parameter({
    required this.name,
    required this.type,
    this.isRequired = false,
    this.isNamed = false,
    this.defaultValue,
  });
}

class StyleMethodVisitor extends RecursiveAstVisitor<void> {
  final String? styleClassName;
  final List<MethodInfo> methods = [];

  StyleMethodVisitor(this.styleClassName);

  Parameter _extractParameter(FormalParameter param) {
    String name;
    String type;
    bool isRequired = false;
    bool isNamed = false;
    String? defaultValue;

    if (param is DefaultFormalParameter) {
      final innerParam = param.parameter;
      name = innerParam.name?.toString() ?? '';
      type = _getParameterType(innerParam);
      isNamed = param.isNamed;
      isRequired = param.isRequired;
      defaultValue = param.defaultValue?.toString();
    } else if (param is SimpleFormalParameter) {
      name = param.name?.toString() ?? '';
      type = param.type?.toString() ?? 'dynamic';
      isRequired = param.isRequired;
    } else if (param is FieldFormalParameter) {
      name = param.name.toString();
      type = param.type?.toString() ?? 'dynamic';
      isRequired = param.isRequired;
    } else {
      name = param.name?.toString() ?? '';
      type = 'dynamic';
    }

    return Parameter(
      name: name,
      type: type,
      isRequired: isRequired,
      isNamed: isNamed,
      defaultValue: defaultValue,
    );
  }

  String _getParameterType(NormalFormalParameter param) {
    if (param is SimpleFormalParameter) {
      return param.type?.toString() ?? 'dynamic';
    } else if (param is FieldFormalParameter) {
      return param.type?.toString() ?? 'dynamic';
    } else if (param is FunctionTypedFormalParameter) {
      return param.returnType?.toString() ?? 'Function';
    }

    return 'dynamic';
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    // Only process public methods (not starting with _)
    final methodName = node.name.toString();
    if (methodName.startsWith('_')) {
      super.visitMethodDeclaration(node);

      return;
    }

    // Get return type
    final returnType = node.returnType?.toString();

    // Only include methods that return the style class
    if (returnType == null || returnType != styleClassName) {
      super.visitMethodDeclaration(node);

      return;
    }

    // Skip certain methods
    if (methodName == 'resolve' ||
        methodName == 'merge' ||
        methodName == 'copyWith' ||
        methodName == 'call' ||
        methodName == 'variants') {
      super.visitMethodDeclaration(node);

      return;
    }

    // Extract parameters
    final parameters = <Parameter>[];
    final parameterList = node.parameters;
    if (parameterList != null) {
      for (final param in parameterList.parameters) {
        parameters.add(_extractParameter(param));
      }
    }

    // Extract doc comment
    String? docComment;
    final docNode = node.documentationComment;
    if (docNode != null) {
      final docLines = <String>[];
      for (final token in docNode.tokens) {
        final line = token.toString().trim();
        if (line.startsWith('///')) {
          docLines.add(line.substring(3).trim());
        }
      }
      if (docLines.isNotEmpty) {
        docComment = docLines.join(' ');
      }
    }

    methods.add(
      MethodInfo(
        name: methodName,
        returnType: returnType,
        parameters: parameters,
        docComment: docComment,
      ),
    );

    super.visitMethodDeclaration(node);
  }
}

class StyleClassFinder extends RecursiveAstVisitor<void> {
  String? styleClassName;
  String? extendsClause;
  List<String> mixins = [];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final className = node.name.toString();
    if (className.endsWith('Style')) {
      styleClassName = className;

      // Extract extends clause
      if (node.extendsClause != null) {
        extendsClause = node.extendsClause!.superclass.toString();
      }

      // Extract mixins from with clause
      if (node.withClause != null) {
        for (final mixin in node.withClause!.mixinTypes) {
          mixins.add(mixin.toString());
        }
      }
    }
    super.visitClassDeclaration(node);
  }
}

List<MethodInfo> _extractMethods(String content) {
  try {
    // Parse the Dart file
    final parseResult = parseString(content: content);

    if (parseResult.errors.isNotEmpty) {
      print('  ⚠ Parse errors in file');

      return [];
    }

    final unit = parseResult.unit;

    // First, find the style class name and its mixins/extensions
    final classFinder = StyleClassFinder();
    unit.visitChildren(classFinder);

    if (classFinder.styleClassName == null) {
      return [];
    }

    // Extract methods from the style class itself
    final methodVisitor = StyleMethodVisitor(classFinder.styleClassName);
    unit.visitChildren(methodVisitor);

    final allMethods = <MethodInfo>[...methodVisitor.methods];
    final methodNames = <String>{...allMethods.map((m) => m.name)};

    // Also extract methods from mixins (but avoid duplicates)
    for (final mixin in classFinder.mixins) {
      final mixinMethods = _extractMethodsFromMixin(
        mixin,
        classFinder.styleClassName!,
      );
      // Only add methods that aren't already defined in the class
      for (final method in mixinMethods) {
        if (!methodNames.contains(method.name)) {
          allMethods.add(method);
          methodNames.add(method.name);
        }
      }
    }

    return allMethods;
  } catch (e) {
    print('  ⚠ Error parsing file: $e');

    return [];
  }
}

List<MethodInfo> _extractMethodsFromMixin(String mixinName, String returnType) {
  // Remove generic type parameters from mixin name
  final cleanMixinName = mixinName.split('<').first.trim();

  // Map known mixins to their file paths
  final mixinPaths = {
    'LabelStyleMixin': 'lib/src/style/mixins/label_style_mixin.dart',
    'IconStyleMixin': 'lib/src/style/mixins/icon_style_mixin.dart',
    'SpinnerStyleMixin': 'lib/src/style/mixins/spinner_style_mixin.dart',
    'BorderStyleMixin':
        'node_modules/mix/lib/src/style/mixins/border_style_mixin.dart',
    'BorderRadiusStyleMixin':
        'node_modules/mix/lib/src/style/mixins/border_radius_style_mixin.dart',
    'ShadowStyleMixin':
        'node_modules/mix/lib/src/style/mixins/shadow_style_mixin.dart',
    'DecorationStyleMixin':
        'node_modules/mix/lib/src/style/mixins/decoration_style_mixin.dart',
    'SpacingStyleMixin':
        'node_modules/mix/lib/src/style/mixins/spacing_style_mixin.dart',
    'TransformStyleMixin':
        'node_modules/mix/lib/src/style/mixins/transform_style_mixin.dart',
    'ConstraintStyleMixin':
        'node_modules/mix/lib/src/style/mixins/constraint_style_mixin.dart',
    'FlexStyleMixin':
        'node_modules/mix/lib/src/style/mixins/flex_style_mixin.dart',
  };

  final mixinPath = mixinPaths[cleanMixinName];
  if (mixinPath == null) {
    return [];
  }

  final mixinFile = File(mixinPath);
  if (!mixinFile.existsSync()) {
    return [];
  }

  try {
    final mixinContent = mixinFile.readAsStringSync();
    final parseResult = parseString(content: mixinContent);

    if (parseResult.errors.isNotEmpty) {
      return [];
    }

    // Extract methods from the mixin that return type T
    final methodVisitor = StyleMethodVisitor('T');
    parseResult.unit.visitChildren(methodVisitor);

    // Update return types to the actual style class name
    return methodVisitor.methods.map((method) {
      return MethodInfo(
        name: method.name,
        returnType: returnType,
        parameters: method.parameters,
        docComment: method.docComment,
      );
    }).toList();
  } catch (e) {
    return [];
  }
}

String _generateMarkdown(List<MethodInfo> methods) {
  final buffer = StringBuffer();
  buffer.writeln('### Style Methods\n');

  for (final method in methods) {
    // Format: #### `methodName(parameters)`
    final params = method.parameters
        .map((p) {
          final param = '${p.type} ${p.name}';

          return p.defaultValue != null ? '$param = ${p.defaultValue}' : param;
        })
        .join(', ');

    buffer.writeln('#### `${method.name}($params)`\n');

    if (method.docComment != null && method.docComment!.isNotEmpty) {
      buffer.writeln('${method.docComment}\n');
    }
  }

  return buffer.toString();
}

Future<void> _updateDocumentation(File docFile, String markdown) async {
  var content = await docFile.readAsString();

  // Strategy: Replace everything after "## Properties" with the generated markdown

  final propertiesHeaderPattern = RegExp(r'## Properties\n', multiLine: true);

  final propertiesMatch = propertiesHeaderPattern.firstMatch(content);

  if (propertiesMatch != null) {
    // Replace everything after "## Properties"
    final propertiesEnd = propertiesMatch.start;
    content =
        content.substring(0, propertiesEnd) + '## Properties\n' + markdown;
  } else {
    // No Properties section found, append at the end
    content += '\n\n## Properties\n\n' + markdown;
  }

  await docFile.writeAsString(content);
}
