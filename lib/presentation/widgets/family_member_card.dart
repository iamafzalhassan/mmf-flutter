import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_colors.dart';
import 'package:mmf/core/theme/app_spacing.dart';
import 'package:mmf/domain/entities/family_member.dart';

class FamilyMemberCard extends StatelessWidget {
  const FamilyMemberCard({super.key, required this.member, required this.onRemove, required this.onTap});

  final FamilyMember member;

  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isHead = member.relationship == 'Head of Family';

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: isHead ? AppColors.green3 : AppColors.gray3, width: isHead ? AppSpacing.borderThick : AppSpacing.borderThin),
            borderRadius: BorderRadius.circular(AppRadius.md),
            color: isHead ? AppColors.green2.withValues(alpha: 0.05) : AppColors.white5.withValues(alpha: 0.3)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.md),
                onTap: onTap,
                child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(children: [
                      Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.pill), color: isHead ? AppColors.green2.withValues(alpha: 0.15) : AppColors.gray1),
                          height: AppSpacing.avatarSize,
                          width: AppSpacing.avatarSize,
                          child: Icon(isHead ? Icons.star_rounded : Icons.person_rounded, color: isHead ? AppColors.green3 : AppColors.gray5, size: AppSpacing.iconLg)),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(member.fullName.isNotEmpty ? member.fullName : 'Unnamed Member', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(member.relationship.isNotEmpty ? member.relationship : 'No relationship set', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.gray5, fontSize: 14)),
                        if (member.mobile.isNotEmpty) ...[const SizedBox(height: AppSpacing.xxs), Text(member.mobile, maxLines: 1, style: const TextStyle(color: AppColors.gray5, fontSize: 13))]
                      ])),
                      IconButton(color: AppColors.green3, icon: const Icon(Icons.edit_rounded), onPressed: onTap, tooltip: 'Edit member'),
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(color: AppColors.red, icon: const Icon(Icons.delete_rounded), onPressed: onRemove, tooltip: 'Remove member')
                    ])))));
  }
}
