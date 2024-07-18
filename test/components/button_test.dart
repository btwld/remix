void main() {
  // group('RemixButton', () {
  //   testWidgets('renders with correct label', (WidgetTester tester) async {
  //     const label = 'Test Button';
  //     await tester.pumpWidget(
  //       MaterialApp(
  //         home: RxButton(label: label, onPressed: () {}),
  //       ),
  //     );

  //     expect(
  //       find.byWidgetPredicate(
  //         (widget) => widget is Text && widget.data == label,
  //       ),
  //       findsOneWidget,
  //     );
  //   });

  //   testWidgets('shows loading indicator and label when isLoading is true',
  //       (WidgetTester tester) async {
  //     const loadingLabel = 'Loading...';

  //     await tester.pumpWidget(
  //       MaterialApp(
  //         home: RxButton(
  //           label: 'Test Button',
  //           loading: true,
  //           onPressed: () {},
  //         ),
  //       ),
  //     );

  //     expect(find.byType(CircularProgressIndicator), findsOneWidget);
  //     expect(find.text(loadingLabel), findsOneWidget);
  //   });

  //   testWidgets('displays correct icons when provided',
  //       (WidgetTester tester) async {
  //     await tester.pumpWidget(MaterialApp(
  //       home: RxButton(
  //         label: 'Test Button',
  //         iconLeft: Icons.arrow_back,
  //         iconRight: Icons.arrow_forward,
  //         onPressed: () {},
  //       ),
  //     ));

  //     expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  //     expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

  //     final HBox iconRow = tester.widget(find.byType(HBox));
  //     expect(iconRow.children.first, isInstanceOf<StyledIcon>());
  //     expect((iconRow.children.first as StyledIcon).icon, Icons.arrow_back);
  //     expect(iconRow.children.last, isInstanceOf<StyledIcon>());
  //     expect((iconRow.children.last as StyledIcon).icon, Icons.arrow_forward);
  //   });
  // });

  // testWidgets('when disabled must not call onPressed',
  //     (WidgetTester tester) async {
  //   bool didCallOnPressed = false;

  //   await tester.pumpWidget(MaterialApp(
  //     home: RxButton(
  //       label: 'Disabled Button',
  //       onPressed: () {
  //         didCallOnPressed = true;
  //       },
  //       disabled: true,
  //     ),
  //   ));

  //   await tester.tap(find.byType(RxButton));
  //   await tester.pumpAndSettle(const Duration(milliseconds: 200));

  //   expect(didCallOnPressed, false);
  // });

  // testWidgets('when enabled must call onPressed', (WidgetTester tester) async {
  //   bool didCallOnPressed = false;

  //   await tester.pumpWidget(MaterialApp(
  //     home: RxButton(
  //       label: 'Disabled Button',
  //       onPressed: () {
  //         didCallOnPressed = true;
  //       },
  //     ),
  //   ));

  //   await tester.tap(find.byType(RxButton));
  //   await tester.pumpAndSettle(const Duration(milliseconds: 200));

  //   expect(didCallOnPressed, isTrue);
  // });
}
