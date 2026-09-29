import 'package:flutter/cupertino.dart';
import 'package:mmf/core/theme/app_spacing.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.radius = AppSpacing.loaderRadius, this.color});

  final double radius;

  final Color? color;

  @override
  Widget build(BuildContext context) => CupertinoActivityIndicator(color: color, radius: radius);
}
