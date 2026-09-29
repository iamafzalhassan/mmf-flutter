import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/theme/app_colors.dart';
import 'package:mmf/core/theme/app_spacing.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/presentation/cubits/family_member_cubit.dart';
import 'package:mmf/presentation/cubits/main_form_cubit.dart';
import 'package:mmf/presentation/widgets/app_dropdown.dart';
import 'package:mmf/presentation/widgets/app_text_field.dart';
import 'package:mmf/presentation/widgets/checkbox_grid.dart';
import 'package:mmf/presentation/widgets/page_title.dart';
import 'package:mmf/presentation/widgets/primary_button.dart';
import 'package:mmf/presentation/widgets/snack_bars.dart';

class FamilyFormPage extends StatefulWidget {
  const FamilyFormPage({super.key, this.existingMember});

  final FamilyMember? existingMember;

  @override
  State<FamilyFormPage> createState() => _FamilyFormPageState();
}

class _FamilyFormPageState extends State<FamilyFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final FamilyMemberCubit _cubit = FamilyMemberCubit(widget.existingMember ?? const FamilyMember());

  bool get _isEditing => widget.existingMember != null;

  Widget _buildHeader(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxxl, top: AppSpacing.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Tooltip(
            message: 'Back',
            child: Semantics(
                button: true,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        boxShadow: [BoxShadow(blurRadius: AppSpacing.shadowBlurSm, color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, AppSpacing.shadowOffsetSm))],
                        color: AppColors.white1),
                    height: AppSpacing.backButtonSize,
                    width: AppSpacing.backButtonSize,
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(borderRadius: BorderRadius.circular(AppRadius.pill), onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_rounded, color: AppColors.black, size: AppSpacing.iconMd)))))),
        const SizedBox(height: AppSpacing.lg),
        PageTitle(_isEditing ? 'Edit Family Member' : 'Add Family Member')
      ]));

  Widget _buildPersonalInfo(FamilyMember member) {
    final isHead = member.relationship == MainFormCubit.headOfFamily;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [
        Icon(Icons.person_rounded, color: AppColors.green3, size: AppSpacing.iconLg),
        SizedBox(width: AppSpacing.md),
        Expanded(child: Text('Personal Information', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.w600)))
      ]),
      const SizedBox(height: AppSpacing.xxl),
      AppTextField(hintText: 'Enter full name', initialValue: member.fullName, isRequired: true, label: 'Full Name', onChanged: _cubit.updateName),
      const SizedBox(height: AppSpacing.xl),
      AppDropdown(isRequired: true, items: const ['Male', 'Female'], label: 'Gender', onChanged: _cubit.updateGender, value: member.gender),
      const SizedBox(height: AppSpacing.xl),
      AppTextField(hintText: 'Enter age', initialValue: member.age, inputFormatters: [FilteringTextInputFormatter.digitsOnly], isRequired: true, keyboardType: TextInputType.number, label: 'Age', onChanged: _cubit.updateAge),
      const SizedBox(height: AppSpacing.xl),
      AppTextField(
          hintText: 'Enter phone number',
          initialValue: member.mobile,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
          isRequired: isHead,
          keyboardType: TextInputType.phone,
          label: 'Mobile No',
          onChanged: _cubit.updateMobile,
          validator: (value) => isHead && (value?.isEmpty ?? true) ? 'Mobile number is required for Head of Family' : _phoneError(value, 'Invalid mobile number')),
      const SizedBox(height: AppSpacing.xl),
      AppTextField(
          hintText: 'Enter WhatsApp number',
          initialValue: member.whatsappNo,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
          keyboardType: TextInputType.phone,
          label: 'WhatsApp No',
          onChanged: _cubit.updateWhatsappNo,
          validator: (value) => _phoneError(value, 'Invalid WhatsApp number')),
      const SizedBox(height: AppSpacing.xl),
      AppTextField(hintText: 'Enter NIC', initialValue: member.nationalIdNo, label: 'National ID No', onChanged: _cubit.updateNic),
      const SizedBox(height: AppSpacing.xl),
      AppDropdown(isRequired: true, items: const ['Studying Only', 'Working Only', 'Studying and Working', 'Not Working/Studying'], label: 'Status', onChanged: _cubit.updateStatus, value: member.status),
      const SizedBox(height: AppSpacing.xl),
      if (member.status == 'Working Only' || member.status == 'Studying and Working') ...[
        AppTextField(hintText: 'Enter Occupation/Business', initialValue: member.occupation, isRequired: true, label: 'Occupation/Business', onChanged: _cubit.updateOccupation),
        const SizedBox(height: AppSpacing.xl)
      ],
      AppDropdown(isRequired: true, items: const ['Married', 'Single', 'Divorced', 'Widow'], label: 'Civil Status', onChanged: _cubit.updateCivilStatus, value: member.civilStatus),
      const SizedBox(height: AppSpacing.xl),
      AppDropdown(isRequired: true, items: FamilyMemberCubit.relationshipsFor(member.gender), label: 'Relationship to Head', onChanged: _cubit.updateRelationship, value: member.relationship)
    ]);
  }

  String? _phoneError(String? value, String message) => (value?.isNotEmpty ?? false) && (value!.length != 10 || !value.startsWith('07')) ? message : null;

  Widget _buildSection(IconData icon, String title, List<Widget> children) => Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.gray3), borderRadius: BorderRadius.circular(AppRadius.lg), color: AppColors.white5.withValues(alpha: 0.3)),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: AppColors.green3, size: AppSpacing.iconLg),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600)))
        ]),
        const SizedBox(height: AppSpacing.lg),
        ...children
      ]));

  Widget _buildActionButtons(BuildContext context) => Row(children: [
        Expanded(
            child: SizedBox(
                height: AppSpacing.controlHeight,
                child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero), child: const Text('Cancel', style: TextStyle(fontSize: 18))))),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
            child: PrimaryButton(
                icon: Icons.check_circle_rounded,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.pop(context, _cubit.state);
                  } else {
                    context.showErrorSnackBar('Please fill all required fields correctly.');
                  }
                },
                text: _isEditing ? 'Update' : 'Add'))
      ]);

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Container(
          decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
          child: BlocBuilder<FamilyMemberCubit, FamilyMember>(
              bloc: _cubit,
              builder: (context, member) => SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: SafeArea(
                      child: Center(
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                _buildHeader(context),
                                Form(
                                    key: _formKey,
                                    child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.md), color: AppColors.white1),
                                        padding: const EdgeInsets.all(AppSpacing.lg),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          _buildPersonalInfo(member),
                                          const SizedBox(height: AppSpacing.xxxl),
                                          const Divider(height: AppSpacing.hairline),
                                          const SizedBox(height: AppSpacing.xxxl),
                                          _buildSection(Icons.favorite_rounded, 'Special Needs', [
                                            CheckboxGrid(items: const ['Disabled', 'Medical Support', 'Education Support', 'Converted'], onChanged: _cubit.toggleSpecialNeeds, selectedItems: member.specialNeeds)
                                          ]),
                                          const SizedBox(height: AppSpacing.xxl),
                                          _buildSection(Icons.local_library_rounded, 'School Education', [
                                            CheckboxGrid(items: const ['Primary', 'Above Grade 8', 'O/L', 'A/L', 'Abroad Student'], onChanged: _cubit.toggleSchoolEducation, selectedItems: member.schoolEducation),
                                            if (member.schoolEducation.contains('A/L')) ...[
                                              const SizedBox(height: AppSpacing.lg),
                                              AppTextField(
                                                  hintText: 'Enter A/L year (e.g. 2020)',
                                                  initialValue: member.alYear,
                                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                                                  isRequired: true,
                                                  keyboardType: TextInputType.number,
                                                  label: 'A/L Year',
                                                  onChanged: _cubit.updateAlYear,
                                                  validator: (value) {
                                                    if (value?.isEmpty ?? true) return 'A/L year is required';
                                                    final year = int.tryParse(value!);
                                                    return year == null || year < 1950 || year > DateTime.now().year + 1 ? 'Enter a valid year' : null;
                                                  })
                                            ]
                                          ]),
                                          const SizedBox(height: AppSpacing.xxl),
                                          _buildSection(Icons.school_rounded, 'Professional Qualifications', [
                                            CheckboxGrid(
                                                items: const ['Certificate', 'Diploma', 'Degree', "Master's Degree", 'Phd', FamilyMemberCubit.vocationalCourse],
                                                onChanged: _cubit.toggleProfessionalQualification,
                                                selectedItems: member.professionalQualifications),
                                            if (member.professionalQualifications.isNotEmpty) ...[
                                              const SizedBox(height: AppSpacing.lg),
                                              AppTextField(
                                                  hintText: 'e.g. Diploma in Nursing, BSc in Psychology, Plumbing, Electrical',
                                                  initialValue: member.professionalQualificationsDetails,
                                                  isRequired: true,
                                                  label: 'Qualification Details',
                                                  onChanged: _cubit.updateProfessionalQualificationsDetails,
                                                  validator: (value) => (value?.isEmpty ?? true) ? 'Please specify your qualifications' : null)
                                            ],
                                            if (member.professionalQualifications.contains(FamilyMemberCubit.vocationalCourse)) ...[
                                              const SizedBox(height: AppSpacing.lg),
                                              AppTextField(
                                                  hintText: 'e.g. Plumbing, Electrical, Welding',
                                                  initialValue: member.vocationalCourseDetails,
                                                  isRequired: true,
                                                  label: 'Vocational Course Details',
                                                  onChanged: _cubit.updateVocationalCourseDetails,
                                                  validator: (value) => (value?.isEmpty ?? true) ? 'Please specify your vocational course' : null)
                                            ]
                                          ]),
                                          const SizedBox(height: AppSpacing.xxl),
                                          _buildSection(Icons.local_library_rounded, 'Madarasa Education', [
                                            CheckboxGrid(items: const ['Kitab Part Time', 'Kitab Full Time', 'Hifz Part Time', 'Hifz Full Time'], onChanged: _cubit.toggleMadarasa, selectedItems: member.madarasa)
                                          ]),
                                          const SizedBox(height: AppSpacing.xxl),
                                          _buildSection(Icons.school_rounded, 'Ulama Qualifications', [CheckboxGrid(items: FamilyMemberCubit.ulamaFor(member.gender), onChanged: _cubit.toggleUlama, selectedItems: member.ulama)]),
                                          const SizedBox(height: AppSpacing.xxxl),
                                          _buildActionButtons(context)
                                        ])))
                              ]))))))));
}
