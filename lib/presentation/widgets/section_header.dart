import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_colors.dart';
import 'package:mmf/core/theme/app_spacing.dart';
import 'package:mmf/core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, required this.icon});

  final String title;

  final IconData icon;

  @override
  Widget build(BuildContext context) => Semantics(
      header: true,
      child: Row(children: [
        Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.sm), color: AppColors.green2.withValues(alpha: 0.15)),
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Icon(icon, color: AppColors.green3, size: AppSpacing.iconLg)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.black, fontFamily: AppTheme.fontFamily, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2)))
      ]));
}
