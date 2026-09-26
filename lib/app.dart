import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/di/injection_container.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'package:mmf/presentation/cubits/main_form_cubit.dart';
import 'package:mmf/presentation/pages/mahalla_form_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => serviceLocator<MainFormCubit>(), child: MaterialApp(debugShowCheckedModeBanner: false, home: const MahallaFormPage(), theme: AppTheme.light, title: 'Mahalla Members Form'));
}
