import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_colors.dart';
import 'package:mmf/core/theme/app_spacing.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'package:mmf/presentation/widgets/app_text_field.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({super.key, this.isRequired = false, required this.label, required this.value, required this.items, required this.onChanged});

  final bool isRequired;

  final String label;
  final String value;

  final List<String> items;

  final ValueChanged<String> onChanged;

  Widget _buildSheet(BuildContext context) => SafeArea(
      top: false,
      child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.pill), color: AppColors.gray3),
                height: AppSpacing.sheetHandleHeight,
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                width: AppSpacing.sheetHandleWidth),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(children: [Text(label, style: const TextStyle(color: AppColors.black, fontFamily: AppTheme.fontFamily, fontSize: 18, fontWeight: FontWeight.w600))])),
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 0),
            Flexible(child: ListView(shrinkWrap: true, children: [for (final item in items) _buildOption(context, item)]))
          ])));

  Widget _buildOption(BuildContext context, String item) {
    final isSelected = item == value;
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xs),
        onTap: () {
          onChanged(item);
          Navigator.pop(context);
        },
        title: Text(item, style: TextStyle(color: isSelected ? AppColors.green3 : AppColors.black, fontFamily: AppTheme.fontFamily, fontSize: 16, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
        trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.green3, size: AppSpacing.iconLg) : null);
  }

  @override
  Widget build(BuildContext context) => AppTextField(
      key: ValueKey(value),
      hintText: 'Select ${label.toLowerCase()}',
      initialValue: value,
      isRequired: isRequired,
      label: label,
      onTap: () =>
          showModalBottomSheet(backgroundColor: AppColors.white1, builder: _buildSheet, context: context, useSafeArea: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)))),
      readOnly: true,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_outlined, color: AppColors.gray5, size: AppSpacing.iconMd));
}
