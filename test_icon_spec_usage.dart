import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  // Test IconSpec usage patterns
  const iconSpec = IconSpec(
    color: Colors.blue,
    size: 24,
  );
  
  const iconData = Icons.star;
  
  // Method 1: Using fromSpec (new pattern)
  final widget1 = StyledIcon.fromSpec(iconSpec, icon: iconData);
  print('fromSpec pattern works: ${widget1.runtimeType}');
  
  // Method 2: Try what label widget does
  // This should fail based on the IconSpec definition
  // final widget2 = iconSpec(icon: iconData);
  
  print('Test complete');
}