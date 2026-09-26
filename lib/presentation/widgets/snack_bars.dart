import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_colors.dart';
import 'package:mmf/core/theme/app_spacing.dart';

extension SnackBars on BuildContext {
  void showErrorSnackBar(String message) => _showSnackBar(backgroundColor: AppColors.red, icon: Icons.info_rounded, message: message);

  void showSuccessSnackBar(String message) => _showSnackBar(backgroundColor: AppColors.green3, icon: Icons.check_circle_rounded, message: message);

  void _showSnackBar({required Color backgroundColor, required IconData icon, required String message}) => ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      content: Row(children: [Icon(icon, color: AppColors.white1), const SizedBox(width: AppSpacing.md), Expanded(child: Text(message, style: const TextStyle(color: AppColors.white1, fontSize: 16)))]),
      margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(this).height - AppSpacing.snackBarTopOffset, left: AppSpacing.xl, right: AppSpacing.xl)));
}
