import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mmf/data/datasources/form_remote_data_source.dart';
import 'package:mmf/data/repositories/form_repository_impl.dart';
import 'package:mmf/domain/repositories/form_repository.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'package:mmf/presentation/cubits/main_form_cubit.dart';

final serviceLocator = GetIt.instance;

void initDependencies() {
  serviceLocator
    ..registerLazySingleton(http.Client.new)
    ..registerLazySingleton<FormRemoteDataSource>(() => FormRemoteDataSourceImpl(serviceLocator()))
    ..registerLazySingleton<FormRepository>(() => FormRepositoryImpl(serviceLocator()))
    ..registerLazySingleton(() => SubmitForm(serviceLocator()))
    ..registerFactory(() => MainFormCubit(serviceLocator()));
}
