import 'package:fleetcarpooling/screens/admin/admin_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/widgets/add_vehicle_selection.dart';
import 'package:core/ui_elements/buttons.dart';

void main() {
  testWidgets('AdminHomePage Renders Main Title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdminHomePage()));
    expect(find.text('FLEET CARPOOLING'), findsOneWidget);
  });

  testWidgets('AdminHomePage Displays Profile Icon',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdminHomePage()));
    final profileIconGestureDetector = find.byKey(const Key('profileIcon'));
    expect(profileIconGestureDetector, findsOneWidget);
  });

  testWidgets('AdminHomePage Displays Buttons', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdminHomePage()));
    expect(find.byType(MyElevatedButton), findsNWidgets(5));
  });

  testWidgets('AdminHomePage Displays "ADD NEW USER" Button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdminHomePage()));

    expect(find.text('ADD NEW USER'), findsOneWidget);
  });

  testWidgets('AdminHomePage Navigates to Add Vehicle Selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdminHomePage()));
    await tester.tap(find.text('ADD NEW CAR'));
    await tester.pumpAndSettle();
    expect(find.byType(AddVehicleSelection), findsOneWidget);
  });

  testWidgets('AdminHomePage Displays "LIST ALL CARS" Button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdminHomePage()));

    expect(find.text('LIST ALL CARS'), findsOneWidget);
  });

  testWidgets('AdminHomePage Displays "LIST ALL USERS" Button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdminHomePage()));

    expect(find.text('LIST ALL USERS'), findsOneWidget);
  });

  testWidgets('AdminHomePage Displays "LIST ALL RESERVATIONS" Button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdminHomePage()));

    expect(find.text('LIST ALL RESERVATIONS'), findsOneWidget);
  });
}
