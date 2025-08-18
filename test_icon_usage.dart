import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void testIconSpec() {
  // Create an IconSpec
  const iconSpec = IconSpec(
    color: Colors.blue,
    size: 24,
  );
  
  // Try to call it with an IconData
  // This should show us what methods are available
  final iconData = Icons.star;
  
  // Try using fromSpec pattern
  final widget1 = StyledIcon.fromSpec(iconSpec, icon: iconData);
  
  // Try named parameter (what label widget uses)  
  // final widget2 = iconSpec(icon: iconData);
  
  print('Test complete');
}