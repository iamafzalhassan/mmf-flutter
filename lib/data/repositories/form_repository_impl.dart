import 'package:dartz/dartz.dart';
import 'package:mmf/core/error/failure.dart';
import 'package:mmf/core/error/submission_exception.dart';
import 'package:mmf/data/datasources/form_remote_data_source.dart';
import 'package:mmf/domain/entities/main_form.dart';
import 'package:mmf/domain/repositories/form_repository.dart';

class FormRepositoryImpl implements FormRepository {
  final FormRemoteDataSource _remoteDataSource;

  FormRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> submitForm(MainForm mainForm) async {
    try {
      await _remoteDataSource.submitForm(mainForm);
      return const Right(null);
    } on SubmissionException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return const Left(Failure('Submission failed'));
    }
  }
}
