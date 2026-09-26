import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/domain/entities/family_member.dart';

class FamilyMemberCubit extends Cubit<FamilyMember> {
  FamilyMemberCubit(super.initialState);

  void toggleMadarasa(String value) => emit(state.copyWith(madarasa: _toggled(state.madarasa, value)));

  void toggleProfessionalQualification(String value) {
    final list = _toggled(state.professionalQualifications, value);
    emit(state.copyWith(professionalQualifications: list, professionalQualificationsDetails: list.isEmpty ? '' : null, vocationalCourseDetails: list.contains('Vocational Course') ? null : ''));
  }

  void toggleSchoolEducation(String value) => emit(state.copyWith(alYear: value == 'A/L' && state.schoolEducation.contains(value) ? '' : null, schoolEducation: _toggled(state.schoolEducation, value)));

  void toggleSpecialNeeds(String value) => emit(state.copyWith(specialNeeds: _toggled(state.specialNeeds, value)));

  void toggleUlama(String value) => emit(state.copyWith(ulama: _toggled(state.ulama, value)));

  void updateAge(String value) => emit(state.copyWith(age: value));

  void updateAlYear(String value) => emit(state.copyWith(alYear: value));

  void updateCivilStatus(String value) => emit(state.copyWith(civilStatus: value));

  void updateGender(String value) => emit(state.copyWith(gender: value, relationship: relationshipsFor(value).contains(state.relationship) ? null : '', ulama: state.ulama.where(ulamaFor(value).contains).toList()));

  static List<String> relationshipsFor(String gender) => switch (gender) {
        'Male' => const ['Head of Family', 'Spouse', 'Son', 'Father', 'Brother', 'Grandson', 'Other'],
        'Female' => const ['Head of Family', 'Spouse', 'Daughter', 'Mother', 'Sister', 'Granddaughter', 'Other'],
        _ => const ['Head of Family', 'Spouse', 'Son', 'Daughter', 'Father', 'Mother', 'Brother', 'Sister', 'Grandson', 'Granddaughter', 'Other'],
      };

  static List<String> ulamaFor(String gender) => switch (gender) {
        'Male' => const ['Hafiz', 'Alim'],
        'Female' => const ['Hafiza', 'Alima'],
        _ => const ['Hafiz', 'Hafiza', 'Alim', 'Alima'],
      };

  void updateMobile(String value) => emit(state.copyWith(mobile: value));

  void updateName(String value) => emit(state.copyWith(fullName: value));

  void updateNic(String value) => emit(state.copyWith(nationalIdNo: value));

  void updateOccupation(String value) => emit(state.copyWith(occupation: value));

  void updateProfessionalQualificationsDetails(String value) => emit(state.copyWith(professionalQualificationsDetails: value));

  void updateRelationship(String value) => emit(state.copyWith(relationship: value));

  void updateStatus(String value) => emit(state.copyWith(status: value));

  void updateVocationalCourseDetails(String value) => emit(state.copyWith(vocationalCourseDetails: value));

  void updateWhatsappNo(String value) => emit(state.copyWith(whatsappNo: value));

  List<String> _toggled(List<String> list, String value) => list.contains(value) ? list.where((item) => item != value).toList() : [...list, value];
}
