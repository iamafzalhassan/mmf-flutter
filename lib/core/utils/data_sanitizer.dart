abstract final class DataSanitizer {
  static String sanitizeAddress(String address) =>
      address.toUpperCase().trim().replaceAll(RegExp(r'\s+'), ' ').replaceAll(RegExp(r',+'), ',').replaceAll(RegExp(r'\s+,'), ',').replaceAll(RegExp(r',\s*'), ', ').replaceAll(RegExp(r',\s*$'), '');

  static String sanitizeAdmissionNo(String admissionNo) => admissionNo.toUpperCase().trim().replaceAll(RegExp(r'\s+'), ' ').replaceAll(RegExp(r'[^\dA-Z\-/\s]'), '');

  static String sanitizeDigits(String value) => value.replaceAll(RegExp(r'\D'), '');

  static String sanitizeList(List<String> values) => values.where((item) => item.trim().isNotEmpty).map(sanitizeString).join(', ');

  static String sanitizeString(String value) => value.toUpperCase().trim().replaceAll(RegExp(r'\s+'), ' ').replaceAllMapped(RegExp(r'\s+([.,!?;:])'), (match) => match[1]!).replaceAll(RegExp(r'\(\s+'), '(').replaceAll(RegExp(r'\s+\)'), ')');

  static String sanitizeNic(String nic) => nic.toUpperCase().replaceAll(RegExp(r'[^\dVX]'), '');
}
