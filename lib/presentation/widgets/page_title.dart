import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_colors.dart';

class PageTitle extends StatelessWidget {
  const PageTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
      header: true,
      child: Stack(children: [
        ExcludeSemantics(
            child: Text(text,
                style: TextStyle(
                    fontSize: 32,
                    foreground: Paint()
                      ..color = AppColors.black
                      ..strokeWidth = 1.25
                      ..style = PaintingStyle.stroke,
                    height: 1))),
        Text(text, style: const TextStyle(color: AppColors.black, fontSize: 32, height: 1))
      ]));
}
