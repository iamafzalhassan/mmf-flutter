import 'package:dartz/dartz.dart';
import 'package:mmf/core/error/failure.dart';
import 'package:mmf/domain/entities/main_form.dart';

abstract interface class FormRepository {
  Future<Either<Failure, void>> submitForm(MainForm mainForm);
}
