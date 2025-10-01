import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SpinnerExample(),
      ),
    ),
  );
}

class SpinnerExample extends StatefulWidget {
  const SpinnerExample({super.key});

  @override
  State<SpinnerExample> createState() => _SpinnerExampleState();
}

class _SpinnerExampleState extends State<SpinnerExample> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            RemixSpinner(style: styleSolid),
            RemixSpinner(style: styleDotted),
          ],
        ),
      ),
    );
  }

  RemixSpinnerStyle get styleSolid {
    return RemixSpinnerStyle()
        .spinnerType(SpinnerType.solid)
        .color(Colors.blue);
  }

  RemixSpinnerStyle get styleDotted {
    return RemixSpinnerStyle()
        .spinnerType(SpinnerType.dotted)
        .duration(2.s)
        .color(Colors.redAccent);
  }
}
