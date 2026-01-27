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

    // Also try to extract widget properties
    final widgetFile = File(
      file.path.replaceAll('_style.dart', '_widget.dart'),
    );
    List<PropertyInfo> widgetProperties = [];
    if (await widgetFile.exists()) {
      final widgetContent = await widgetFile.readAsString();
      widgetProperties = _extractWidgetProperties(widgetContent, componentName);
      print('  Found ${widgetProperties.length} widget properties');
    }

    if (methods.isNotEmpty || widgetProperties.isNotEmpty) {
      if (methods.isNotEmpty) {
        print('  Found ${methods.length} style methods');
      }

      // Generate markdown documentation
      final markdown = _generateMarkdown(methods, widgetProperties);

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

class PropertyInfo {
  final String name;
  final String type;
  final bool isRequired;
  final String? docComment;

  const PropertyInfo({
    required this.name,
    required this.type,
    required this.isRequired,
    this.docComment,
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

class WidgetPropertyVisitor extends RecursiveAstVisitor<void> {
  final String componentName;
  final List<PropertyInfo> properties = [];
  final Map<String, String> fieldDocs = {};
  final Map<String, String> fieldTypes = {};

  WidgetPropertyVisitor(this.componentName);

  void _extractConstructorParameters(FormalParameterList params) {
    // Process all parameters from the constructor
    for (final param in params.parameters) {
      String? name;
      String type = 'dynamic';
      bool isRequired = false;
      print('param: $param');

      // Handle all parameter types
      if (param is DefaultFormalParameter) {
        // This is an optional parameter with a default value
        final innerParam = param.parameter;
        name = innerParam.name?.toString();
        isRequired = param.isRequired;

        // Get type from field declaration if it's a field formal parameter
        if (innerParam is FieldFormalParameter) {
          final fieldName = name ?? '';
          if (fieldTypes.containsKey(fieldName)) {
            type = fieldTypes[fieldName]!;
          } else {
            type = innerParam.type?.toString() ?? 'dynamic';
          }
        } else if (innerParam is SuperFormalParameter) {
          // super.fieldName parameter
          if (innerParam.type != null) {
            type = innerParam.type.toString();
          } else {
            type = 'Key?'; // Default for super.key
          }
        } else {
          type = _getParameterType(innerParam);
        }
      } else if (param is SimpleFormalParameter) {
        // Simple parameter with type annotation
        name = param.name?.toString();
        type = param.type?.toString() ?? 'dynamic';
        isRequired = param.isRequired;
      } else if (param is FieldFormalParameter) {
        // this.fieldName parameter (required)
        name = param.name.toString();
        isRequired = param.isRequired;

        // Try to get type from field declaration first
        if (fieldTypes.containsKey(name)) {
          type = fieldTypes[name]!;
        } else if (param.type != null) {
          type = param.type.toString();
        }
      } else if (param is SuperFormalParameter) {
        // super.fieldName parameter
        name = param.name.toString();
        isRequired = param.isRequired;

        if (param.type != null) {
          type = param.type.toString();
        } else {
          type = 'Key?'; // Default for super.key
        }
      } else if (param is FunctionTypedFormalParameter) {
        // Function parameter
        name = param.name.toString();
        isRequired = param.isRequired;
        type = param.returnType?.toString() ?? 'Function';
      } else {
        // Unknown parameter type, skip
        print('  ⚠ Unknown parameter type: ${param.runtimeType}');
        continue;
      }

      // Skip if we couldn't extract a name
      if (name == null || name.isEmpty) {
        continue;
      }

      // Get doc comment, or use default for common parameters
      String? docComment = fieldDocs[name];
      if (docComment == null && name == 'key') {
        docComment =
            'Controls how one widget replaces another widget in the tree.';
      }

      properties.add(
        PropertyInfo(
          name: name,
          type: type,
          isRequired: isRequired,
          docComment: docComment,
        ),
      );
    }
  }

  String _getParameterType(NormalFormalParameter param) {
    if (param is SimpleFormalParameter) {
      return param.type?.toString() ?? 'dynamic';
    } else if (param is FieldFormalParameter) {
      return param.type?.toString() ?? 'dynamic';
    } else if (param is SuperFormalParameter) {
      return param.type?.toString() ?? 'Key?';
    } else if (param is FunctionTypedFormalParameter) {
      return param.returnType?.toString() ?? 'Function';
    }

    return 'dynamic';
  }

  String? _extractDocComment(Comment? comment) {
    if (comment == null) return null;
    final docLines = <String>[];
    for (final token in comment.tokens) {
      final line = token.toString().trim();
      if (line.startsWith('///')) {
        docLines.add(line.substring(3).trim());
      }
    }
    return docLines.isNotEmpty ? docLines.join(' ') : null;
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final className = node.name.toString();
    // Look for the widget class (e.g., RemixButton)
    final expectedClassName = 'Remix${_capitalize(componentName)}';
    print(expectedClassName);
    if (className.toLowerCase() == expectedClassName.toLowerCase()) {
      // First pass: collect field documentation and types
      for (final member in node.members) {
        if (member is FieldDeclaration) {
          final docComment = _extractDocComment(member.documentationComment);
          final type = member.fields.type?.toString();
          for (final variable in member.fields.variables) {
            final fieldName = variable.name.toString();
            if (docComment != null) {
              fieldDocs[fieldName] = docComment;
            }
            if (type != null) {
              fieldTypes[fieldName] = type;
            }
          }
        }
      }

      // Second pass: extract constructor parameters
      for (final member in node.members) {
        if (member is ConstructorDeclaration && member.name == null) {
          // This is the default constructor
          _extractConstructorParameters(member.parameters);
        }
      }
    }
    super.visitClassDeclaration(node);
  }
}

String _capitalize(String s) {
  if (s.isEmpty) return s;

  // Convert snake_case to PascalCase
  return s
      .split('_')
      .map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1);
      })
      .join('');
}

List<PropertyInfo> _extractWidgetProperties(
  String content,
  String componentName,
) {
  try {
    final parseResult = parseString(content: content);

    if (parseResult.errors.isNotEmpty) {
      return [];
    }

    final visitor = WidgetPropertyVisitor(componentName);
    parseResult.unit.visitChildren(visitor);

    return visitor.properties;
  } catch (e, stackTrace) {
    print('  ⚠ Error extracting properties from $componentName: $e');
    print('     Stack trace: $stackTrace');
    return [];
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
  } catch (e, stackTrace) {
    print('  ⚠ Error extracting methods from mixin $mixinName: $e');
    print('     Stack trace: $stackTrace');
    return [];
  }
}

String _generateMarkdown(
  List<MethodInfo> methods,
  List<PropertyInfo> properties,
) {
  final buffer = StringBuffer();

  // Generate Widget Properties section first
  if (properties.isNotEmpty) {
    buffer.writeln('### Widget Properties\n');

    for (final property in properties) {
      // Format: #### `propertyName` → `Type`
      buffer.writeln('#### `${property.name}` → `${property.type}`\n');

      // Add required/optional indicator
      if (property.isRequired) {
        buffer.write('**Required**. ');
      } else {
        buffer.write('Optional. ');
      }

      // Add doc comment
      if (property.docComment != null && property.docComment!.isNotEmpty) {
        buffer.writeln('${property.docComment}\n');
      } else {
        buffer.writeln('\n');
      }
    }

    buffer.writeln();
  }

  // Generate Style Methods section
  if (methods.isNotEmpty) {
    buffer.writeln('### Style Methods\n');

    for (final method in methods) {
      // Format: #### `methodName(parameters)`
      final params = method.parameters
          .map((p) {
            final param = '${p.type} ${p.name}';
            return p.defaultValue != null
                ? '$param = ${p.defaultValue}'
                : param;
          })
          .join(', ');

      buffer.writeln('#### `${method.name}($params)`\n');

      if (method.docComment != null && method.docComment!.isNotEmpty) {
        buffer.writeln('${method.docComment}\n');
      }
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
