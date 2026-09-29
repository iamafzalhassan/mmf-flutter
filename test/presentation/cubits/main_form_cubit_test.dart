import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mmf/core/error/failure.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/main_form.dart';
import 'package:mmf/domain/repositories/form_repository.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'package:mmf/presentation/cubits/main_form_cubit.dart';

class FakeFormRepository implements FormRepository {
  final List<MainForm> submitted = <MainForm>[];

  @override
  Future<Either<Failure, void>> submitForm(MainForm mainForm) async {
    submitted.add(mainForm);
    return const Right<Failure, void>(null);
  }
}

void main() {
  FamilyMember member({required String relationship}) => FamilyMember(
      age: '42',
      alYear: '',
      civilStatus: 'Married',
      fullName: 'Mohamed Rizwan',
      gender: 'Male',
      mobile: '0771234567',
      nationalIdNo: '198412345678',
      occupation: 'Teacher',
      professionalQualificationsDetails: '',
      relationship: relationship,
      status: 'Working Only',
      vocationalCourseDetails: '',
      whatsappNo: '',
      zakath: 'No',
      madarasa: const <String>[],
      professionalQualifications: const <String>[],
      schoolEducation: const <String>[],
      specialNeeds: const <String>[],
      ulama: const <String>[]);

  late FakeFormRepository repository;
  late MainFormCubit cubit;

  setUp(() {
    repository = FakeFormRepository();
    cubit = MainFormCubit(SubmitForm(repository));
  });

  tearDown(() => cubit.close());

  group('MainFormCubit.submit', () {
    test('refuses a household without members', () async {
      await cubit.submit(fieldsValid: true);

      expect(cubit.state.errorMessage, 'Please add at least one family member.');
      expect(repository.submitted, isEmpty);
    });

    test('refuses a household without a Head of Family', () async {
      cubit.addFamilyMember(member(relationship: 'Son'));

      await cubit.submit(fieldsValid: true);

      expect(cubit.state.errorMessage, 'Please designate one member as Head of Family.');
      expect(repository.submitted, isEmpty);
    });

    test('does not submit while household fields are invalid', () async {
      cubit.addFamilyMember(member(relationship: 'Head of Family'));

      await cubit.submit(fieldsValid: false);

      expect(cubit.state.errorMessage, isNull);
      expect(repository.submitted, isEmpty);
    });

    test('submits a valid household and resets the form', () async {
      cubit
        ..updateAddress('No 12, Main Street')
        ..updateRoute('Walewala')
        ..addFamilyMember(member(relationship: 'Head of Family'));
      final String refNo = cubit.state.refNo;

      await cubit.submit(fieldsValid: true);

      expect(repository.submitted, hasLength(1));
      expect(repository.submitted.single.refNo, refNo);
      expect(repository.submitted.single.familyMembers.single.relationship, 'Head of Family');
      expect(cubit.state.isSuccess, isTrue);
      expect(cubit.state.familyMembers, isEmpty);
      expect(cubit.state.address, isEmpty);
      expect(cubit.state.refNo, startsWith('KJM-'));
    });
  });

  group('MainFormCubit.addFamilyMember', () {
    test('adds members and refuses a second Head of Family', () {
      expect(cubit.addFamilyMember(member(relationship: MainFormCubit.headOfFamily)), isTrue);
      expect(cubit.addFamilyMember(member(relationship: 'Son')), isTrue);
      expect(cubit.addFamilyMember(member(relationship: MainFormCubit.headOfFamily)), isFalse);

      expect(cubit.state.familyMembers.map((m) => m.relationship), <String>[MainFormCubit.headOfFamily, 'Son']);
    });
  });

  group('MainFormCubit.updateFamilyMember', () {
    test('lets the head be edited but refuses making another member head', () {
      cubit
        ..addFamilyMember(member(relationship: MainFormCubit.headOfFamily))
        ..addFamilyMember(member(relationship: 'Son'));

      expect(cubit.updateFamilyMember(0, member(relationship: MainFormCubit.headOfFamily)), isTrue);
      expect(cubit.updateFamilyMember(1, member(relationship: MainFormCubit.headOfFamily)), isFalse);

      expect(cubit.state.familyMembers.map((m) => m.relationship), <String>[MainFormCubit.headOfFamily, 'Son']);
    });
  });

  group('MainFormCubit.hasExistingHead', () {
    test('ignores the member being edited', () {
      cubit.addFamilyMember(member(relationship: 'Head of Family'));

      expect(cubit.hasExistingHead(), isTrue);
      expect(cubit.hasExistingHead(excludeIndex: 0), isFalse);
    });
  });
}
