import 'package:mmf/core/utils/data_sanitizer.dart';

class FamilyMember {
  final String age;
  final String alYear;
  final String civilStatus;
  final String fullName;
  final String gender;
  final String mobile;
  final String nationalIdNo;
  final String occupation;
  final String professionalQualificationsDetails;
  final String relationship;
  final String status;
  final String vocationalCourseDetails;
  final String whatsappNo;
  final String zakath;

  final List<String> madarasa;
  final List<String> professionalQualifications;
  final List<String> schoolEducation;
  final List<String> specialNeeds;
  final List<String> ulama;

  const FamilyMember({
    this.age = '',
    this.alYear = '',
    this.civilStatus = '',
    this.fullName = '',
    this.gender = '',
    this.mobile = '',
    this.nationalIdNo = '',
    this.occupation = '',
    this.professionalQualificationsDetails = '',
    this.relationship = '',
    this.status = '',
    this.vocationalCourseDetails = '',
    this.whatsappNo = '',
    this.zakath = '',
    this.madarasa = const [],
    this.professionalQualifications = const [],
    this.schoolEducation = const [],
    this.specialNeeds = const [],
    this.ulama = const [],
  });

  FamilyMember copyWith({
    String? age,
    String? alYear,
    String? civilStatus,
    String? fullName,
    String? gender,
    String? mobile,
    String? nationalIdNo,
    String? occupation,
    String? professionalQualificationsDetails,
    String? relationship,
    String? status,
    String? vocationalCourseDetails,
    String? whatsappNo,
    String? zakath,
    List<String>? madarasa,
    List<String>? professionalQualifications,
    List<String>? schoolEducation,
    List<String>? specialNeeds,
    List<String>? ulama,
  }) =>
      FamilyMember(
        age: age ?? this.age,
        alYear: alYear ?? this.alYear,
        civilStatus: civilStatus ?? this.civilStatus,
        fullName: fullName ?? this.fullName,
        gender: gender ?? this.gender,
        mobile: mobile ?? this.mobile,
        nationalIdNo: nationalIdNo ?? this.nationalIdNo,
        occupation: occupation ?? this.occupation,
        professionalQualificationsDetails: professionalQualificationsDetails ?? this.professionalQualificationsDetails,
        relationship: relationship ?? this.relationship,
        status: status ?? this.status,
        vocationalCourseDetails: vocationalCourseDetails ?? this.vocationalCourseDetails,
        whatsappNo: whatsappNo ?? this.whatsappNo,
        zakath: zakath ?? this.zakath,
        madarasa: madarasa ?? this.madarasa,
        professionalQualifications: professionalQualifications ?? this.professionalQualifications,
        schoolEducation: schoolEducation ?? this.schoolEducation,
        specialNeeds: specialNeeds ?? this.specialNeeds,
        ulama: ulama ?? this.ulama,
      );

  Map<String, dynamic> toJson() => {
        'age': DataSanitizer.sanitizeDigits(age),
        'alYear': DataSanitizer.sanitizeDigits(alYear),
        'civilStatus': DataSanitizer.sanitizeString(civilStatus),
        'fullName': DataSanitizer.sanitizeString(fullName),
        'gender': DataSanitizer.sanitizeString(gender),
        'mobile': DataSanitizer.sanitizeDigits(mobile),
        'nationalIdNo': DataSanitizer.sanitizeNic(nationalIdNo),
        'occupation': DataSanitizer.sanitizeString(occupation),
        'professionalQualificationsDetails': DataSanitizer.sanitizeString(professionalQualificationsDetails),
        'relationship': DataSanitizer.sanitizeString(relationship),
        'status': DataSanitizer.sanitizeString(status),
        'vocationalCourseDetails': DataSanitizer.sanitizeString(vocationalCourseDetails),
        'whatsappNo': DataSanitizer.sanitizeDigits(whatsappNo),
        'zakath': DataSanitizer.sanitizeString(zakath),
        'madarasa': DataSanitizer.sanitizeList(madarasa),
        'professionalQualifications': DataSanitizer.sanitizeList(professionalQualifications),
        'schoolEducation': DataSanitizer.sanitizeList(schoolEducation),
        'specialNeeds': DataSanitizer.sanitizeList(specialNeeds),
        'ulama': DataSanitizer.sanitizeList(ulama),
      };
}
