import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart' as remix;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthBlock(),
    );
  }
}

class AuthBlock extends StatefulWidget {
  const AuthBlock({super.key});

  @override
  State<AuthBlock> createState() => _AuthBlockState();
}

class _AuthBlockState extends State<AuthBlock> {
  bool showPassword = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                ),
                Row(
                  spacing: 8,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontSize: 15),
                    ),
                    remix.RemixButton(
                      onPressed: () {},
                      label: 'Create account',
                      // style: LinkButtonStyle(),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                FlexBox(
                  direction: Axis.vertical,
                  style: $flexbox
                    ..border.all.color.grey(300)
                    ..clipBehavior(Clip.antiAlias)
                    ..color.grey(300)
                    ..borderRadius.circular(8),
                  children: [
                    remix.RemixTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      // style: TextFieldStyle(),
                    ),
                    remix.RemixTextField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      hintText: 'Password',
                      trailing: remix.RemixButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        label: showPassword ? 'Hide' : 'Show',
                      ),
                      // style: TextFieldStyle(),
                    ),
                  ],
                ),
                remix.RemixButton(
                  label: 'Forgot password?',
                  onPressed: () {},
                  // style: LinkButtonStyle(),
                ),
                remix.RemixButton(
                  onPressed: () {},
                  label: 'Sign in',
                  // Custom style needed - using defaults for now
                ),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                const Expanded(child: remix.RemixDivider()),
                StyledText(
                  'or',
                  style: $text..color.grey(500),
                ),
                const Expanded(child: remix.RemixDivider()),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                remix.RemixButton(
                  label: 'Continue with Apple',
                  onPressed: () {},
                  leading: Icons.apple,
                  // style: SocialMediaButtonStyle(),
                ),
                remix.RemixButton(
                  label: 'Continue with Facebook',
                  onPressed: () {},
                  leading: Icons.facebook,
                  // style: SocialMediaButtonStyle(),
                ),
                remix.RemixButton(
                  label: 'Show more options',
                  onPressed: () {},
                  leading: Icons.add,
                  // style: SocialMediaButtonStyle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom styles are now applied inline in the components above
// This follows the Mix 2.0 pattern where styles can be composed directly
// using the style builders and Mix utilities within each component
