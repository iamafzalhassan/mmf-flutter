import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/theme/app_colors.dart';
import 'package:mmf/core/theme/app_spacing.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/presentation/cubits/main_form_cubit.dart';
import 'package:mmf/presentation/cubits/main_form_state.dart';
import 'package:mmf/presentation/pages/family_form_page.dart';
import 'package:mmf/presentation/widgets/app_dropdown.dart';
import 'package:mmf/presentation/widgets/app_text_field.dart';
import 'package:mmf/presentation/widgets/family_member_card.dart';
import 'package:mmf/presentation/widgets/page_title.dart';
import 'package:mmf/presentation/widgets/primary_button.dart';
import 'package:mmf/presentation/widgets/section_header.dart';
import 'package:mmf/presentation/widgets/snack_bars.dart';

class MahallaFormPage extends StatefulWidget {
  const MahallaFormPage({super.key});

  @override
  State<MahallaFormPage> createState() => _MahallaFormPageState();
}

class _MahallaFormPageState extends State<MahallaFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildHouseholdSection(MainFormState state, MainFormCubit cubit) => Column(key: ValueKey(state.refNo), crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(icon: Icons.home_rounded, title: 'Household Information'),
        const SizedBox(height: AppSpacing.xxl),
        AppTextField(initialValue: state.refNo, label: 'Reference No', readOnly: true, suffixIcon: const Icon(Icons.lock_outline_rounded, size: AppSpacing.iconMd)),
        const SizedBox(height: AppSpacing.xl),
        AppTextField(hintText: 'Enter admission number', initialValue: state.admissionNo, label: 'Admission (Sandapaname) No', onChanged: cubit.updateAdmissionNo),
        const SizedBox(height: AppSpacing.xl),
        AppTextField(hintText: 'Enter full address', initialValue: state.address, isRequired: true, label: 'Address', onChanged: cubit.updateAddress),
        const SizedBox(height: AppSpacing.xl),
        AppDropdown(
            isRequired: true,
            items: const [
              '6 Kanuwa',
              'Abatala Road',
              'Abdullah/Imtiyas Scheme',
              'Alba Scheme',
              'Araliya Mawatha',
              'Back to Tibet School',
              'Belagama',
              'Bogawattha',
              'Brendiyawattha Main Road',
              'D.P Lane 1',
              'D.P Lane 2',
              'D.P Lane 3',
              'D.P Lane 4',
              'D.P Lane 5',
              'D.P Line Road 1',
              'D.P Line Road 2',
              'D.P Line Road 3',
              'D.P Line Road 4',
              'Dahamwella',
              'Ebutana',
              'Gewale 20',
              'Godella',
              'Katupalella',
              'Kelanimulla',
              'Kirimandala',
              'Kotigawattha Main Road',
              'Kurusa Handiya',
              'L.S Perera',
              'Mahattha',
              'Mosque to Abatala Junction',
              'Mosque to Polwanguwa/Fahim House',
              'Mulleriyawa New Town',
              'Nagavela',
              'Nelumpokuna',
              'Pubudugama',
              'Rajasingha Gama',
              'T.C Road',
              'Tea Stores',
              'W.M Lane 1',
              'W.M Lane 2',
              'W.M Lane 3',
              'W.M Lane 4',
              'W.M Lane 5',
              'W.M Lane 6',
              'W.M Lane 7',
              'Walewala'
            ],
            label: 'Route',
            onChanged: cubit.updateRoute,
            value: state.route),
        const SizedBox(height: AppSpacing.xl),
        AppDropdown(isRequired: true, items: const ['Own', 'Rent'], label: 'House Ownership', onChanged: cubit.updateOwnership, value: state.ownership),
        const SizedBox(height: AppSpacing.xl),
        AppTextField(
            hintText: 'Enter number of families',
            initialValue: state.familiesCount,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
            isRequired: true,
            keyboardType: TextInputType.number,
            label: 'Families in Home',
            onChanged: cubit.updateFamiliesCount,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'This field is required';
              final count = int.tryParse(value!);
              return count == null || count < 1 ? 'Please enter a valid number (min 1)' : null;
            })
      ]);

  Widget _buildFamilyMembersSection(BuildContext context, MainFormState state, MainFormCubit cubit) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(icon: Icons.people_rounded, title: 'Family Members'),
        if (state.familyMembers.isEmpty)
          const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.lg, top: AppSpacing.xxxl),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.info_outline_rounded, color: AppColors.green3, size: AppSpacing.iconMd),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: Text('Required to add at least one member as Head of Family.', style: TextStyle(color: AppColors.gray5, fontSize: 16, height: 1.25)))
              ]))
        else
          const SizedBox(height: AppSpacing.xxxl),
        for (final (index, member) in state.familyMembers.indexed)
          Padding(padding: const EdgeInsets.only(bottom: AppSpacing.lg), child: FamilyMemberCard(member: member, onRemove: () => cubit.removeFamilyMember(index), onTap: () => _openMemberForm(context, cubit, index))),
        SizedBox(
            height: AppSpacing.controlHeight,
            width: double.infinity,
            child: OutlinedButton.icon(
                icon: const Icon(Icons.add_circle_outline_rounded, size: AppSpacing.iconMd),
                label: const Text('Add Family Member', style: TextStyle(fontSize: 18)),
                onPressed: () => _openMemberForm(context, cubit),
                style: OutlinedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero)))
      ]);

  Future<void> _openMemberForm(BuildContext context, MainFormCubit cubit, [int? index]) async {
    final member = await Navigator.push<FamilyMember>(context, MaterialPageRoute(builder: (_) => FamilyFormPage(existingMember: index == null ? null : cubit.state.familyMembers[index])));
    if (member == null) return;
    if (member.relationship == MainFormCubit.headOfFamily && cubit.hasExistingHead(excludeIndex: index)) {
      if (context.mounted) context.showErrorSnackBar(index == null ? 'A Head of Family already exists. Only one Head of Family is allowed.' : "A Head of Family already exists. Please change the existing Head's relationship first.");
      return;
    }
    index == null ? cubit.addFamilyMember(member) : cubit.updateFamilyMember(index, member);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Container(
          decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
          child: BlocConsumer<MainFormCubit, MainFormState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  context.showErrorSnackBar(state.errorMessage!);
                } else if (state.isSuccess) {
                  context.showSuccessSnackBar('Form submitted successfully.');
                }
              },
              listenWhen: (previous, current) => previous.isSuccess != current.isSuccess || previous.errorMessage != current.errorMessage,
              builder: (context, state) {
                final cubit = context.read<MainFormCubit>();
                return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: SafeArea(
                        child: Center(
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                                child: Form(
                                    key: _formKey,
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      const Padding(
                                          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            PageTitle('Mahalla Members Details Collection Form 2025'),
                                            SizedBox(height: AppSpacing.xs),
                                            Text('Kohilawatta JM & Burial Ground', style: TextStyle(color: AppColors.gray5, fontSize: 22, height: 1))
                                          ])),
                                      const SizedBox(height: AppSpacing.lg),
                                      Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.md), color: AppColors.white1),
                                          padding: const EdgeInsets.all(AppSpacing.lg),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            _buildHouseholdSection(state, cubit),
                                            const SizedBox(height: AppSpacing.xxxl),
                                            const Divider(height: AppSpacing.hairline),
                                            const SizedBox(height: AppSpacing.xxxl),
                                            _buildFamilyMembersSection(context, state, cubit),
                                            const SizedBox(height: AppSpacing.xxxl),
                                            PrimaryButton(icon: Icons.arrow_circle_right_rounded, isLoading: state.isLoading, onPressed: () => cubit.submit(fieldsValid: _formKey.currentState?.validate() ?? false), text: 'Submit Form')
                                          ]))
                                    ]))))));
              })));
}
