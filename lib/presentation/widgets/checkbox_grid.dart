import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_colors.dart';
import 'package:mmf/core/theme/app_spacing.dart';
import 'package:mmf/core/theme/app_theme.dart';

class CheckboxGrid extends StatelessWidget {
  const CheckboxGrid({super.key, required this.items, required this.selectedItems, required this.onChanged});

  final List<String> items;
  final List<String> selectedItems;

  final ValueChanged<String> onChanged;

  Widget _buildOption(String item) {
    final isSelected = selectedItems.contains(item);
    return Semantics(
        checked: isSelected,
        child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.md),
            onTap: () => onChanged(item),
            child: AnimatedContainer(
                constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
                decoration: BoxDecoration(
                    border: Border.all(color: isSelected ? AppColors.green3 : AppColors.outlineGray, width: isSelected ? AppSpacing.borderThick : AppSpacing.borderMedium),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    color: isSelected ? AppColors.green2.withValues(alpha: 0.15) : AppColors.white1),
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  AnimatedContainer(
                      decoration: BoxDecoration(
                          border: Border.all(color: isSelected ? AppColors.green3 : AppColors.outlineGray, width: AppSpacing.borderThick),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                          color: isSelected ? AppColors.green3 : Colors.transparent),
                      duration: const Duration(milliseconds: 200),
                      height: AppSpacing.checkboxSize,
                      width: AppSpacing.checkboxSize,
                      child: isSelected ? const Icon(Icons.check_rounded, color: AppColors.white1, size: AppSpacing.iconXs) : null),
                  const SizedBox(width: AppSpacing.md),
                  Flexible(child: Text(item, style: TextStyle(color: isSelected ? AppColors.green3 : AppColors.black, fontFamily: AppTheme.fontFamily, fontSize: 16, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)))
                ]))));
  }

  @override
  Widget build(BuildContext context) => Wrap(runSpacing: AppSpacing.md, spacing: AppSpacing.md, children: [for (final item in items) _buildOption(item)]);
}
