import 'package:core/ui_elements/colors';
import 'package:fleetcarpooling/Models/terms_model.dart';
import 'package:fleetcarpooling/services/reservation_service.dart';
import 'package:fleetcarpooling/services/terms_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatelessWidget {
  final double height;
  final double width;
  final String vin;
  const MyCalendar(
      {Key? key, required this.height, required this.width, required this.vin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TermsService termsService = TermsService();
    final ReservationService service = ReservationService();
    late List<DateTime> busyTerms;
    late List<DateTime> freeTerms;
    DateTime initialFocusedDay = DateTime.now();
    initialFocusedDay =
        DateTime(initialFocusedDay.year, initialFocusedDay.month, 1);

    return StreamBuilder<List<Terms>>(
      stream: service.getReservationStream(vin),
      initialData: const [],
      builder: (context, snapshot) {
        List<DateTime> workHours = termsService.createWorkHours(
            DateTime.now(), DateTime.now().add(const Duration(days: 365)));
        busyTerms = termsService.extractReservedTerms(snapshot.data ?? []);

        freeTerms =
            workHours.where((termin) => !busyTerms.contains(termin)).toList();

        return Column(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: TableCalendar(
                rowHeight: 35,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: initialFocusedDay,
                onPageChanged: (focusedDay) {
                  DateTime newFocusedDay =
                      DateTime(focusedDay.year, focusedDay.month, 1);
                  initialFocusedDay = newFocusedDay;
                },
                calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    todayTextStyle: TextStyle(
                      color: AppColors.activeDays,
                    ),
                    weekendTextStyle: TextStyle(color: AppColors.mainTextColor),
                    disabledTextStyle: TextStyle(
                      color: AppColors.unavailableColor,
                    ),
                    selectedTextStyle: TextStyle(
                      color: AppColors.activeDays,
                    ),
                    defaultTextStyle: TextStyle(color: AppColors.activeDays)),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainTextColor),
                  leftChevronIcon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.mainTextColor),
                  rightChevronIcon: Transform.rotate(
                    angle: 3.141592,
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.mainTextColor),
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (day, locale) {
                    final weekdayFormat = DateFormat('E', locale);
                    final formattedDay = weekdayFormat.format(day);
                    switch (formattedDay) {
                      case 'Mon':
                        return 'M';
                      case 'Tue':
                        return 'T';
                      case 'Wed':
                        return 'W';
                      case 'Thu':
                        return 'T';
                      case 'Fri':
                        return 'F';
                      case 'Sat':
                        return 'S';
                      case 'Sun':
                        return 'S';
                      default:
                        return formattedDay;
                    }
                  },
                  weekdayStyle: const TextStyle(color: AppColors.activeDays),
                  weekendStyle: const TextStyle(color: AppColors.activeDays),
                ),
                enabledDayPredicate: (day) {
                  return day.isAfter(
                      DateTime.now().subtract(const Duration(days: 1)));
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (freeTerms.any((termin) => isSameDay(termin, day))) {
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle()
                              .copyWith(color: AppColors.activeDays),
                        ),
                      );
                    } else if (busyTerms
                        .any((termin) => isSameDay(termin, day))) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: AppColors.reservedInCalendar,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle()
                                .copyWith(color: AppColors.mainTextColor),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  _showAvailableHoursAlert(context, selectedDay, freeTerms);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAvailableHoursAlert(
      BuildContext context, DateTime selectedDay, List<DateTime> freeTerms) {
    List<DateTime> availableHours =
        freeTerms.where((termin) => isSameDay(termin, selectedDay)).toList();

    String availableHoursString =
        availableHours.map((hour) => DateFormat.Hm().format(hour)).join(', ');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context)
              .copyWith(dialogBackgroundColor: AppColors.backgroundColor),
          child: AlertDialog(
            content: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Hours on ${DateFormat.yMMMd().format(selectedDay)}\n\nAvailable hours for pick up: $availableHoursString',
                    style: const TextStyle(
                      color: AppColors.mainTextColor,
                      fontSize: 18,
                    ),
                  ),
                  Expanded(child: Container()),
                  Image.asset(
                    'assets/images/logo_login.png', // Replace with your image asset
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}
