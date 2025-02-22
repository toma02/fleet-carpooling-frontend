import 'package:core/ui_elements/buttons.dart';
import 'package:core/ui_elements/text_field.dart';
import 'package:fleetcarpooling/screens/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('LoginForm Widget Tests', () {
    testWidgets('Renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoginForm()),
        ),
      );

      expect(find.text('FLEET CARPOOLING'), findsOneWidget);
      expect(find.text('SIGN IN TO CONTINUE'), findsOneWidget);
      expect(find.byType(MyTextField), findsNWidgets(2));
      expect(find.byType(MyElevatedButton), findsOneWidget);
    });
  });
}
