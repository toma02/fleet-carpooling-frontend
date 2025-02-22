import 'package:fleetcarpooling/Models/terms_model.dart';
import 'package:fleetcarpooling/services/terms_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TermsService? termsService;
  setUp(() {
    termsService = TermsService();
  });
  group("DisplayTerms", () {
    test('createWorkHours creates correct work hours', () {
      // Define test data
      final start = DateTime(2024, 1, 1);
      final end = DateTime(2024, 1, 3);

      final workHours = termsService!.createWorkHours(start, end);

      expect(workHours.length, 30);
    });
    test('createWorkHours start with good work hour', () {
      final start = DateTime(2024, 1, 1);
      final end = DateTime(2024, 1, 3);

      final workHours = termsService!.createWorkHours(start, end);

      expect(workHours.first, DateTime(2024, 1, 1, 7));
    });
    test('createWorkHours end with good work hour', () {
      final start = DateTime(2024, 1, 1);
      final end = DateTime(2024, 1, 3);

      final workHours = termsService!.createWorkHours(start, end);

      expect(workHours.last, DateTime(2024, 1, 3, 16));
    });

    test('extractReservedTerms handles empty terms list', () {
      final terms = <Terms>[];

      final reservedTerms = termsService!.extractReservedTerms(terms);
      expect(reservedTerms, isEmpty);
    });

    test('extractReservedTerms handles terms outside of work hours', () {
      final terms = [
        Terms(
          DateTime(2024, 1, 1, 5),
          DateTime(2024, 1, 1, 6),
        ),
        Terms(
          DateTime(2024, 1, 2, 17),
          DateTime(2024, 1, 2, 18),
        ),
      ];

      final reservedTerms = termsService!.extractReservedTerms(terms);

      expect(reservedTerms, isEmpty);
    });

    test('extractReservedTerms returns correct reserved terms', () {
      final terms = [
        Terms(
          DateTime(2024, 1, 1, 8),
          DateTime(2024, 1, 1, 10),
        ),
        Terms(
          DateTime(2024, 1, 2, 9),
          DateTime(2024, 1, 2, 11),
        ),
      ];

      final reservedTerms = termsService!.extractReservedTerms(terms);

      expect(reservedTerms.length, 6);
    });
    test('extractReservedTerms end with good work hour', () {
      final terms = [
        Terms(
          DateTime(2024, 1, 1, 8),
          DateTime(2024, 1, 1, 10),
        ),
        Terms(
          DateTime(2024, 1, 2, 9),
          DateTime(2024, 1, 2, 11),
        ),
      ];

      final reservedTerms = termsService!.extractReservedTerms(terms);
      expect(reservedTerms.first, DateTime(2024, 1, 1, 8));
    });
    test('extractReservedTerms end with good work hour', () {
      final terms = [
        Terms(
          DateTime(2024, 1, 1, 8),
          DateTime(2024, 1, 1, 10),
        ),
        Terms(
          DateTime(2024, 1, 2, 9),
          DateTime(2024, 1, 2, 11),
        ),
      ];
      final reservedTerms = termsService!.extractReservedTerms(terms);
      expect(reservedTerms.last, DateTime(2024, 1, 2, 11));
    });
  });
}
