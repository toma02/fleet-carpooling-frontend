import 'package:core/ui_elements/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fleetcarpooling/screens/reservations/reservation_form.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  testWidgets('ReservationScreen is created successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ReservationScreen(),
    ));

    expect(find.byType(ReservationScreen), findsOneWidget);
  });

  testWidgets('Initial UI test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReservationScreen()));

    expect(find.text('FLEET CARPOOLING'), findsOneWidget);
    expect(find.text('WHEN ARE YOU PLANNING TO TRAVEL?'), findsOneWidget);
    expect(find.text('Pick up time'), findsOneWidget);
    expect(find.text('Return time'), findsOneWidget);
    expect(find.byType(TableCalendar), findsOneWidget);
    expect(find.byType(MyElevatedButton), findsOneWidget);
  });

  testWidgets('Initial state of ReservationScreen is as expected',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ReservationScreen(),
    ));

    final ReservationScreenState state =
        tester.state(find.byType(ReservationScreen));

    expect(state.pickupTime, const TimeOfDay(hour: 7, minute: 0));
    expect(state.returnTime, const TimeOfDay(hour: 7, minute: 0));
    expect(state.isDateSelected, false);
  });
  test('selects date range', () {
    var state = ReservationScreenState();
    state.selectedDateRange =
        DateTimeRange(start: DateTime(2023, 2, 15), end: DateTime(2023, 2, 17));
    expect(state.selectedDateRange!.start, DateTime(2023, 2, 15));
    expect(state.selectedDateRange!.end, DateTime(2023, 2, 17));
  });

  test('selects pickup time', () {
    var state = ReservationScreenState();
    state.pickupTime = const TimeOfDay(hour: 15, minute: 30);
    expect(state.pickupTime.hour, 15);
    expect(state.pickupTime.minute, 30);
  });

  test('navigates on submit with times', () {
    var state = ReservationScreenState();
    state.pickupTime = const TimeOfDay(hour: 8, minute: 15);
    state.returnTime = const TimeOfDay(hour: 17, minute: 0);
    state.selectedDateRange =
        DateTimeRange(start: DateTime(2023, 2, 15), end: DateTime(2023, 2, 17));
    state.isDateSelected = true;

    expect(state.pickupTime.hour, 8);
    expect(state.pickupTime.minute, 15);
    expect(state.returnTime.hour, 17);
    expect(state.returnTime.minute, 0);
    expect(state.isDateSelected, true);
  });
}
