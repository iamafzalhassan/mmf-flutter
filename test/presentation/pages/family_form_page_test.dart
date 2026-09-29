import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/presentation/cubits/main_form_cubit.dart';
import 'package:mmf/presentation/pages/family_form_page.dart';

void main() {
  Future<void> validate(WidgetTester tester, FamilyMember member) async {
    await tester.pumpWidget(MaterialApp(home: FamilyFormPage(key: UniqueKey(), existingMember: member)));
    tester.state<FormState>(find.byType(Form)).validate();
    await tester.pump();
  }

  group('FamilyFormPage phone validation', () {
    testWidgets('requires a mobile number for the Head of Family', (tester) async {
      await validate(tester, const FamilyMember(relationship: MainFormCubit.headOfFamily));

      expect(find.text('Mobile number is required for Head of Family'), findsOneWidget);
    });

    testWidgets('allows other members to leave the mobile number blank', (tester) async {
      await validate(tester, const FamilyMember(relationship: 'Son'));

      expect(find.text('Mobile number is required for Head of Family'), findsNothing);
      expect(find.text('Invalid mobile number'), findsNothing);
    });

    testWidgets('refuses numbers that are not ten digits starting with 07', (tester) async {
      await validate(tester, const FamilyMember(mobile: '0812345678', relationship: 'Son', whatsappNo: '077123'));

      expect(find.text('Invalid mobile number'), findsOneWidget);
      expect(find.text('Invalid WhatsApp number'), findsOneWidget);
    });

    testWidgets('accepts ten-digit numbers starting with 07', (tester) async {
      await validate(tester, const FamilyMember(mobile: '0771234567', relationship: MainFormCubit.headOfFamily, whatsappNo: '0761234567'));

      expect(find.text('Mobile number is required for Head of Family'), findsNothing);
      expect(find.text('Invalid mobile number'), findsNothing);
      expect(find.text('Invalid WhatsApp number'), findsNothing);
    });
  });

  group('FamilyFormPage A/L year validation', () {
    testWidgets('hides the A/L year until A/L is ticked', (tester) async {
      await validate(tester, const FamilyMember());

      expect(find.text('A/L year is required'), findsNothing);
    });

    testWidgets('requires an A/L year when A/L is ticked', (tester) async {
      await validate(tester, const FamilyMember(schoolEducation: <String>['A/L']));

      expect(find.text('A/L year is required'), findsOneWidget);
    });

    testWidgets('refuses a year before 1950', (tester) async {
      await validate(tester, const FamilyMember(alYear: '1949', schoolEducation: <String>['A/L']));

      expect(find.text('Enter a valid year'), findsOneWidget);
    });

    testWidgets('refuses a year after next year', (tester) async {
      await validate(tester, FamilyMember(alYear: '${DateTime.now().year + 2}', schoolEducation: const <String>['A/L']));

      expect(find.text('Enter a valid year'), findsOneWidget);
    });

    testWidgets('accepts years from 1950 to next year', (tester) async {
      for (final String year in <String>['1950', '${DateTime.now().year + 1}']) {
        await validate(tester, FamilyMember(alYear: year, schoolEducation: const <String>['A/L']));

        expect(find.text('A/L year is required'), findsNothing);
        expect(find.text('Enter a valid year'), findsNothing);
      }
    });
  });
}
