import 'package:mmf/core/utils/data_sanitizer.dart';
import 'package:mmf/domain/entities/family_member.dart';

class MainForm {
  final String address;
  final String admissionNo;
  final String familiesCount;
  final String ownership;
  final String refNo;
  final String route;

  final List<FamilyMember> familyMembers;

  MainForm({required this.address, required this.admissionNo, required this.familiesCount, required this.ownership, required this.refNo, required this.route, required this.familyMembers});

  Map<String, dynamic> toJson() => {
        'address': DataSanitizer.sanitizeAddress(address),
        'admissionNo': DataSanitizer.sanitizeAdmissionNo(admissionNo),
        'familiesCount': DataSanitizer.sanitizeDigits(familiesCount),
        'ownership': DataSanitizer.sanitizeString(ownership),
        'refNo': DataSanitizer.sanitizeString(refNo),
        'route': DataSanitizer.sanitizeString(route),
        'familyMembers': familyMembers.map((m) => m.toJson()).toList()
      };
}
