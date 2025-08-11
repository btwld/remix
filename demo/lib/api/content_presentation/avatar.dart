import 'package:flutter/material.dart';
import 'package:remix/remix_new.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              const RemixAvatar(
                label: 'CA',
                backgroundImage:
                    NetworkImage('https://i.pravatar.cc/150?img=48'),
              ),
              const RemixAvatar(
                label: 'CA',
                foregroundImage:
                    NetworkImage('https://i.pravatar.cc/150?img=48'),
              ),
              const RemixAvatar(
                foregroundImage:
                    NetworkImage('https://i.pravatar.cc/150?img=48'),
                icon: Icons.person,
              ),
              RemixAvatar(
                backgroundImage:
                    const NetworkImage('https://i.pravatar.cc/150?img=48'),
                icon: Icons.person,
                style: AvatarStyle.iconColor(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
