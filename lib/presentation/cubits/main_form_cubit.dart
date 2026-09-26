import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/main_form.dart';
import 'package:mmf/domain/usecases/submit_form.dart';
import 'package:mmf/presentation/cubits/main_form_state.dart';

class MainFormCubit extends Cubit<MainFormState> {
  static const String headOfFamily = 'Head of Family';

  final SubmitForm _submitForm;

  MainFormCubit(this._submitForm) : super(MainFormState(refNo: _newRefNo()));

  void addFamilyMember(FamilyMember member) => emit(state.copyWith(familyMembers: [...state.familyMembers, member]));

  void removeFamilyMember(int index) => emit(state.copyWith(familyMembers: [
        for (final (i, member) in state.familyMembers.indexed)
          if (i != index) member
      ]));

  Future<void> submit({required bool fieldsValid}) async {
    if (state.familyMembers.isEmpty) return _reportError('Please add at least one family member.');
    if (!hasExistingHead()) return _reportError('Please designate one member as Head of Family.');
    if (!fieldsValid) return;
    emit(state.copyWith(isLoading: true, isSuccess: false));
    final result =
        await _submitForm(MainForm(address: state.address, admissionNo: state.admissionNo, familiesCount: state.familiesCount, ownership: state.ownership, refNo: state.refNo, route: state.route, familyMembers: state.familyMembers));
    result.fold((failure) => emit(state.copyWith(errorMessage: failure.message, isLoading: false)), (_) => emit(MainFormState(isSuccess: true, refNo: _newRefNo())));
  }

  bool hasExistingHead({int? excludeIndex}) => state.familyMembers.indexed.any((entry) => entry.$1 != excludeIndex && entry.$2.relationship == headOfFamily);

  void updateAddress(String value) => emit(state.copyWith(address: value));

  void updateAdmissionNo(String value) => emit(state.copyWith(admissionNo: value));

  void updateFamiliesCount(String value) => emit(state.copyWith(familiesCount: value));

  void updateFamilyMember(int index, FamilyMember member) => emit(state.copyWith(familyMembers: [for (final (i, old) in state.familyMembers.indexed) i == index ? member : old]));

  void updateOwnership(String value) => emit(state.copyWith(ownership: value));

  void updateRoute(String value) => emit(state.copyWith(route: value));

  static String _newRefNo() => 'KJM-${100000 + Random().nextInt(900000)}';

  void _reportError(String message) {
    emit(state.copyWith());
    emit(state.copyWith(errorMessage: message));
  }
}
