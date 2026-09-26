import 'package:dartz/dartz.dart';
import 'package:mmf/core/error/failure.dart';
import 'package:mmf/domain/entities/main_form.dart';
import 'package:mmf/domain/repositories/form_repository.dart';

class SubmitForm {
  final FormRepository _repository;

  SubmitForm(this._repository);

  Future<Either<Failure, void>> call(MainForm mainForm) => _repository.submitForm(mainForm);
}
