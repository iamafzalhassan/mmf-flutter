import 'package:flutter_test/flutter_test.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/presentation/cubits/family_member_cubit.dart';
import 'package:mmf/presentation/cubits/main_form_cubit.dart';

void main() {
  late FamilyMemberCubit cubit;

  setUp(() => cubit = FamilyMemberCubit(const FamilyMember()));

  tearDown(() => cubit.close());

  group('FamilyMemberCubit.toggleSchoolEducation', () {
    test('keeps the A/L year while A/L stays ticked', () {
      cubit
        ..toggleSchoolEducation('A/L')
        ..updateAlYear('2020')
        ..toggleSchoolEducation('O/L');

      expect(cubit.state.schoolEducation, <String>['A/L', 'O/L']);
      expect(cubit.state.alYear, '2020');
    });

    test('clears the A/L year when A/L is unticked', () {
      cubit
        ..toggleSchoolEducation('A/L')
        ..updateAlYear('2020')
        ..toggleSchoolEducation('A/L');

      expect(cubit.state.schoolEducation, isEmpty);
      expect(cubit.state.alYear, isEmpty);
    });
  });

  group('FamilyMemberCubit.toggleProfessionalQualification', () {
    test('keeps qualification details while any qualification is ticked', () {
      cubit
        ..toggleProfessionalQualification('Diploma')
        ..updateProfessionalQualificationsDetails('Diploma in Nursing')
        ..toggleProfessionalQualification('Degree')
        ..toggleProfessionalQualification('Diploma');

      expect(cubit.state.professionalQualifications, <String>['Degree']);
      expect(cubit.state.professionalQualificationsDetails, 'Diploma in Nursing');
    });

    test('clears qualification details when the last qualification is unticked', () {
      cubit
        ..toggleProfessionalQualification('Diploma')
        ..updateProfessionalQualificationsDetails('Diploma in Nursing')
        ..toggleProfessionalQualification('Diploma');

      expect(cubit.state.professionalQualifications, isEmpty);
      expect(cubit.state.professionalQualificationsDetails, isEmpty);
    });

    test('keeps vocational course details only while Vocational Course is ticked', () {
      cubit
        ..toggleProfessionalQualification(FamilyMemberCubit.vocationalCourse)
        ..updateVocationalCourseDetails('Plumbing')
        ..toggleProfessionalQualification('Certificate');

      expect(cubit.state.vocationalCourseDetails, 'Plumbing');

      cubit.toggleProfessionalQualification(FamilyMemberCubit.vocationalCourse);

      expect(cubit.state.professionalQualifications, <String>['Certificate']);
      expect(cubit.state.vocationalCourseDetails, isEmpty);
    });
  });

  group('FamilyMemberCubit.updateGender', () {
    test('keeps a relationship that fits the new gender', () {
      cubit
        ..updateRelationship(MainFormCubit.headOfFamily)
        ..updateGender('Female');

      expect(cubit.state.gender, 'Female');
      expect(cubit.state.relationship, MainFormCubit.headOfFamily);
    });

    test('clears a relationship that no longer fits the new gender', () {
      cubit
        ..updateGender('Male')
        ..updateRelationship('Son')
        ..updateGender('Female');

      expect(cubit.state.relationship, isEmpty);
    });

    test('drops ulama titles that no longer fit the new gender', () {
      cubit
        ..toggleUlama('Hafiz')
        ..toggleUlama('Alima')
        ..updateGender('Male');

      expect(cubit.state.ulama, <String>['Hafiz']);
    });
  });

  group('FamilyMemberCubit choices by gender', () {
    test('offers gender-specific relationships with Head of Family first', () {
      expect(FamilyMemberCubit.relationshipsFor('Male'), <String>[MainFormCubit.headOfFamily, 'Spouse', 'Son', 'Father', 'Brother', 'Grandson', 'Other']);
      expect(FamilyMemberCubit.relationshipsFor('Female'), <String>[MainFormCubit.headOfFamily, 'Spouse', 'Daughter', 'Mother', 'Sister', 'Granddaughter', 'Other']);
      expect(FamilyMemberCubit.relationshipsFor(''), hasLength(11));
    });

    test('offers gender-specific ulama titles', () {
      expect(FamilyMemberCubit.ulamaFor('Male'), <String>['Hafiz', 'Alim']);
      expect(FamilyMemberCubit.ulamaFor('Female'), <String>['Hafiza', 'Alima']);
      expect(FamilyMemberCubit.ulamaFor(''), <String>['Hafiz', 'Hafiza', 'Alim', 'Alima']);
    });
  });
}
