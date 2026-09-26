import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_colors.dart';
import 'package:mmf/core/theme/app_spacing.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'package:mmf/presentation/widgets/app_loader.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, this.isLoading = false, required this.text, this.icon, required this.onPressed});

  final bool isLoading;

  final String text;

  final IconData? icon;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [BoxShadow(blurRadius: AppSpacing.shadowBlurLg, color: AppColors.green3.withValues(alpha: 0.3), offset: const Offset(0, AppSpacing.shadowOffsetLg))],
          color: AppColors.green3),
      height: AppSpacing.controlHeight,
      width: double.infinity,
      child: Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.md),
              onTap: isLoading ? null : onPressed,
              child: Center(
                  child: isLoading
                      ? const AppLoader(color: AppColors.white1)
                      : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(text, style: const TextStyle(color: AppColors.white1, fontFamily: AppTheme.fontFamily, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                          if (icon != null) ...[const SizedBox(width: AppSpacing.sm), Icon(icon, color: AppColors.white1, size: AppSpacing.iconMd)]
                        ])))));
}
