import 'package:flutter_test/flutter_test.dart';
import 'package:mmf/core/error/failure.dart';
import 'package:mmf/core/error/submission_exception.dart';
import 'package:mmf/data/datasources/form_remote_data_source.dart';
import 'package:mmf/data/repositories/form_repository_impl.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/main_form.dart';

class FakeFormRemoteDataSource implements FormRemoteDataSource {
  final Object? error;

  FakeFormRemoteDataSource([this.error]);

  @override
  Future<void> submitForm(MainForm mainForm) async {
    if (error != null) throw error!;
  }
}

void main() {
  final MainForm form = MainForm(address: 'No 12, Main Street', admissionNo: '', familiesCount: '1', ownership: 'Own', refNo: 'KJM-123456', route: 'Walewala', familyMembers: const <FamilyMember>[]);

  Future<Failure?> failureFor(FakeFormRemoteDataSource dataSource) async => (await FormRepositoryImpl(dataSource).submitForm(form)).fold((failure) => failure, (_) => null);

  group('FormRepositoryImpl.submitForm', () {
    test('returns success when the data source completes', () async {
      expect(await failureFor(FakeFormRemoteDataSource()), isNull);
    });

    test('carries the submission message without an exception prefix', () async {
      final Failure? failure = await failureFor(FakeFormRemoteDataSource(const SubmissionException('Network error. Please check your connection.')));

      expect(failure?.message, 'Network error. Please check your connection.');
    });

    test('reports an unexpected error as a failed submission', () async {
      final Failure? failure = await failureFor(FakeFormRemoteDataSource(StateError('boom')));

      expect(failure?.message, 'Submission failed');
    });
  });
}
