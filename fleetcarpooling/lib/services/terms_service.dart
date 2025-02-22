import '../Models/terms_model.dart';

class TermsService {
  List<DateTime> createWorkHours(DateTime start, DateTime end) {
    List<DateTime> radniSati = [];
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      for (int j = 7; j <= 16; j++) {
        radniSati.add(DateTime(start.year, start.month, start.day + i, j));
      }
    }
    return radniSati;
  }

  List<DateTime> extractReservedTerms(List<Terms> terms) {
    var start = 7;
    var end = 17;

    var reservedTerms = <DateTime>[];

    for (var reservation in terms) {
      var currentDay = reservation.pickupDate;

      while (currentDay
          .isBefore(reservation.returnDate.add(const Duration(hours: 1)))) {
        if (currentDay.hour >= start && currentDay.hour < end) {
          reservedTerms.add(currentDay);
        }

        currentDay = currentDay.add(const Duration(hours: 1));
      }
    }

    return reservedTerms;
  }
}
